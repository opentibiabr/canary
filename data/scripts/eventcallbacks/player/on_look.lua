local callback = EventCallback()

local function isSpecialItem(itemId)
	return (itemId >= ITEM_HEALTH_CASK_START and itemId <= ITEM_HEALTH_CASK_END) or (itemId >= ITEM_MANA_CASK_START and itemId <= ITEM_MANA_CASK_END) or (itemId >= ITEM_SPIRIT_CASK_START and itemId <= ITEM_SPIRIT_CASK_END) or (itemId >= ITEM_KEG_START and itemId <= ITEM_KEG_END)
end

local function getPositionDescription(position)
	if position.x == 65535 then
		return "Position: In your inventory."
	else
		return string.format("Position: (%d, %d, %d)", position.x, position.y, position.z)
	end
end

local function handleItemDescription(inspectedThing, lookDistance)
	local descriptionText = inspectedThing:getDescription(lookDistance)

	if isSpecialItem(inspectedThing.itemid) then
		local itemCharges = inspectedThing:getCharges()
		if itemCharges > 0 then
			return string.format("You see %s\nIt has %d refillings left.", descriptionText, itemCharges)
		end
	else
		return "You see " .. descriptionText
	end

	return descriptionText
end

local function handleCreatureDescription(inspectedThing, lookDistance)
	local descriptionText = inspectedThing:getDescription(lookDistance)

	if inspectedThing:isMonster() then
		local monsterMaster = inspectedThing:getMaster()
		if monsterMaster and table.contains({ "sorcerer familiar", "knight familiar", "druid familiar", "paladin familiar" }, inspectedThing:getName():lower()) then
			local summonTimeRemaining = monsterMaster:kv():get("familiar-summon-time") or 0
			descriptionText = string.format("%s (Master: %s). It will disappear in %s", descriptionText, monsterMaster:getName(), getTimeInWords(summonTimeRemaining - os.time()))
		end
	end

	return "You see " .. descriptionText
end

local function appendAdminDetails(descriptionText, inspectedThing, inspectedPosition)
	if inspectedThing:isItem() then
		descriptionText = string.format("%s\nClient ID: %d", descriptionText, inspectedThing:getId())

		local itemActionId = inspectedThing:getActionId()
		if itemActionId ~= 0 then
			descriptionText = string.format("%s, Action ID: %d", descriptionText, itemActionId)
		end

		local itemUniqueId = inspectedThing:getUniqueId()
		if itemUniqueId > 0 and itemUniqueId < 65536 then
			descriptionText = string.format("%s, Unique ID: %d", descriptionText, itemUniqueId)
		end

		local itemType = inspectedThing:getType()
		local transformOnEquipId = itemType:getTransformEquipId()
		local transformOnDeEquipId = itemType:getTransformDeEquipId()

		if transformOnEquipId ~= 0 then
			descriptionText = string.format("%s\nTransforms to: %d (onEquip)", descriptionText, transformOnEquipId)
		elseif transformOnDeEquipId ~= 0 then
			descriptionText = string.format("%s\nTransforms to: %d (onDeEquip)", descriptionText, transformOnDeEquipId)
		end

		local itemDecayId = itemType:getDecayId()
		if itemDecayId ~= -1 then
			descriptionText = string.format("%s\nDecays to: %d", descriptionText, itemDecayId)
		end
	elseif inspectedThing:isCreature() then
		local healthDescription, creatureId = "%s\n%s\nHealth: %d / %d"
		if inspectedThing:isPlayer() and inspectedThing:getMaxMana() > 0 then
			creatureId = string.format("Player ID: %i", inspectedThing:getGuid())
			healthDescription = string.format("%s, Mana: %d / %d", healthDescription, inspectedThing:getMana(), inspectedThing:getMaxMana())
		elseif inspectedThing:isMonster() then
			creatureId = string.format("Monster ID: %i", inspectedThing:getId())
		elseif inspectedThing:isNpc() then
			creatureId = string.format("NPC ID: %i", inspectedThing:getId())
		end

		descriptionText = string.format(healthDescription, descriptionText, creatureId, inspectedThing:getHealth(), inspectedThing:getMaxHealth())
	end

	descriptionText = string.format("%s\n%s", descriptionText, getPositionDescription(inspectedPosition))

	if inspectedThing:isCreature() then
		local creatureBaseSpeed = inspectedThing:getBaseSpeed()
		local creatureCurrentSpeed = inspectedThing:getSpeed()
		descriptionText = string.format("%s\nSpeed Base: %d\nSpeed: %d", descriptionText, creatureBaseSpeed, creatureCurrentSpeed)

		if inspectedThing:isPlayer() then
			descriptionText = string.format("%s\nIP: %s", descriptionText, Game.convertIpToString(inspectedThing:getIp()))
		end
	end

	return descriptionText
end

function callback.playerOnLook(player, inspectedThing, inspectedPosition, lookDistance)
	local descriptionText

	if inspectedThing:isItem() then
		descriptionText = handleItemDescription(inspectedThing, lookDistance)
	elseif inspectedThing:isCreature() then
		descriptionText = handleCreatureDescription(inspectedThing, lookDistance)
	end

	if player:getGroup():getAccess() then
		descriptionText = appendAdminDetails(descriptionText, inspectedThing, inspectedPosition)
	end

	player:sendTextMessage(MESSAGE_LOOK, descriptionText)
end

callback:register()
