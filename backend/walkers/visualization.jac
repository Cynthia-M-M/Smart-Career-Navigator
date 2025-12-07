"""
Graph Visualization Walkers
"""

from backend.models.data_types import GraphVisualization;
from backend.agents.explainer_agent import explainer_visualize_career_path;

walker graph_visualization_walker {
    has user_id: str = "";
    has focus_node_type: str = "user";  # "user", "role", "skill"
    has focus_node_id: str = "";
    has layout: str = "force";  # "force", "hierarchical", "circular"
    has depth: int = 2;  # Traversal depth
    
    can User;
    can Role;
    can Skill;
    can Course;
    can Certification;
    can JobPosting;
    
    with root {
        nodes = [];
        edges = [];
        node_map = {};  # Track nodes to avoid duplicates
        
        # Determine starting node
        start_node = null;
        
        if focus_node_id:
            # Find specific node
            take --> node::User;
            if here.id == focus_node_id:
                start_node = here;
            take --> node::Role;
            if here.id == focus_node_id:
                start_node = here;
            take --> node::Skill;
            if here.id == focus_node_id:
                start_node = here;
        elif user_id:
            # Start from user
            take --> node::User;
            if here.id == user_id or here.email == user_id:
                start_node = here;
        else:
            # Start from root
            start_node = root;
        
        if not start_node:
            report {"error": "Starting node not found"};
            disengage;
        
        # Traverse graph and collect nodes/edges
        spawn start_node walker::collect_graph_data(
            nodes=nodes,
            edges=edges,
            node_map=node_map,
            depth=depth,
            current_depth=0
        );
        
        # Format for visualization
        formatted_nodes = [];
        for node_data in nodes:
            formatted_nodes.push({
                "id": node_data["id"],
                "label": node_data["label"],
                "type": node_data["type"],
                "data": node_data["data"]
            });
        
        formatted_edges = [];
        for edge_data in edges:
            formatted_edges.push({
                "from": edge_data["from"],
                "to": edge_data["to"],
                "type": edge_data["type"],
                "label": edge_data.get("label", "")
            });
        
        report {
            "nodes": formatted_nodes,
            "edges": formatted_edges,
            "layout": layout,
            "focus_node": focus_node_id if focus_node_id else start_node.id
        };
    }
}

walker collect_graph_data {
    has nodes: list;
    has edges: list;
    has node_map: dict;
    has depth: int;
    has current_depth: int;
    
    can User;
    can Role;
    can Skill;
    can Course;
    can Certification;
    can JobPosting;
    
    with node {
        if current_depth > depth:
            disengage;
        
        # Add current node
        node_id = node.id;
        if node_id not in node_map:
            node_type = "unknown";
            node_label = "Unknown";
            node_data = {};
            
            if std.isinstance(node, node(User)):
                node_type = "user";
                node_label = node.name;
                node_data = {
                    "name": node.name,
                    "email": node.email,
                    "current_role": node.current_role
                };
            elif std.isinstance(node, node(Role)):
                node_type = "role";
                node_label = node.title;
                node_data = {
                    "title": node.title,
                    "industry": node.industry,
                    "level": node.level
                };
            elif std.isinstance(node, node(Skill)):
                node_type = "skill";
                node_label = node.name;
                node_data = {
                    "name": node.name,
                    "category": node.category,
                    "market_demand": node.market_demand_score
                };
            elif std.isinstance(node, node(Course)):
                node_type = "course";
                node_label = node.title;
                node_data = {
                    "title": node.title,
                    "provider": node.provider
                };
            elif std.isinstance(node, node(Certification)):
                node_type = "certification";
                node_label = node.name;
                node_data = {
                    "name": node.name,
                    "issuer": node.issuer
                };
            elif std.isinstance(node, node(JobPosting)):
                node_type = "job";
                node_label = node.title;
                node_data = {
                    "title": node.title,
                    "company": node.company
                };
            
            nodes.push({
                "id": node_id,
                "label": node_label,
                "type": node_type,
                "data": node_data
            });
            node_map[node_id] = True;
        
        # Traverse edges
        # UserSkill edges
        take --> node::Skill(-[user_skill]->node::User);
        if there.id == node.id:
            edge_id = f"{node_id}_user_skill_{here.id}";
            if edge_id not in node_map:
                edges.push({
                    "from": node_id,
                    "to": here.id,
                    "type": "user_skill",
                    "label": f"Proficiency: {here.user_skill.proficiency}"
                });
                node_map[edge_id] = True;
                spawn here walker::collect_graph_data(
                    nodes=nodes,
                    edges=edges,
                    node_map=node_map,
                    depth=depth,
                    current_depth=current_depth + 1
                );
        
        # RequiredSkill edges
        take --> node::Skill(-[required_skill]->node::Role);
        if there.id == node.id:
            edge_id = f"{node_id}_required_skill_{here.id}";
            if edge_id not in node_map:
                edges.push({
                    "from": node_id,
                    "to": here.id,
                    "type": "required_skill",
                    "label": "Required"
                });
                node_map[edge_id] = True;
                spawn here walker::collect_graph_data(
                    nodes=nodes,
                    edges=edges,
                    node_map=node_map,
                    depth=depth,
                    current_depth=current_depth + 1
                );
        
        # TeachesSkill edges
        take --> node::Course(-[teaches_skill]->node::Skill);
        if there.id == node.id:
            edge_id = f"{node_id}_teaches_skill_{here.id}";
            if edge_id not in node_map:
                edges.push({
                    "from": node_id,
                    "to": here.id,
                    "type": "teaches_skill",
                    "label": "Teaches"
                });
                node_map[edge_id] = True;
                spawn here walker::collect_graph_data(
                    nodes=nodes,
                    edges=edges,
                    node_map=node_map,
                    depth=depth,
                    current_depth=current_depth + 1
                );
    }
}

