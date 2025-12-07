"""
Course Recommendations Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount };
cl import from frontend.services.api { recommendCourses };

cl {
    def CoursesPage() -> any {
        let [courses, setCourses] = createState([]);
        let [loading, setLoading] = createState(true);
        
        onMount(lambda -> None {
            async def loadCourses() -> None {
                try {
                    userId = "demo@example.com";
                    recommendations = await recommendCourses(userId, [], 20);
                    if recommendations && recommendations.courses:
                        setCourses(recommendations.courses);
                } except Exception as e {
                    console.error("Error loading courses:", e);
                } finally {
                    setLoading(False);
                }
            }
            loadCourses();
        });
        
        if loading {
            return <div class="p-8">Loading courses...</div>;
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-6xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Course Recommendations</h1>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {courses.map(lambda course: any -> any {
                        return <div class="bg-white rounded-lg shadow p-6">
                            <h3 class="text-lg font-semibold mb-2">{course.title}</h3>
                            <p class="text-sm text-gray-600 mb-2">Provider: {course.provider}</p>
                            <p class="text-sm text-gray-600 mb-2">Teaches: {course.teaches_skill}</p>
                            <div class="flex items-center mb-2">
                                <span class="text-yellow-500">★</span>
                                <span class="ml-1">{course.rating.toFixed(1)}</span>
                            </div>
                            <p class="text-sm text-gray-600 mb-4">
                                Duration: {course.duration_hours} hours | Cost: ${course.cost}
                            </p>
                            <a
                                href={course.url}
                                target="_blank"
                                class="text-blue-600 hover:text-blue-800 font-semibold"
                            >
                                View Course →
                            </a>
                        </div>;
                    })}
                </div>
            </div>
        </div>;
    }
}

