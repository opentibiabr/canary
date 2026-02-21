local weaponProficiency = TalkAction("/proficiency")
function weaponProficiency.onSay(player, words, param)
	-- Create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local experience = tonumber(param)
	if not experience then
		player:sendCancelMessage("Usage: /proficiency <experience>")
		return true
	end

	player:addWeaponExperience(experience, 0)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Added %d weapon experience to your equipped weapon.", experience))

	return true
end

weaponProficiency:separator(" ")
weaponProficiency:groupType("god")
weaponProficiency:register()
