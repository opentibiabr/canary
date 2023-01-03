function Player:onBrowseField(position)
	local ec = EventCallback.onBrowseField
	if ec then
		return ec(self, position)
	end
	return true
end

function Player:onLook(thing, position, distance)
	local ec = EventCallback.onLook
	if ec then
		local description = ec(self, thing, position, distance, "")
		if description ~= "" then
			self:sendTextMessage(MESSAGE_LOOK, description)
		end
	end
end

function Player:onLookInBattleList(creature, distance)
	local ec = EventCallback.onLookInBattleList
	if ec then
		local description = ec(self, creature, distance, "")
		if description ~= "" then
			self:sendTextMessage(MESSAGE_LOOK, description)
		end
	end
end

function Player:onLookInTrade(partner, item, distance)
	local ec = EventCallback.onLookInTrade
	if ec then
		local description = ec(self, partner, item, distance, "")
		if description ~= "" then
			self:sendTextMessage(MESSAGE_LOOK, description)
		end
	end
end

function Player:onLookInShop(itemType, count)
	local ec = EventCallback.onLookInShop
	if ec then
		return ec(self, itemType, count)
	end
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local ec = EventCallback.onMoveItem
	if ec then
		return ec(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
	return true
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local ec = EventCallback.onItemMoved
	if ec then
		ec(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	local ec = EventCallback.onMoveCreature
	if ec then
		return ec(self, creature, fromPosition, toPosition)
	end
	return true
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	local ec = EventCallback.onReportRuleViolation
	if ec then
		ec(self, targetName, reportType, reportReason, comment, translation)
	end
end

function Player:onReportBug(message, position, category)
	local ec = EventCallback.onReportBug
	if ec then
		return ec(self, message, position, category)
	end
	return true
end

function Player:onTurn(direction)
	local ec = EventCallback.onTurn
	if ec then
		return ec(self, direction)
	end
	return true
end

function Player:onTradeRequest(target, item)
	local ec = EventCallback.onTradeRequest
	if ec then
		return ec(self, target, item)
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	local ec = EventCallback.onTradeAccept
	if ec then
		return ec(self, target, item, targetItem)
	end
	return true
end

function Player:onGainExperience(target, exp, rawExp)
	local ec = EventCallback.onGainExperience
	if ec then
		return ec(self, target, exp, rawExp)
	end
	return exp
end

function Player:onLoseExperience(exp)
	local ec = EventCallback.onLoseExperience
	if ec then
		return ec(self, exp)
	end
	return exp
end

function Player:onGainSkillTries(skill, tries)
	local ec = EventCallback.onGainSkillTries
	if ec then
		return ec(self, skill, tries)
	end
	return tries
end

function Player:onRemoveCount(item)
	local ec = EventCallback.onRemoveCount
	if ec then
		ec(self, item)
	end
end

function Player:onRequestQuestLog()
	local ec = EventCallback.onRequestQuestLog
	if ec then
		ec(self)
	end
end

function Player:onRequestQuestLine(questId)
	local ec = EventCallback.onRequestQuestLine
	if ec then
		ec(self, questId)
	end
end

function Player:onStorageUpdate(key, value, oldValue, currentFrameTime)
	local ec = EventCallback.onStorageUpdate
	if ec then
		ec(self, key, value, oldValue, currentFrameTime)
	end
end

function Player:onCombat(target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	local ec = EventCallback.onCombat
	if ec then
		return ec(self, target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function Player:onChangeZone(zone)
	local ec = EventCallback.onChangeZone
	if ec then
		ec(self, zone)
	end
end
