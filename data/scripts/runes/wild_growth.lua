local function getExpertPvpFieldOwner(creature)
	if not creature then
		return nil
	end

	if creature.getPvpMode then
		return creature
	end

	if not creature.getMaster then
		return nil
	end

	local master = creature:getMaster()
	if master and master.getPvpMode then
		return master
	end

	return nil
end

local function attachExpertPvpFieldContext(item, creature)
	if not item or not IsExpertPVP() then
		return
	end

	local owner = getExpertPvpFieldOwner(creature)
	if not owner then
		return
	end

	item:setCustomAttribute("expertPvpOwnerGuid", owner:getGuid())
	item:setCustomAttribute("expertPvpOwnerMode", owner:getPvpMode() or 0)
	item:setCustomAttribute("expertPvpCanonicalItemId", ITEM_WILDGROWTH)
	item:setCustomAttribute("expertPvpSafeVisualItemId", ITEM_WILDGROWTH_SAFE)
	item:setCustomAttribute("expertPvpBlockingVisualItemId", ITEM_WILDGROWTH)
	item:setCustomAttribute("expertPvpOwnerWasPlayerOrSummon", true)
end

function onCreateWildGrowth(creature, position)
	local tile = Tile(position)
	if not tile then
		return false
	end

	if tile:hasFlag(TILESTATE_FLOORCHANGE) then
		return false
	end

	if tile:getTopCreature() and not tile:getTopCreature():isPlayer() then
		return false
	end

	local wildGrowth
	if Game.getWorldType() == WORLD_TYPE_NO_PVP then
		wildGrowth = ITEM_WILDGROWTH_SAFE
	else
		wildGrowth = ITEM_WILDGROWTH
	end

	local item = Game.createItem(wildGrowth, 1, position)
	if item then
		attachExpertPvpFieldContext(item, creature)
		item:setDuration(30)
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("Casted by: %s", creature:getName()))
	end
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
