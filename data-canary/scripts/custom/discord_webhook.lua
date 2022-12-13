-- Sends Discord webhook special notifications.
-- The URL layout is https://discord.com/api/webhooks/:id/:token
-- Leave empty if you wish to disable.

announcementChannels = {
	["serverAnnouncements"] = "", -- Used for an announcement channel on your discord
	["raids"] = "", -- Used to isolate raids on your discord
	["player-kills"] = "", -- Self-explaining
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
