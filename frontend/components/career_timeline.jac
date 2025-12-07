"""
Career Timeline Component - Jac Client
"""

cl {
    def CareerTimeline(milestones: list) -> any {
        if !milestones || milestones.length == 0 {
            return <div class="text-gray-500">No milestones available</div>;
        }
        
        return <div class="relative">
            {milestones.map(lambda milestone: any, index: int -> any {
                isLast = index == milestones.length - 1;
                return <div class="flex mb-6">
                    <div class="flex flex-col items-center mr-4">
                        <div class="w-4 h-4 bg-blue-600 rounded-full"></div>
                        {!isLast ? <div class="w-0.5 h-full bg-gray-300 mt-2"></div> : null}
                    </div>
                    <div class="flex-1 pb-6">
                        <h3 class="text-lg font-semibold text-gray-800">{milestone.name}</h3>
                        <p class="text-gray-600 text-sm mb-2">{milestone.description}</p>
                        <div class="text-sm text-gray-500">
                            Estimated: {milestone.estimated_days} days
                        </div>
                        {milestone.target_skills && milestone.target_skills.length > 0 ? (
                            <div class="mt-2 flex flex-wrap gap-2">
                                {milestone.target_skills.map(lambda skill: any -> any {
                                    return <span class="bg-indigo-100 text-indigo-800 text-xs px-2 py-1 rounded">
                                        {skill}
                                    </span>;
                                })}
                            </div>
                        ) : null}
                    </div>
                </div>;
            })}
        </div>;
    }
}

