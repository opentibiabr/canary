local portals = {
	[50500] = {position = Position(33539, 32014, 6), message = 'Slrrp!'}, --entrance
	[50501] = {position = Position(33491, 31985, 7), message = 'Slrrp!'}, --exit
}

local oramondEntrance = MoveEvent()

function oramondEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local portal = portals[item.uid]
	if portal then
		player:teleportTo(portal.position)
		item:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		player:say(portal.message, TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

oramondEntrance:type("stepin")
oramondEntrance:uid(50500, 50501)
oramondEntrance:register()
