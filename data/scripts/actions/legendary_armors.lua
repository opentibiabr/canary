local ArmorLegendary = Action()

function ArmorLegendary.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()

	local currentDescription = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	local tierCheck = tonumber(currentDescription:match("%((%d+)%)"))

	if tierCheck == nil or (tierCheck >= 0 and tierCheck <= 9) then
		if itemId == 673 and player:getItemById(16242, 1) and player:getMoney() + player:getBankBalance() >= 100000 then
			local targetItemId = target:getId()

			local allowedItemIds = { 39147, 34094, 34096, 34095, 28719, 27648, 22537, 36663, 3397, 8862, 39165, 39164, 34157, 13993, 8038, 8039 }

			if table.contains(allowedItemIds, targetItemId) then
				player:removeItem(16242, 1)
				player:removeItem(673, 1)
				player:removeMoneyBank(100000)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The item received the power of the jewel of soul. The hammer broke in the process.")
				player:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)

				if not currentDescription or not currentDescription:lower():find("legendary") then
					target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Legendary Tier (1).")
				else
					local currentCount = tonumber(currentDescription:match("%((%d+)%).")) or 0
					local newCount = currentCount + 1
					local newDescription = "Legendary Tier (" .. newCount .. ")."
					target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, newDescription)
				end
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Be careful, this item does not support a jewel, or you are using the incorrect hammer.")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need the jewel of soul, hammer of soul, and 100,000 to upgrade.")
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your item already has the maximum power.")
	end

	return true
end

ArmorLegendary:id(673)
ArmorLegendary:register()

local condition = Condition(CONDITION_ATTRIBUTES, CONDITIONID_ARMOR)
local ArmorEquipOn = MoveEvent()

function ArmorEquipOn.onEquip(player, item, position, fromPosition)
	if not player or player:isInGhostMode() then
		return true
	end

	local currentDescription = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	if currentDescription and currentDescription:lower():find("legendary tier") then
		local tier = tonumber(currentDescription:match("%((%d+)%)"))

		condition:setParameter(CONDITION_PARAM_SUBID, 997)
		condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, 100 + 3 * tier)
		condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 0.4 * tier)
		condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1 * tier)
		condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 100 + 0.8 * tier)
		condition:setParameter(CONDITION_PARAM_TICKS, -1)

		player:addCondition(condition)
	end

	return true
end

ArmorEquipOn:id(39147, 34094, 34096, 34095, 28719, 27648, 22537, 36663, 3397, 8862, 39165, 39164, 34157, 13993, 8038, 8039)
ArmorEquipOn:register()

local condition = Condition(CONDITION_ATTRIBUTES, CONDITIONID_ARMOR)
local ArmorEquipOff = MoveEvent()

function ArmorEquipOff.onDeEquip(player, item, position, fromPosition)
	if not player or player:isInGhostMode() then
		return true
	end

	local currentDescription = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	if currentDescription and currentDescription:lower():find("legendary tier") then
		for i = 997, 997 do
			player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_ARMOR, i)
		end
	end

	return true
end

ArmorEquipOff:id(39147, 34094, 34096, 34095, 28719, 27648, 22537, 36663, 3397, 8862, 39165, 39164, 34157, 13993, 8038, 8039)
ArmorEquipOff:register()
