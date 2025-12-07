"""
Resume Uploader Component - Jac Client
"""

cl import from jac:client_runtime { createState };
cl import from frontend.services.api { parseResume };

cl {
    def ResumeUploader() -> any {
        let [uploading, setUploading] = createState(false);
        let [uploaded, setUploaded] = createState(false);
        let [error, setError] = createState("");
        
        async def handleFileUpload(file: any) -> None {
            if !file {
                return;
            }
            
            setUploading(True);
            setError("");
            
            try {
                reader = new FileReader();
                reader.onload = async lambda event: any -> None {
                    resumeText = event.target.result;
                    result = await parseResume(resumeText);
                    if result && result.status == "success":
                        setUploaded(True);
                    else:
                        setError("Failed to parse resume");
                };
                reader.readAsText(file);
            } except Exception as e {
                setError("Upload failed: " + str(e));
            } finally {
                setUploading(False);
            }
        }
        
        return <div class="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center">
            {uploaded ? (
                <div class="text-green-600">
                    <svg class="w-12 h-12 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <p class="font-semibold">Resume uploaded successfully!</p>
                </div>
            ) : (
                <div>
                    <input
                        type="file"
                        accept=".pdf,.doc,.docx,.txt"
                        class="hidden"
                        id="resume-upload"
                        onchange={(e) -> None {
                            file = e.target.files[0];
                            if file:
                                handleFileUpload(file);
                        }}
                    />
                    <label
                        for="resume-upload"
                        class="cursor-pointer inline-block bg-blue-600 text-white px-6 py-3 rounded hover:bg-blue-700"
                    >
                        {uploading ? "Uploading..." : "Upload Resume"}
                    </label>
                    {error ? (
                        <p class="mt-2 text-red-600">{error}</p>
                    ) : null}
                </div>
            )}
        </div>;
    }
}

