"""
Career Path Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount };
cl import from frontend.services.api { recommendRoles, generateLearningPath };
cl import from frontend.components.career_timeline { CareerTimeline };
cl import from frontend.components.roadmap_generator { RoadmapGenerator };

cl {
    def CareerPathPage() -> any {
        let [roles, setRoles] = createState([]);
        let [learningPath, setLearningPath] = createState(null);
        let [selectedRole, setSelectedRole] = createState(null);
        let [loading, setLoading] = createState(true);
        
        onMount(lambda -> None {
            async def loadCareerPath() -> None {
                try {
                    userId = "demo@example.com";
                    recommendations = await recommendRoles(userId, 10);
                    if recommendations && recommendations.recommendations:
                        setRoles(recommendations.recommendations);
                } except Exception as e {
                    console.error("Error loading career path:", e);
                } finally {
                    setLoading(False);
                }
            }
            loadCareerPath();
        });
        
        async def loadLearningPath(roleTitle: str) -> None {
            setLoading(True);
            try {
                userId = "demo@example.com";
                path = await generateLearningPath(userId, "", roleTitle);
                setLearningPath(path);
                setSelectedRole(roleTitle);
            } catch Exception as e {
                console.error("Error loading learning path:", e);
            } finally {
                setLoading(False);
            }
        }
        
        if loading && !learningPath {
            return <div class="p-8">Loading...</div>;
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-6xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Career Path</h1>
                
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h2 class="text-xl font-semibold mb-4">Recommended Roles</h2>
                        <div class="space-y-4">
                            {roles.map(lambda role: any -> any {
                                return <div
                                    class="border rounded p-4 cursor-pointer hover:bg-gray-50"
                                    onclick={() -> None { loadLearningPath(role.title); }}
                                >
                                    <h3 class="font-semibold text-lg">{role.title}</h3>
                                    <p class="text-sm text-gray-600">Match: {(role.match_score * 100).toFixed(0)}%</p>
                                    <p class="text-sm text-gray-600">Industry: {role.industry}</p>
                                    <p class="text-sm text-gray-600">
                                        Salary: ${role.salary_range.min.toLocaleString()} - ${role.salary_range.max.toLocaleString()}
                                    </p>
                                </div>;
                            })}
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        {learningPath ? (
                            <div>
                                <h2 class="text-xl font-semibold mb-4">Learning Path for {selectedRole}</h2>
                                <RoadmapGenerator path={learningPath.learning_path} />
                                <CareerTimeline milestones={learningPath.learning_path?.roadmap?.milestones || []} />
                            </div>
                        ) : (
                            <div class="text-center text-gray-500">
                                Select a role to see learning path
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>;
    }
}

