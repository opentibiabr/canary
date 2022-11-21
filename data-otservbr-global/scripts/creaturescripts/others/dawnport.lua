-- Teleport to the dawnport temple after reaching level 20 (the player has five minutes before being teleported)
local function teleportToDawnportTemple(uid)
	local player = Player(uid)
	-- If not have the Oressa storage, teleport player to the temple
	if player and player:getStorageValue(Storage.Dawnport.DoorVocation) == -1 then
		player:teleportTo(player:getTown():getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
end

local dawnportAdvance = CreatureEvent("DawnportAdvance")

function dawnportAdvance.onAdvance(player, skill, oldLevel, newLevel)
	local town = player:getTown()
	-- Check that resides on dawnport
	if town and town:getId() == TOWNS_LIST.DAWNPORT then
		if skill == SKILL_LEVEL then
			-- Notify min level to leave dawnport
			if newLevel == 8 then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"Congratulations! \z
					You may now choose your vocation and leave Dawnport. Talk to Oressa in the temple."
				)
			-- Notify max level to stay in dawnport
			elseif newLevel >= 20 then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"You have reached the limit level and have to choose your vocation and leave Dawnport."
				)
				-- Adds the event that teleports the player to the temple in five minutes after reaching level 20
				addEvent(teleportToDawnportTemple, 5 * 60 * 1000, player:getId())
			end
		-- Notify reached a skill limit
		elseif skill ~= SKILL_LEVEL and isSkillGrowthLimited(player, skill) then
			if skill == SKILL_MAGLEVEL then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"You cannot train your magic level any further. \z
					If you want to improve it further, you must go to the mainland."
				)
			else
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"You cannot train your skill level any further. \z
					If you want to improve it further, you must go to the mainland."
				)
			end
		end
	end
	return true
end

dawnportAdvance:register()
