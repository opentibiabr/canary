local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TELEPORT)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local maxsummons = 2

function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 2 then
		for i = 1, maxsummons - #summoncount do

			if creature:getOutfit().lookType == 11 then
				local mid = Game.createMonster("roaring water elemental", creature:getPosition())
					if not mid then
						return
					end
					mid:setMaster(creature)
			elseif creature:getOutfit().lookType == 285 then
				local mid = Game.createMonster("jagged earth elemental", creature:getPosition())
					if not mid then
						return
					end
					mid:setMaster(creature)
			elseif creature:getOutfit().lookType == 290 then
				local mid = Game.createMonster("overcharged energy elemental", creature:getPosition())
					if not mid then
						return
					end
					mid:setMaster(creature)
			elseif creature:getOutfit().lookType == 243 then
				local mid = Game.createMonster("blistering fire elemental", creature:getPosition())
					if not mid then
						return
				end
					mid:setMaster(creature)
			end
		end
	end
return combat:execute(creature, var)
end
