local positions = {
	[13400] = Position(33634, 31891, 6),
	[13401] = Position(33488, 31987, 7),
	[13402] = Position(33632, 31661, 12),
	[13403] = Position(33682, 31939, 9),
	[13404] = Position(33678, 32461, 7),
	[13405] = Position(32942, 31594, 8),
	[13406] = Position(33143, 31528, 2),
	[13407] = Position(33626, 31897, 6),
	[13408] = Position(33651, 31943, 7),
	[13409] = Position(33662, 31936, 9),
	[13410] = Position(33612, 31640, 14),
	[13411] = Position(33787, 31736, 12),
	[13412] = Position(33626, 31639, 15),
	[13413] = Position(33623, 31627, 14),
	[13415] = Position(33506, 31577, 8), -- krailos
	[13416] = Position(33503, 31580, 7), -- krailos
	[13417] = Position(33622, 31789, 13), -- oramond sea
	[13418] = Position(32234, 32919, 9), -- liberty bay quaras
	[13419] = Position(32235, 32921, 8), -- liberty bay quaras
	[13420] = Position(32247, 32893, 9), -- liberty bay quaras
	[13421] = Position(32244, 32892, 8), -- liberty bay quaras
	[13422] = Position(32262, 32913, 9), -- liberty bay quaras
	[13423] = Position(32264, 32911, 8), -- liberty bay quaras
	[13424] = Position(32271, 32872, 9), -- liberty bay quaras
	[13425] = Position(32272, 32872, 8), -- liberty bay quaras
	[13426] = Position(31376, 32776, 7), -- treiners
	[13427] = Position(31247, 32787, 7), -- treiners
	[13428] = Position(33545, 31861, 7),
	[13510] = Position(32520, 32022, 8), -- kazordoon
	[13511] = Position(32444, 32388, 10), -- kazordoon
	[13512] = Position(33159, 32636, 8), -- ankrahmun
	[13513] = Position(32130, 31359, 12), -- ankrahmun
	[13514] = Position(32103, 31329, 12), -- no respawn
	[13515] = Position(32114, 31327, 12), -- no respawn
	[13516] = Position(32111, 31372, 14), -- reward
	[13517] = Position(32102, 31400, 13), -- out reward
	[13518] = Position(32114, 31353, 13),  -- init
	[13519] = Position(32090, 31320, 13),
	[13520] = Position(32272, 31382, 14), -- first boss for the second lever
	[13521] = Position(32113, 31353, 13), -- exit boss
	[13522] = Position(32337, 31289, 14), -- second boss for the thrird lever
	[13523] = Position(32306, 31250, 14), -- third boss for the four lever
	[13524] = Position(32203, 31284, 14), -- four boss for the last boss lever
	[13525] = Position(32216, 31378, 14), -- world devourer exit for the reward
	[13526] = Position(32162, 31295, 7), -- svarground exit
	[13527] = Position(32112, 31390, 11), -- svarground entrance
	[13528] = Position(33185, 31643, 8), -- from the quest for edron
	[13529] = Position(32113, 31358, 13), -- from edron for the quest
	[13531] = Position(32113, 31358, 13), -- from farmine for the quest
}

local oramondMovements = MoveEvent()

function oramondMovements.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local newPosition = positions[item.actionid]
	if newPosition then
		player:teleportTo(newPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
	end
	return true
end

oramondMovements:type("stepin")

for index, value in pairs(positions) do
	oramondMovements:aid(index)
end

oramondMovements:register()
