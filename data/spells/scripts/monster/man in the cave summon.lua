local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GIFT_WRAPS)

local maxsummons = 2

function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 2 then
		mid = Game.createMonster("Monk", creature:getPosition())
    		if not mid then
				return
			end
		mid:setMaster(creature)
	end
	return combat:execute(creature, var)
end
