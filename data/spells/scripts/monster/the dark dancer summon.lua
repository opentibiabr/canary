local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_PURPLE)

local maxsummons = 3

function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 3 then
		mid = Game.createMonster("Ghoul", creature:getPosition())
    		if not mid then
				return
			end
		mid:setMaster(creature)
	end
	return combat:execute(creature, var)
end
