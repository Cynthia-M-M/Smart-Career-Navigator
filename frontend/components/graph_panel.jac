"""
Graph Panel Component - Jac Client
Visualizes OSP graph using a simple canvas-based approach
"""

cl {
    def GraphPanel(nodes: list, edges: list, layout: str) -> any {
        # This is a simplified visualization
        # In production, you'd use a library like D3.js or vis.js
        # For now, we'll create a simple representation
        
        return <div class="w-full h-96 border rounded bg-gray-50 p-4 overflow-auto">
            <div class="text-sm text-gray-600 mb-4">
                Graph: {nodes.length} nodes, {edges.length} edges
            </div>
            
            <div class="relative" style={{"minHeight": "400px"}}>
                {nodes.map(lambda node: any -> any {
                    # Simple positioning (in real implementation, use force layout)
                    x = 100 + (node.id.hashCode() % 500);
                    y = 100 + ((node.id.hashCode() * 7) % 300);
                    
                    colorMap = {
                        "user": "bg-blue-500",
                        "skill": "bg-green-500",
                        "role": "bg-purple-500",
                        "course": "bg-yellow-500",
                        "certification": "bg-orange-500",
                        "job": "bg-red-500"
                    };
                    color = colorMap.get(node.type, "bg-gray-500");
                    
                    return <div
                        class={"absolute " + color + " text-white text-xs px-2 py-1 rounded cursor-pointer"}
                        style={{"left": x + "px", "top": y + "px"}}
                        title={node.label}
                    >
                        {node.label}
                    </div>;
                })}
            </div>
            
            <div class="mt-4 text-xs text-gray-500">
                Note: This is a simplified visualization. For production, integrate D3.js or vis.js for interactive graph rendering.
            </div>
        </div>;
    }
}

