local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOCKHIT)

local area = createCombatArea(AREA_CIRCLE1X1)
combat:setArea(area)

local maxsummons = 4

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
creature:say("Watch my maws!", TALKTYPE_ORANGE_1)
	local summoncount = creature:getSummons()
	if #summoncount < 4 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Guzzlemaw", creature:getPosition())
    		if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, var)
end

spell:name("mawhawk summon")
spell:words("###360")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()