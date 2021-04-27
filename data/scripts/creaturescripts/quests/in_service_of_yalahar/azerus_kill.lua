
local function removeTeleport(position)
	local teleportItem = Tile(position):getItemById(1387)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

local azerus = CreatureEvent("Azerus")
function azerus.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getName():lower() ~= 'azerus' then
		return true
	end

	local position = targetMonster:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1387, 1, position)
	local teleportToPosition = Position(32780, 31168, 14)
	if item:isTeleport() then
		item:setDestination(teleportToPosition)
	end
	targetMonster:say("Azerus ran into teleporter! It will disappear in 2 minutes. Enter it!",
	TALKTYPE_MONSTER_SAY, 0, 0, position)
	--remove portal after 2 min
	addEvent(removeTeleport, 2 * 60 * 1000, position)

	--clean arena of monsters
	local spectators, spectator = Game.getSpectators(Position(32783, 31166, 10), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectator:remove()
		end
	end
	return true
end

azerus:register()
