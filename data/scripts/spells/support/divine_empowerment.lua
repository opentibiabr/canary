local function removeEmpowermentItem(position)
	for x = -1, 1 do
		for y = -1, 1 do
			local tile = Tile(Position(position.x + x, position.y + y, position.z))
			if tile then
				local item = tile:getItemById(ITEM_DIVINE_EMPOWERMENT)
				if item then
					item:remove()
				end
			end
		end
	end
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not creature or not creature:isPlayer() then
		return false
	end

	local grade = creature:revelationStageWOD("Divine Empowerment")
	if grade == 0 then
		creature:sendCancelMessage("You cannot cast this spell")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local cooldown = 0
	if grade >= 3 then
		cooldown = 24
	elseif grade >= 2 then
		cooldown = 28
	elseif grade >= 1 then
		cooldown = 32
	end
	local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 268)
	condition:setTicks((cooldown * 1000) / configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
	creature:addCondition(condition)

	local position = creature:getPosition()
	for x = -1, 1 do
		for y = -1, 1 do
			local item = Game.createItem(ITEM_DIVINE_EMPOWERMENT, 1, Position(position.x + x, position.y + y, position.z))
			if item then
				item:setAttribute(ITEM_ATTRIBUTE_OWNER, creature:getId())
			end
		end
	end

	addEvent(removeEmpowermentItem, 5000, position)
	creature:onThinkWheelOfDestiny(true)
	return true
end

spell:group("support")
spell:id(268)
spell:name("Divine Empowerment")
spell:words("utevo grav san")
spell:level(300)
spell:mana(500)
spell:isPremium(true)
spell:range(7)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
