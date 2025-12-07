"""
Roadmap Generator Component - Jac Client
"""

cl {
    def RoadmapGenerator(path: dict) -> any {
        if !path {
            return <div class="text-gray-500">No roadmap available</div>;
        }
        
        roadmap = path.roadmap || {};
        milestones = roadmap.milestones || [];
        weeklyPlan = roadmap.weekly_plan || [];
        
        return <div>
            <div class="mb-6">
                <h3 class="text-lg font-semibold mb-2">Overview</h3>
                <div class="grid grid-cols-3 gap-4">
                    <div class="bg-blue-50 p-4 rounded">
                        <div class="text-sm text-gray-600">Duration</div>
                        <div class="text-xl font-bold">{roadmap.total_estimated_days || 0} days</div>
                    </div>
                    <div class="bg-green-50 p-4 rounded">
                        <div class="text-sm text-gray-600">Difficulty</div>
                        <div class="text-xl font-bold">{roadmap.difficulty || "N/A"}</div>
                    </div>
                    <div class="bg-purple-50 p-4 rounded">
                        <div class="text-sm text-gray-600">Total Cost</div>
                        <div class="text-xl font-bold">${roadmap.total_estimated_cost || 0}</div>
                    </div>
                </div>
            </div>
            
            {milestones.length > 0 ? (
                <div class="mb-6">
                    <h3 class="text-lg font-semibold mb-4">Milestones</h3>
                    <div class="space-y-4">
                        {milestones.map(lambda milestone: any -> any {
                            return <div class="border-l-4 border-indigo-500 pl-4 py-2">
                                <h4 class="font-semibold">{milestone.name}</h4>
                                <p class="text-sm text-gray-600">{milestone.description}</p>
                                <p class="text-xs text-gray-500 mt-1">
                                    {milestone.estimated_days} days
                                </p>
                            </div>;
                        })}
                    </div>
                </div>
            ) : null}
            
            {weeklyPlan.length > 0 ? (
                <div>
                    <h3 class="text-lg font-semibold mb-4">Weekly Plan</h3>
                    <div class="space-y-2">
                        {weeklyPlan.map(lambda week: any -> any {
                            return <div class="bg-gray-50 p-3 rounded">
                                <div class="font-semibold">Week {week.week}</div>
                                <div class="text-sm text-gray-600">{week.focus}</div>
                            </div>;
                        })}
                    </div>
                </div>
            ) : null}
        </div>;
    }
}

