"""
Main App Component with Routing - Jac Client
"""

cl import from jac:client_runtime { createState, navigate, useRouter, onMount };
cl import from frontend.pages.login { LoginPage };
cl import from frontend.pages.dashboard { DashboardPage };
cl import from frontend.pages.skill_profile { SkillProfilePage };
cl import from frontend.pages.career_path { CareerPathPage };
cl import from frontend.pages.courses { CoursesPage };
cl import from frontend.pages.jobs { JobsPage };
cl import from frontend.pages.graph_visualizer { GraphVisualizerPage };
cl import from frontend.pages.settings { SettingsPage };
cl import from frontend.components.notification_center { NotificationCenter };
cl import from frontend.components.resume_uploader { ResumeUploader };

cl {
    def App() -> any {
        let [currentPath, setCurrentPath] = createState("");
        
        # Simple hash-based routing
        def updateRoute() -> None {
            hash = window.location.hash;
            path = hash.slice(1) || "/dashboard";
            setCurrentPath(path);
        }
        
        onMount(lambda -> None {
            updateRoute();
            window.addEventListener("hashchange", updateRoute);
        });
        
        def renderPage() -> any {
            if currentPath == "/login" || currentPath == "":
                return <LoginPage />;
            elif currentPath == "/dashboard":
                return <DashboardPage />;
            elif currentPath == "/skill-profile":
                return <SkillProfilePage />;
            elif currentPath == "/career-path":
                return <CareerPathPage />;
            elif currentPath == "/courses":
                return <CoursesPage />;
            elif currentPath == "/jobs":
                return <JobsPage />;
            elif currentPath == "/graph":
                return <GraphVisualizerPage />;
            elif currentPath == "/settings":
                return <SettingsPage />;
            else:
                return <DashboardPage />;
        }
        
        # Navigation component
        def Navigation() -> any {
            return <nav class="bg-white shadow-lg">
                <div class="max-w-7xl mx-auto px-4">
                    <div class="flex justify-between items-center h-16">
                        <div class="flex items-center">
                            <h1 class="text-xl font-bold text-gray-800">Career Navigator</h1>
                        </div>
                        <div class="flex items-center space-x-4">
                            <a
                                href="#/dashboard"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Dashboard
                            </a>
                            <a
                                href="#/skill-profile"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Skills
                            </a>
                            <a
                                href="#/career-path"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Career Path
                            </a>
                            <a
                                href="#/courses"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Courses
                            </a>
                            <a
                                href="#/jobs"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Jobs
                            </a>
                            <a
                                href="#/graph"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Graph
                            </a>
                            <NotificationCenter />
                            <a
                                href="#/settings"
                                class="text-gray-600 hover:text-gray-800"
                            >
                                Settings
                            </a>
                        </div>
                    </div>
                </div>
            </nav>;
        }
        
        return <div>
            {currentPath != "/login" ? <Navigation /> : null}
            <main>
                {renderPage()}
            </main>
        </div>;
    }
}

