local monsters = {
	{cosmic = 'cosmic energy prism a', pos = Position(32801, 32827, 14)},
	{cosmic = 'cosmic energy prism b', pos = Position(32798, 32827, 14)},
	{cosmic = 'cosmic energy prism c', pos = Position(32803, 32826, 14)},
	{cosmic = 'cosmic energy prism d', pos = Position(32796, 32826, 14)}
}

local function revertLloyd(creature, cosmic)
	local monster = Creature(creature)
	if monster and monster:getHealth() >= 1 and monster:getPosition() == Position(32799, 32826, 14) then
		monster:say('The cosmic energies in the chamber refocus on Lloyd.', TALKTYPE_MONSTER_SAY)
		monster:teleportTo(Position(32799, 32828, 14))
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	for i = 1, #monsters do
		local cosmics = monsters[i]
		local cosmic = Tile(Position(cosmics.pos)):getTopCreature()
		if cosmic and cosmic:isMonster() and cosmic:getName():lower() == cosmics.cosmic and cosmic:getHealth() >= 1 then
			cosmic:setMaxHealth(100000)
			cosmic:addHealth(100000)
			return true
		end
	end
end

local lloydPrepareDeath = CreatureEvent("LloydPrepareDeath")
function lloydPrepareDeath.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	if not creature:getName():lower() == "lloyd" and creature:isMonster() then
		return true
	end

	for i = 1, #monsters do
		local cosmics = monsters[i]
		local cosmic = Tile(Position(cosmics.pos)):getTopCreature()
		if cosmic and cosmic:isMonster() and cosmic:getName():lower() == cosmics.cosmic then
			creature:teleportTo(Position(32799, 32826, 14))
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			creature:addHealth(300000, true)
			cosmic:setMaxHealth(1000)
			creature:say('The cosmic energies in the chamber refocus on Lloyd.', TALKTYPE_MONSTER_SAY)
			addEvent(revertLloyd, 10 * 1000, creature:getId(), cosmic:getId())
			return true
		end
	end
	return true
end
lloydPrepareDeath:register()
