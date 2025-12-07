"""
Skill Profile Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount };
cl import from frontend.services.api { getUserProfile, analyzeSkillGaps };
cl import from frontend.components.skill_gap_heatmap { SkillGapHeatmap };

cl {
    def SkillProfilePage() -> any {
        let [user, setUser] = createState(null);
        let [skillGaps, setSkillGaps] = createState(null);
        let [loading, setLoading] = createState(true);
        
        onMount(lambda -> None {
            async def loadProfile() -> None {
                try {
                    userId = "demo@example.com";
                    profile = await getUserProfile(userId);
                    setUser(profile);
                    
                    if profile && profile.target_role:
                        gaps = await analyzeSkillGaps(userId, "", profile.target_role);
                        setSkillGaps(gaps);
                } except Exception as e {
                    console.error("Error loading profile:", e);
                } finally {
                    setLoading(False);
                }
            }
            loadProfile();
        });
        
        if loading {
            return <div class="p-8">Loading...</div>;
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-6xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Skill Profile</h1>
                
                {user && user.skills ? (
                    <div class="bg-white p-6 rounded-lg shadow mb-6">
                        <h2 class="text-xl font-semibold mb-4">Your Skills</h2>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            {user.skills.map(lambda skill: any -> any {
                                return <div class="border rounded p-3">
                                    <div class="font-semibold">{skill.skill_name}</div>
                                    <div class="text-sm text-gray-600">Proficiency: {(skill.proficiency * 100).toFixed(0)}%</div>
                                    <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                                        <div
                                            class="bg-blue-600 h-2 rounded-full"
                                            style={{"width": (skill.proficiency * 100) + "%"}}
                                        ></div>
                                    </div>
                                </div>;
                            })}
                        </div>
                    </div>
                ) : null}
                
                {skillGaps ? (
                    <div class="bg-white p-6 rounded-lg shadow">
                        <h2 class="text-xl font-semibold mb-4">Skill Gap Analysis</h2>
                        <SkillGapHeatmap gaps={skillGaps.gap_analysis} />
                        
                        {skillGaps.critical_gaps && skillGaps.critical_gaps.length > 0 ? (
                            <div class="mt-6">
                                <h3 class="text-lg font-semibold text-red-600 mb-2">Critical Gaps</h3>
                                <ul class="list-disc list-inside space-y-2">
                                    {skillGaps.critical_gaps.map(lambda gap: any -> any {
                                        return <li class="text-gray-700">
                                            {gap.skill}: Gap of {(gap.gap * 100).toFixed(0)}%
                                        </li>;
                                    })}
                                </ul>
                            </div>
                        ) : null}
                    </div>
                ) : null}
            </div>
        </div>;
    }
}

