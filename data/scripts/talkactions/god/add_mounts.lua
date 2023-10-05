-- /addmounts playername

local mounts = TalkAction("/addmounts")
function mounts.onSay(player, words, param)
	local target
	if param == "" then
		target = player:getTarget()
		if not target then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Unlocks all mounts for certain player. Usage: /mounts <player name>")
			return true
		end
	else
		target = Player(param)
	end

	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. param .. " is not currently online.")
		return true
	end

	for i = 1, 217 do
		target:addMount(i)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All mounts unlocked for: " .. target:getName())
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All of your mounts have been unlocked!")
	return true
end

mounts:separator(" ")
mounts:groupType("god")
mounts:register()
