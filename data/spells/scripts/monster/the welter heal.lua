local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)

function onCastSpell(creature, var)
	local spectators, spectator = Game.getSpectators(creature:getPosition(), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName() == "Egg" then
			spectator:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
			spectator:remove()
			creature:say("<the welter devours his spawn and heals himself>", TALKTYPE_ORANGE_1)
			creature:addHealth(25000)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		elseif spectator:isMonster() and spectator:getName() == "Spawn Of The Welter" then
			spectator:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
			spectator:remove()
			creature:say("<the welter devours his spawn and heals himself>", TALKTYPE_ORANGE_1)
			creature:addHealth(25000)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end
	end
	return combat:execute(creature, var)
end
