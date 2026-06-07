local talkaction = TalkAction("/outfit")

function talkaction.onSay(player, words, param)
	if param == "" then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Usage: /outfit <looktype|monster>[,player]")
		return true
	end

	local t = param:split(",")
	local lookParam = t[1] and t[1]:trim() or ""
	local lookType

	local numeric = tonumber(lookParam)
	if numeric then
		lookType = numeric
	else
		local mType = MonsterType(lookParam)
		if not mType then
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Monster '" .. lookParam .. "' not found.")
			return true
		end
		lookType = mType:getOutfit().lookType
	end

	local target = player
	if t[2] and t[2]:trim() ~= "" then
		target = Player(t[2]:trim())
		if not target then
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Player '" .. t[2]:trim() .. "' not found.")
			return true
		end
	end

	local outfit = target:getOutfit()
	outfit.lookType = lookType
	target:setOutfit(outfit)

	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Set lookType " .. lookType .. " on " .. target:getName() .. ".")
	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
