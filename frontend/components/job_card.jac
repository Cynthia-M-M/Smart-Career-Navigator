"""
Job Card Component - Jac Client
"""

cl {
    def JobCard(job: dict) -> any {
        matchScore = job.match_score || 0;
        matchPercentage = (matchScore * 100).toFixed(0);
        
        return <div class="bg-white border rounded-lg p-6 shadow hover:shadow-lg transition">
            <div class="flex justify-between items-start mb-4">
                <div>
                    <h3 class="text-xl font-semibold text-gray-800">{job.title}</h3>
                    <p class="text-gray-600">{job.company}</p>
                    <p class="text-sm text-gray-500">{job.location}</p>
                </div>
                <div class="text-right">
                    <div class="text-lg font-bold text-blue-600">{matchPercentage}% Match</div>
                    <div class="text-sm text-gray-500">Match Score</div>
                </div>
            </div>
            
            {job.salary_range ? (
                <div class="mb-4">
                    <p class="text-gray-700">
                        <span class="font-semibold">Salary:</span> 
                        ${job.salary_range.min.toLocaleString()} - ${job.salary_range.max.toLocaleString()}
                    </p>
                </div>
            ) : null}
            
            {job.required_skills ? (
                <div class="mb-4">
                    <p class="text-sm font-semibold text-gray-700 mb-2">Required Skills:</p>
                    <div class="flex flex-wrap gap-2">
                        {job.required_skills.map(lambda skill: any -> any {
                            return <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded">
                                {skill}
                            </span>;
                        })}
                    </div>
                </div>
            ) : null}
            
            {job.application_url ? (
                <a
                    href={job.application_url}
                    target="_blank"
                    class="inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
                >
                    Apply Now →
                </a>
            ) : null}
        </div>;
    }
}

