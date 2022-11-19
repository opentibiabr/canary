local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

local maxsummons = 4

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 4 then
		mid = Game.createMonster("Deathspawn", creature:getPosition())
			if not mid then
				return
			end
		mid:setMaster(creature)
	end
	return combat:execute(creature, var)
end

spell:name("hell hole summon")
spell:words("###300")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()