local position = {
    [1] = {pos = {x=33170, y=31730, z=9}},
    [2] = {pos = {x=33175, y=31736, z=9}},
    [3] = {pos = {x=33174, y=31747, z=9}},
    [4] = {pos = {x=33164, y=31744, z=9}}
}

local shlorgTeleport = CreatureEvent("ShlorgTeleport")
function shlorgTeleport.onThink(creature)
	local chance = math.random(1, 100)
	if chance < 7 then
		if(not creature:isMonster()) then
			return true
		end
		local spawn = position[math.random(4)]
		creature:teleportTo(spawn.pos)
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
end
shlorgTeleport:register()
