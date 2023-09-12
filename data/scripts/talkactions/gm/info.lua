local info = TalkAction("/info")

function info.onSay(player, words, param)
	local target = Player(param)
	if not target then
		player:sendCancelMessage("Player not found.")
		return true
	end

	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local targetIp = target:getIp()

	local text = "Player Info: \n\n"
	text = text .. "Name: " .. target:getName() .. "\n"
	text = text .. "Access: " .. (target:getGroup():getAccess() and "1" or "0") .. "\n"
	text = text .. "Speed: " .. target:getSpeed() .. "\n"
	text = text .. "Position: " .. string.format("(%0.5d / %0.5d / %0.3d)", target:getPosition().x, target:getPosition().y, target:getPosition().z) .. "\n"
	text = text .. "IP: " .. Game.convertIpToString(targetIp) .. "\n\n"

	text = text .. "Skills: \n\n"
	text = text .. "* Level: " .. target:getLevel() .. "\n"
	text = text .. "* Skill Axe: " .. target:getSkillLevel(SKILL_AXE) .. "\n"
	text = text .. "* Skill Club: " .. target:getSkillLevel(SKILL_CLUB) .. "\n"
	text = text .. "* Skill Distance: " .. target:getSkillLevel(SKILL_DISTANCE) .. "\n"
	text = text .. "* Skill Fist: " .. target:getSkillLevel(SKILL_FIST) .. "\n"
	text = text .. "* Skill Magic: " .. target:getMagicLevel() .. "\n"
	text = text .. "* Skill Shield: " .. target:getSkillLevel(SKILL_SHIELD) .. "\n"
	text = text .. "* Skill Sword: " .. target:getSkillLevel(SKILL_SWORD) .. "\n"

	player:popupFYI(text)

	local players = {}
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		if targetPlayer:getIp() == targetIp and targetPlayer ~= target then
			players[#players + 1] = targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. "]"
		end
	end

	if #players > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Other players on same IP: " .. table.concat(players, ", ") .. ".")
	end
	return true
end

info:separator(" ")
info:groupType("gamemaster")
info:register()
