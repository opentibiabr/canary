-- Sends Discord webhook special notifications.
-- The URL layout is https://discord.com/api/webhooks/:id/:token
-- Leave empty if you wish to disable.

announcementChannels = {
	["serverAnnouncements"] = "https://discord.com/api/webhooks/917947825910849556/hRf4tCzjNiFFG_hlza96fQ6wgM797Mt0aHW1o8Gw-wEw39GyJsVM4WRS4HM84sTUSzSG", -- Used for an announcement channel on your discord
	["raids"] = "https://discord.com/api/webhooks/917948005691310100/z02hFUonVSWBuRH2V1zJEUELHOKTBrMqfThJxUMrk5CovIzresLAwr_oEo65f4WQyaVv", -- Used to isolate raids on your discord
	["player-kills"] = "https://discord.com/api/webhooks/917948118585204737/67_SpZJM6JA5SZt4kc4FNVjLSFD4ebIyGkf3v8aYnnmb74FXlKUDQRAa-L4nSYf35_IF", -- Self-explaining
}

--[[
	Example of notification (After you do the config):
	This is going to send a message into your server announcements channel
	Webhook.specialSend("Server save", message, WEBHOOK_COLOR_WARNING,
                        announcementChannels["serverAnnouncements"])
	Dev Comment: This lib can be used to add special webhook channels
	where you are going to send your messages. Webhook.specialSend was designed
	to be used with countless possibilities.
]]
