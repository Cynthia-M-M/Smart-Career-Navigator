"""
Skill Gap Heatmap Component - Jac Client
"""

cl {
    def SkillGapHeatmap(gaps: list) -> any {
        if !gaps || gaps.length == 0 {
            return <div class="text-gray-500">No gap data available</div>;
        }
        
        # Calculate max gap for scaling
        maxGap = 0;
        for gap in gaps {
            if gap.gap > maxGap:
                maxGap = gap.gap;
        }
        
        def getColor(gap: float) -> str {
            if gap > 0.5:
                return "bg-red-500";
            elif gap > 0.2:
                return "bg-yellow-500";
            else:
                return "bg-green-500";
        }
        
        return <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            {gaps.map(lambda gap: any -> any {
                intensity = (gap.gap / maxGap) * 100;
                return <div class="border rounded p-4">
                    <div class="font-semibold mb-2">{gap.skill}</div>
                    <div class="text-sm text-gray-600 mb-2">
                        Gap: {(gap.gap * 100).toFixed(0)}%
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-4">
                        <div
                            class={getColor(gap.gap) + " h-4 rounded-full"}
                            style={{"width": intensity + "%"}}
                        ></div>
                    </div>
                    <div class="text-xs text-gray-500 mt-1">
                        Priority: {gap.priority.toFixed(2)}
                    </div>
                </div>;
            })}
        </div>;
    }
}

