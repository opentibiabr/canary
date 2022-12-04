local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_LOSEENERGY)

local maxsummons = 2

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 2 then
		mid = Game.createMonster("Massive Water Elemental", creature:getPosition())
    	if not mid then
			return
		end
		mid:setMaster(creature)
	end
return combat:execute(creature, var)
end

spell:name("thul summon")
spell:words("###222")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()