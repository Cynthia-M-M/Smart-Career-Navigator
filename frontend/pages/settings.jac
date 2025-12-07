"""
Settings Page - Jac Client
"""

cl import from jac:client_runtime { createState, onMount, jacLogout, navigate };
cl import from frontend.services.api { getUserProfile, updateUserGraph };

cl {
    def SettingsPage() -> any {
        let [user, setUser] = createState(null);
        let [targetRole, setTargetRole] = createState("");
        let [saving, setSaving] = createState(false);
        
        onMount(lambda -> None {
            async def loadSettings() -> None {
                try {
                    userId = "demo@example.com";
                    profile = await getUserProfile(userId);
                    setUser(profile);
                    if profile:
                        setTargetRole(profile.target_role || "");
                } except Exception as e {
                    console.error("Error loading settings:", e);
                }
            }
            loadSettings();
        });
        
        async def saveSettings() -> None {
            setSaving(True);
            try {
                userId = "demo@example.com";
                await updateUserGraph(userId, {
                    "target_role": targetRole
                });
                alert("Settings saved!");
            } except Exception as e {
                alert("Error saving settings: " + str(e));
            } finally {
                setSaving(False);
            }
        }
        
        def handleLogout() -> None {
            jacLogout();
            navigate("/login");
        }
        
        return <div class="p-8 bg-gray-50 min-h-screen">
            <div class="max-w-4xl mx-auto">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Settings</h1>
                
                <div class="bg-white rounded-lg shadow p-6 mb-6">
                    <h2 class="text-xl font-semibold mb-4">Profile Settings</h2>
                    
                    <div class="mb-4">
                        <label class="block text-gray-700 font-semibold mb-2">Target Role</label>
                        <input
                            type="text"
                            class="w-full px-4 py-2 border rounded"
                            value={targetRole}
                            oninput={(e) -> None { setTargetRole(e.target.value); }}
                            placeholder="e.g., Senior Software Engineer"
                        />
                    </div>
                    
                    <button
                        class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
                        onclick={saveSettings}
                        disabled={saving}
                    >
                        {saving ? "Saving..." : "Save Settings"}
                    </button>
                </div>
                
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-xl font-semibold mb-4 text-red-600">Danger Zone</h2>
                    <button
                        class="bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700"
                        onclick={handleLogout}
                    >
                        Logout
                    </button>
                </div>
            </div>
        </div>;
    }
}

