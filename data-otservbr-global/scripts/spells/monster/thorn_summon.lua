local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local creaturePos = creature:getPosition()
	local mid = Game.createMonster('thorn minion', Position(creaturePos.x + math.random(-3, 3), creaturePos.y + math.random(-3, 3), creaturePos.z), true, false)
    if not mid then
		return
	end
	return combat:execute(creature, var)
end

spell:name("thorn summon")
spell:words("###442")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()