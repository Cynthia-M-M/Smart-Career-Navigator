"""
Notification Center Component - Jac Client
"""

cl import from jac:client_runtime { createState };

cl {
    def NotificationCenter() -> any {
        let [notifications, setNotifications] = createState([]);
        let [isOpen, setIsOpen] = createState(false);
        
        # In a real implementation, this would subscribe to real-time notifications
        # For now, we'll use mock data
        
        return <div class="relative">
            <button
                class="relative p-2 text-gray-600 hover:text-gray-800"
                onclick={() -> None { setIsOpen(!isOpen); }}
            >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                </svg>
                {notifications.length > 0 ? (
                    <span class="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500"></span>
                ) : null}
            </button>
            
            {isOpen ? (
                <div class="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-xl z-50">
                    <div class="p-4 border-b">
                        <h3 class="font-semibold">Notifications</h3>
                    </div>
                    <div class="max-h-96 overflow-y-auto">
                        {notifications.length > 0 ? (
                            <div class="divide-y">
                                {notifications.map(lambda notif: any -> any {
                                    return <div class="p-4 hover:bg-gray-50">
                                        <div class="font-semibold text-sm">{notif.title}</div>
                                        <div class="text-xs text-gray-600">{notif.message}</div>
                                    </div>;
                                })}
                            </div>
                        ) : (
                            <div class="p-4 text-center text-gray-500">
                                No notifications
                            </div>
                        )}
                    </div>
                </div>
            ) : null}
        </div>;
    }
}

