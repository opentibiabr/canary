local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local msg = "Shargon absorbs necromantic energy to regenerate!"
	local spectators, spectator = Game.getSpectators(creature:getPosition(), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName() == "Necromantic Energy" then
			spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectator:remove()
			creature:say(msg, TALKTYPE_ORANGE_1)
			creature:addHealth(65000)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end
	end
	return combat:execute(creature, var)
end

spell:name("shargon heal")
spell:words("###379")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()