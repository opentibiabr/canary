local addons = TalkAction("/addaddon")

function addons.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local target
	local split = param:split(",")
	local name = split[1]

	if param == "" then
		target = player:getTarget()
		if not target then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gives players the ability to wear addon for a specific outfit. Usage: /addaddon <player name>, <looktype>")
			return true
		end
	else
		target = Player(name)
	end

	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. name .. " is currently not online.")
		return false
	end

	local looktype = tonumber(split[2])
	if not looktype then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid looktype.")
		return false
	end

	local addons = tonumber(split[3])
	if not addons or addons < 0 or addons > 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid addon.")
		return false
	end

	target:addOutfitAddon(looktype, addons)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Addon for looktype  " .. looktype .. "a for " .. target:getName() .. " set to " .. addons .. ".")
	return false
end

addons:separator(" ")
addons:groupType("god")
addons:register()
