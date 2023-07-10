local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local spectators, spectator = Game.getSpectators(creature:getPosition(), false, false, 25, 25, 25, 25)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName() == "Greater Canopic Jar" then
			creature:addHealth(10000)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end
	end
	return combat:execute(creature, var)
end

spell:name("the ravager heal")
spell:words("###398")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()