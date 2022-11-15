local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local maxsummons = 1

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 1 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Glooth Blob", creature:getPosition())
    			if not mid then
					return
				end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, var)
end

spell:name("glooth anemone summon")
spell:words("##372")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()