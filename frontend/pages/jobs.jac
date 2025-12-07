"""
Job Recommendations Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount };
cl import from frontend.services.api { fetchJobData };
cl import from frontend.components.job_card { JobCard };

cl {
    def JobsPage() -> any {
        let [jobs, setJobs] = createState([]);
        let [loading, setLoading] = createState(true);
        let [query, setQuery] = createState("");
        let [location, setLocation] = createState("");
        
        onMount(lambda -> None {
            loadJobs();
        });
        
        async def loadJobs() -> None {
            setLoading(True);
            try {
                result = await fetchJobData(query, location, 20);
                if result && result.jobs_created:
                    # In real implementation, fetch actual job data
                    setJobs([
                        {
                            "title": "Senior Software Engineer",
                            "company": "Tech Corp",
                            "location": "San Francisco, CA",
                            "match_score": 0.85,
                            "salary_range": {"min": 120000, "max": 180000},
                            "application_url": "https://example.com/apply/1"
                        }
                    ]);
            } except Exception as e {
                console.error("Error loading jobs:", e);
            } finally {
                setLoading(False);
            }
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-6xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Job Recommendations</h1>
                
                <div class="bg-white p-4 rounded-lg shadow mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <input
                            type="text"
                            placeholder="Job title or keywords"
                            class="px-4 py-2 border rounded"
                            value={query}
                            oninput={(e) -> None { setQuery(e.target.value); }}
                        />
                        <input
                            type="text"
                            placeholder="Location"
                            class="px-4 py-2 border rounded"
                            value={location}
                            oninput={(e) -> None { setLocation(e.target.value); }}
                        />
                        <button
                            class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700"
                            onclick={loadJobs}
                        >
                            Search
                        </button>
                    </div>
                </div>
                
                {loading ? (
                    <div class="text-center">Loading jobs...</div>
                ) : (
                    <div class="space-y-4">
                        {jobs.map(lambda job: any -> any {
                            return <JobCard job={job} />;
                        })}
                    </div>
                )}
            </div>
        </div>;
    }
}

