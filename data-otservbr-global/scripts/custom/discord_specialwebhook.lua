-- Sends Discord webhook special notifications.
-- The URL layout is https://discord.com/api/webhooks/:id/:token
-- Leave empty if you wish to disable.

announcementChannels = {
	["serverAnnouncements"] = "https://discord.com/api/webhooks/1142149018923835392/7sRCEwkl788mDtec3j-TH82ZFwhrs2XHNMc0nKBjbkkg-WRcziZzYX1IblrvqP7gBk_K", -- Used for an announcement channel on your discord
	["raids"] = "https://discord.com/api/webhooks/1142172083967766550/RPAXNYtdjxOK7Lhnu0UBh-bTGnonyDpx4VgTUrtsBDC9H-1fPgKtu4iaz23lowveNbx3", -- Used to isolate raids on your discord
	["player-kills"] = "https://discord.com/api/webhooks/1142172444803727381/5X_IoTed1sRkdeuIF6GBltK8edRyyX-vYhcs_LedEaMxfDbdWj5zV_-dAxoVjcJead16", -- Self-explaining
}

--[[
	Example of notification (After you do the config):
	This is going to send a message into your server announcements channel

	local message = blablabla
	local title = test
	Webhook.send(title, message, WEBHOOK_COLOR_WARNING,
                        announcementChannels["serverAnnouncements"])

	Dev Comment: This lib can be used to add special webhook channels
	where you are going to send your messages. Webhook.specialSend was designed
	to be used with countless possibilities.
]]
