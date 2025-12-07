"""
Graph Visualizer Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount };
cl import from frontend.services.api { getGraphVisualization };
cl import from frontend.components.graph_panel { GraphPanel };

cl {
    def GraphVisualizerPage() -> any {
        let [graphData, setGraphData] = createState(null);
        let [loading, setLoading] = createState(true);
        let [layout, setLayout] = createState("force");
        
        onMount(lambda -> None {
            loadGraph();
        });
        
        async def loadGraph() -> None {
            setLoading(True);
            try {
                userId = "demo@example.com";
                data = await getGraphVisualization(userId, "", layout);
                setGraphData(data);
            } except Exception as e {
                console.error("Error loading graph:", e);
            } finally {
                setLoading(False);
            }
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-7xl mx-auto">
                <div class="flex justify-between items-center mb-6">
                    <h1 class="text-3xl font-bold text-gray-800">Skill Graph Visualization</h1>
                    <select
                        class="px-4 py-2 border rounded"
                        value={layout}
                        onchange={(e) -> None { setLayout(e.target.value); loadGraph(); }}
                    >
                        <option value="force">Force Layout</option>
                        <option value="hierarchical">Hierarchical</option>
                        <option value="circular">Circular</option>
                    </select>
                </div>
                
                {loading ? (
                    <div class="text-center">Loading graph...</div>
                ) : graphData ? (
                    <div class="bg-white rounded-lg shadow p-6">
                        <GraphPanel nodes={graphData.nodes} edges={graphData.edges} layout={layout} />
                    </div>
                ) : (
                    <div class="text-center text-gray-500">No graph data available</div>
                )}
            </div>
        </div>;
    }
}

