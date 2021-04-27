local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)

local maxsummons = 1

function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 1 then
		mid = Game.createMonster("Fire Elemental", { x=creature:getPosition().x+math.random(-1, 1), y=creature:getPosition().y+math.random(-1, 1), z=creature:getPosition().z })
			if not mid then
				return
			end
		mid:setMaster(creature)
	end
	return combat:execute(creature, var)
end
