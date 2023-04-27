local combat = Combat()
combat:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.2)
combat:setParameter(COMBAT_PARAM_EFFECT, 52)

combat:setArea(createCombatArea({
{1, 1, 1},
{1, 3, 1},
{1, 1, 1}
}))

local monsters = {
	"",
}

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= cid then
			targetName = target:getName():lower()
			casterName = cid:getName():lower()
			if table.contains(monsters, targetName) and casterName ~= targetName then
				target:addHealth(math.random(0, 1500))
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("cakeheal")
spell:words("###1000")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()