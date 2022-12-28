local rune = Spell("rune")

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(200000)

function rune.onCastSpell(creature, variant, isHotkey)
	local position, item = variant:getPosition()
	if position.x == CONTAINER_POSITION then
		local container = creature:getContainerById(position.y - 64)
		if container then
			item = container:getItem(position.z)
		else
			item = creature:getSlotItem(position.y)
		end
	else
		item = Tile(position):getTopDownItem()
	end

	if not item or item.itemid == 0 or not isMoveable(item.uid) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	condition:setOutfit({lookTypeEx = item.itemid})
	creature:addCondition(condition)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

rune:group("support")
rune:name("chameleon rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_CHAMELEON_RUNE)
rune:runeId(3178)
rune:allowFarUse(true)
rune:charges(1)
rune:level(27)
rune:magicLevel(4)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:isAggressive(false)
rune:isSelfTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()