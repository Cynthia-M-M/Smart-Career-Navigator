"""
Login Page - Jac Client
"""

cl import from jac:client_runtime { createState, navigate, jacLogin, jacIsLoggedIn };
cl import from frontend.services.api { };

cl {
    def LoginPage() -> any {
        let [email, setEmail] = createState("");
        let [password, setPassword] = createState("");
        let [loading, setLoading] = createState(false);
        let [error, setError] = createState("");
        
        # Check if already logged in
        onMount(lambda -> None {
            if jacIsLoggedIn() {
                navigate("/dashboard");
            }
        });
        
        async def handleLogin() -> None {
            setLoading(True);
            setError("");
            
            try {
                success = await jacLogin(email, password);
                if success {
                    navigate("/dashboard");
                } else {
                    setError("Invalid email or password");
                }
            } except Exception as e {
                setError("Login failed: " + str(e));
            } finally {
                setLoading(False);
            }
        }
        
        return <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
            <div class="bg-white p-8 rounded-lg shadow-xl w-full max-w-md">
                <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">
                    Smart Career Navigator
                </h1>
                <h2 class="text-xl text-center mb-8 text-gray-600">
                    Sign In
                </h2>
                
                {error ? <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    {error}
                </div> : null}
                
                <form onsubmit={(e) -> None { e.preventDefault(); handleLogin(); }}>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            Email
                        </label>
                        <input
                            type="email"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            value={email}
                            oninput={(e) -> None { setEmail(e.target.value); }}
                            required
                        />
                    </div>
                    
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            Password
                        </label>
                        <input
                            type="password"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            value={password}
                            oninput={(e) -> None { setPassword(e.target.value); }}
                            required
                        />
                    </div>
                    
                    <button
                        type="submit"
                        class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
                        disabled={loading}
                    >
                        {loading ? "Signing in..." : "Sign In"}
                    </button>
                </form>
                
                <p class="mt-4 text-center text-sm text-gray-600">
                    Demo: Use any email/password to continue
                </p>
            </div>
        </div>;
    }
}

