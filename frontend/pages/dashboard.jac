"""
Dashboard Page - Jac Client
"""

cl import from jac:client_runtime { createState, navigate, onMount };
cl import from frontend.services.api { getUserProfile, recommendRoles, getMarketTrends };

cl {
    def DashboardPage() -> any {
        let [user, setUser] = createState(null);
        let [roleRecommendations, setRoleRecommendations] = createState([]);
        let [marketTrends, setMarketTrends] = createState(null);
        let [loading, setLoading] = createState(true);
        
        onMount(lambda -> None {
            async def loadDashboard() -> None {
                try {
                    # Get user profile (using demo user for now)
                    userId = "demo@example.com";
                    profile = await getUserProfile(userId);
                    setUser(profile);
                    
                    # Get role recommendations
                    roles = await recommendRoles(userId, 5);
                    if roles and roles.recommendations:
                        setRoleRecommendations(roles.recommendations);
                    
                    # Get market trends
                    trends = await getMarketTrends(90);
                    setMarketTrends(trends);
                } except Exception as e {
                    console.error("Error loading dashboard:", e);
                } finally {
                    setLoading(False);
                }
            }
            loadDashboard();
        });
        
        if loading {
            return <div class="p-8">
                <div class="text-center">Loading dashboard...</div>
            </div>;
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-7xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">
                    Welcome back, {user ? user.name : "User"}!
                </h1>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h3 class="text-lg font-semibold text-gray-700 mb-2">Current Role</h3>
                        <p class="text-2xl font-bold text-blue-600">{user ? user.current_role : "Not set"}</p>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h3 class="text-lg font-semibold text-gray-700 mb-2">Target Role</h3>
                        <p class="text-2xl font-bold text-indigo-600">{user ? user.target_role : "Not set"}</p>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h3 class="text-lg font-semibold text-gray-700 mb-2">Skills</h3>
                        <p class="text-2xl font-bold text-green-600">{user && user.skills ? user.skills.length : 0}</p>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h2 class="text-xl font-bold text-gray-800 mb-4">Top Role Recommendations</h2>
                        {roleRecommendations.length > 0 ? (
                            <div class="space-y-4">
                                {roleRecommendations.map(lambda rec: any -> any {
                                    return <div class="border-l-4 border-blue-500 pl-4 py-2">
                                        <h3 class="font-semibold text-gray-800">{rec.title}</h3>
                                        <p class="text-sm text-gray-600">Match: {(rec.match_score * 100).toFixed(0)}%</p>
                                        <p class="text-sm text-gray-600">Market Demand: {rec.market_demand.toFixed(2)}</p>
                                    </div>;
                                })}
                            </div>
                        ) : (
                            <p class="text-gray-500">No recommendations yet</p>
                        )}
                        <button
                            class="mt-4 text-blue-600 hover:text-blue-800"
                            onclick={() -> None { navigate("/career-path"); }}
                        >
                            View All Recommendations →
                        </button>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h2 class="text-xl font-bold text-gray-800 mb-4">Quick Actions</h2>
                        <div class="space-y-2">
                            <button
                                class="w-full text-left px-4 py-2 bg-blue-50 hover:bg-blue-100 rounded"
                                onclick={() -> None { navigate("/skill-profile"); }}
                            >
                                View Skill Profile
                            </button>
                            <button
                                class="w-full text-left px-4 py-2 bg-indigo-50 hover:bg-indigo-100 rounded"
                                onclick={() -> None { navigate("/courses"); }}
                            >
                                Browse Courses
                            </button>
                            <button
                                class="w-full text-left px-4 py-2 bg-green-50 hover:bg-green-100 rounded"
                                onclick={() -> None { navigate("/jobs"); }}
                            >
                                Find Jobs
                            </button>
                            <button
                                class="w-full text-left px-4 py-2 bg-purple-50 hover:bg-purple-100 rounded"
                                onclick={() -> None { navigate("/graph"); }}
                            >
                                View Skill Graph
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>;
    }
}

