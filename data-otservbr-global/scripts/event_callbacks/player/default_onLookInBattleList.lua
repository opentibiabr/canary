local ec = EventCallback

function ec.onLookInBattleList(player, creature, distance, description)
	description = "You see " .. creature:getDescription(distance)
	if creature:isMonster() then
		local master = creature:getMaster()
		local summons = {'sorcerer familiar','knight familiar','druid familiar','paladin familiar'}
		if master and table.contains(summons, creature:getName():lower()) then
			description = description..' (Master: ' .. master:getName() .. '). \z
				It will disappear in ' .. getTimeinWords(master:getStorageValue(Storage.FamiliarSummon) - os.time())
		end
	end
	if player:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:isPlayer() and creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
		"%s\nPosition: %d, %d, %d",
		description, position.x, position.y, position.z

		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	return description
end

ec:register(--[[0]])
