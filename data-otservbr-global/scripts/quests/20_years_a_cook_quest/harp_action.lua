local harp = Action()

function harp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local icon = player:getIcon("the-rest-of-ratha")
	if icon.count <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are out of inspiration to play.")
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You used your musical inspiration to play a luring tunel!")
	item:transform(TwentyYearsACookQuest.TheRestOfRatha.Items.HarpCooldown)
	fromPosition:sendMagicEffect(CONST_ME_SOUND_GREEN)
	player:setIcon("the-rest-of-ratha", CreatureIconCategory_Quests, CreatureIconQuests_Dove, icon.count - 1)
	addEvent(function(position)
		local tile = Tile(position)
		local harpCooldown = tile and tile:getItemById(TwentyYearsACookQuest.TheRestOfRatha.Items.HarpCooldown) or nil
		if harpCooldown then
			harpCooldown:transform(TwentyYearsACookQuest.TheRestOfRatha.Items.Harp)
		end
	end, 15 * 1000, fromPosition)
	return true
end

harp:id(TwentyYearsACookQuest.TheRestOfRatha.Items.Harp)
harp:register()

local harpCooldown = Action()

function harpCooldown.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	fromPosition:sendMagicEffect(CONST_ME_SOUND_RED)
	return true
end

harpCooldown:id(TwentyYearsACookQuest.TheRestOfRatha.Items.HarpCooldown)
harpCooldown:register()
