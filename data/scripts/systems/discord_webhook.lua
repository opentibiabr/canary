-- Sends Discord webhook notifications.
-- The URL layout is https://discord.com/api/webhooks/:id/:token
-- Leave empty if you wish to disable.

if not announcementChannels then
	announcementChannels = {
		["serverAnnouncements"] = "https://discord.com/api/webhooks/1307043463581274183/mCcAUq8Ng2oGWEcOQZ5eo4slsPeTZMcCJdUm84e5hfhzVmlsOSkUBWRhmlMA_3fT8Al4", -- Used for an announcement channel on your discord
		["raids"] = "https://discord.com/api/webhooks/1307752397430460417/9RNxW6FSt75UuzQH5vmgcJSlVTO5j4_UdETcsO18TJY74xcJkQ96EprERtvtbq1DkHgM", -- Used to isolate raids on your discord
		["player-kills"] = "https://discord.com/api/webhooks/1307754047154946109/8aG9q_m__bfteMFiGqwMfr4C-NuITg0I6BWumAGjz6t_UuGxwL4NFEA6UQJBE5g4ObhO", -- Self-explaining
		["player-levels"] = "https://discord.com/api/webhooks/1307752225895878686/wBYj0stqfKMrf6fHNxSIXc-SJXfatSQuDuwswGWQxw-REZhJVqKFkEnZky8nH570fvdE", -- Self-explaining
		["logs"] = "https://discord.com/api/webhooks/1307754232463622155/YsePOAsRNuVW3iIGyBFXRyhkTY7MoQ5zpSwZilXXjbqx8dHM6KVEA7YSWRq4qlUrnWKV",
		["punishments"] = "https://discord.com/api/webhooks/1307759545577111744/n55co_NG4a4MViK2A1MX8fSaw7RJ90kRbXpxbfD8ZLzANw0QTJ04XSs8bA0VVJzxut0E",
		["reports"] = "https://discord.com/api/webhooks/1307769122486091856/N3L3BOcCgEcPTyvNStbCQBFjOZoA4899nD3UP-lORGUkLTCo3fftbKhxlD6HQFsSv9n4",
	}
end

--[[
	Example of notification (After you do the config):
	This is going to send a message into your server announcements channel

	local message = blablabla
	local title = test
	Webhook.sendMessage(title, message, WEBHOOK_COLOR_YELLOW,
                        announcementChannels["serverAnnouncements"])

	Dev Comment: This lib can be used to add special webhook channels
	where you are going to send your messages. Webhook.specialSend was designed
	to be used with countless possibilities.
]]
