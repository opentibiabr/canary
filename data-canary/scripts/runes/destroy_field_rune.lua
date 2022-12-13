-- This array contains all destroyable field items
local fields = {105, 2118, 2119, 2120, 2121, 2122, 2123, 2124, 2125, 2126, 2132, 2133, 2134, 2135, 21465}

local rune = Spell("rune")

function rune.onCastSpell(creature, variant, isHotkey)
	local position = Variant.getPosition(variant)
	local tile = Tile(position)
	local field = tile and tile:getItemByType(ITEM_TYPE_MAGICFIELD)
	if field and table.contains(fields, field:getId()) then
		field:remove()
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end

rune:group("support")
rune:name("destroy field rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_DESTROY_FIELD_RUNE)
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