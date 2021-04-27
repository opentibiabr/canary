local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

function onCastSpell(creature, var)
	local creaturePos = creature:getPosition()
	local mid = Game.createMonster('thorn minion', Position(creaturePos.x + math.random(-3, 3), creaturePos.y + math.random(-3, 3), creaturePos.z), true, false)
    if not mid then
		return
	end
	return combat:execute(creature, var)
end
