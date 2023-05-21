function onCreateMagicWall(creature, tile)
	local magicWall
	if Game.getWorldType() == WORLD_TYPE_NO_PVP then
		magicWall = ITEM_MAGICWALL_SAFE
	else
		magicWall = ITEM_MAGICWALL
	end
	local item = Game.createItem(magicWall, 1, tile)
	item:setDuration(16, 24)
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onCreateMagicWall")

local spell = Spell("rune")
function spell.onCastSpell(creature, variant, isHotkey)
	return combat:execute(creature, variant)
end

spell:id(86)
spell:name("Magic Wall Rune")
spell:group("attack")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_MAGIC_WALL_RUNE)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(32)
spell:magicLevel(9)
spell:runeId(3180)
spell:charges(3)
spell:isBlocking(true, true)
spell:allowFarUse(true)
spell:register()
