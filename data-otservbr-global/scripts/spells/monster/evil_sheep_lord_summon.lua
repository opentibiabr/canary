local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HEARTS)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

local maxsummons = 3

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 3 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Evil Sheep", creature:getPosition())
    			if not mid then
					return
				end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, var)
end

spell:name("evil sheep lord summon")
spell:words("###271")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()