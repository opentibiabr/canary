-- Sends Discord webhook notifications.
-- The URL layout is https://discord.com/api/webhooks/:id/:token
-- Leave empty if you wish to disable.

if not announcementChannels then
	announcementChannels = {
		["serverAnnouncements"] = "https://discord.com/api/webhooks/1199061373079007332/SZlvWTyyWwU2Q7N1g6YJZjqI2enKD4qEKZ1u1rySDGcK7zHqOjV_EFq7NbKvmuaSImw7", -- Used for an announcement channel on your discord
		["raids"] = "https://discord.com/api/webhooks/1199061592445308938/6qZFEdU82lMIMQgyoFm8QL_WXk3UWYYWSxBSwmsn0Wdrb4t1-uWt7mEexsjm-yEx0r5M", -- Used to isolate raids on your discord
		["player-kills"] = "https://discord.com/api/webhooks/1199061808187723926/8f4gnm8iWr9JzlBFjbtInLSVhQZGhV-X_gLW_3dkuAc5XKsn2ynaGAYbkaZkAvC-SpnZ", -- Self-explaining
		["player-levels"] = "", -- Self-explaining
		["reports"] = "https://discord.com/api/webhooks/1199062047040749688/xr6sXri4LRh13jVBYV2lZTQ85mF8DM8TPE7u7gKw7hWeRSvADg6oGK1-hTRcM2b3J3QM",
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
