local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

function onCastSpell(creature, var)

	local creatures = {"Greed", "Frenzy", "Disruption"}
	local monster = creatures[math.random(#creatures)]

	if devourerSummon < 3 then
		Game.createMonster(monster, {x=creature:getPosition().x+math.random(-1, 1), y=creature:getPosition().y+math.random(-1, 1), z=creature:getPosition().z}, false, true)
		devourerSummon = devourerSummon + 1
	end

	return combat:execute(creature, var)
end
