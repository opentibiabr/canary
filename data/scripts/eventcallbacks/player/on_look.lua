local callback = EventCallback()

function callback.playerOnLook(player, thing, position, distance)
	local description = "You see "
	if thing:isItem() then
		if thing.actionid == 5640 then
			description = description .. "a honeyflower patch."
		elseif thing.actionid == 5641 then
			description = description .. "a banana palm."
		elseif thing.itemid >= ITEM_HEALTH_CASK_START and thing.itemid <= ITEM_HEALTH_CASK_END or thing.itemid >= ITEM_MANA_CASK_START and thing.itemid <= ITEM_MANA_CASK_END or thing.itemid >= ITEM_SPIRIT_CASK_START and thing.itemid <= ITEM_SPIRIT_CASK_END or thing.itemid >= ITEM_KEG_START and thing.itemid <= ITEM_KEG_END then
			description = description .. thing:getDescription(distance)
			local charges = thing:getCharges()
			if charges then
				description = string.format("%s\nIt has %d refillings left.", description, charges)
			end
		else
			description = description .. thing:getDescription(distance)
		end
	else
		description = description .. thing:getDescription(distance)
		if thing:isMonster() then
			local master = thing:getMaster()
			if master and table.contains({ "sorcerer familiar", "knight familiar", "druid familiar", "paladin familiar" }, thing:getName():lower()) then
				description = string.format("%s (Master: %s). \z It will disappear in %s", description, master:getName(), getTimeInWords(master:getStorageValue(Global.Storage.FamiliarSummon) - os.time()))
			end
		end
	end

	if player:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nClient ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:isPlayer() and thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		description = string.format("%s\nPosition: (%d, %d, %d)", description, position.x, position.y, position.z)

		if thing:isCreature() then
			local speedBase = thing:getBaseSpeed()
			local speed = thing:getSpeed()
			description = string.format("%s\nSpeedBase: %d", description, speedBase)
			description = string.format("%s\nSpeed: %d", description, speed)

			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	player:sendTextMessage(MESSAGE_LOOK, description)
end

callback:register()
