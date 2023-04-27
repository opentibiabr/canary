local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local maxsummons = 7

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 7 then
		for i = 1, maxsummons - #summoncount do
		local mid = Game.createMonster("Greed Worm", { x=creature:getPosition().x+math.random(-15, 15), y=creature:getPosition().y+math.random(-15, 15), z=creature:getPosition().z })
    		if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, var)
end

spell:name("summonsaweakspot")
spell:words("###1001")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()