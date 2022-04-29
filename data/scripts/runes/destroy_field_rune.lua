local rune = Spell("rune")

function rune.onCastSpell(creature, variant, isHotkey)
	local position = Variant.getPosition(variant)
	local tile = Tile(position)
	local field = tile and tile:getItemByType(ITEM_TYPE_MAGICFIELD)
	if field and isInArray(FIELDS, field:getId()) then
		field:remove()
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end

rune:group("support")
rune:id(30)
rune:name("destroy field rune")
rune:runeId(3148)
rune:allowFarUse(true)
rune:charges(3)
rune:level(17)
rune:magicLevel(3)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:isAggressive(false)
rune:range(5)
rune:register()