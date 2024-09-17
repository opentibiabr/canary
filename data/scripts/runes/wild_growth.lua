function onCreateWildGrowth(creature, position)
	local tile = Tile(position)
	if tile and tile:getTopCreature() and not tile:getTopCreature():isPlayer() then
		return false
	end
	local wildGrowth
	if Game.getWorldType() == WORLD_TYPE_NO_PVP then
		wildGrowth = ITEM_WILDGROWTH_SAFE
	else
		wildGrowth = ITEM_WILDGROWTH
	end
	local item = Game.createItem(wildGrowth, 1, position)
	item:setDuration(30, 60)
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onCreateWildGrowth")

local rune = Spell("rune")
function rune.onCastSpell(creature, variant, isHotkey)
	return combat:execute(creature, variant)
end

rune:id(94)
rune:name("Wild Growth Rune")
rune:group("attack")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_WILD_GROWTH_RUNE)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:level(27)
rune:magicLevel(8)
rune:runeId(3156)
rune:charges(2)
rune:isBlocking(true, true)
rune:allowFarUse(true)
rune:vocation("druid;true", "elder druid;true")
rune:register()
