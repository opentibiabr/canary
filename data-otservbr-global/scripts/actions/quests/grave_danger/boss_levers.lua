local levers = {
	--Cormaya
	{
		leverPos = {x = 33515, y = 31444, z = 13},
		teleportTo = Position({x = 33489, y = 31441, z = 13}),
		bossName = "Earl Osam",
		bossPos = Position({x = 33488, y = 31435, z = 13}),
		bossStorage = Storage.BosstiaryCooldown.EarlOsam
	},
	--Edron
	{
		leverPos = {x = 33454, y = 31413, z = 13},
		teleportTo = Position({x = 33457, y = 31442, z = 13}),
		bossName = "Count Vlarkorth",
		bossPos = Position({x = 33457, y = 31433, z = 13}),
		bossStorage = Storage.BosstiaryCooldown.CountVlarkorth
	},
	--Ghostland
	{
		leverPos = {x = 33421, y = 31493, z = 13},
		teleportTo = Position({x = 33425, y = 31480, z = 13}),
		bossName = "Lord Azaram",
		bossPos = Position({x = 33425, y = 31466, z = 13}),
		bossStorage = Storage.BosstiaryCooldown.LordAzaram
	},
	--Darashia
	{
		leverPos = {x = 33423, y = 31413, z = 13},
		teleportTo = Position({x = 33425, y = 31431, z = 13}),
		bossNames = {"Sir Baeloc", "Sir Nictros"},
		bossPos = {
			Position({x = 33422, y = 31428, z = 13}),
			Position({x = 33427, y = 31428, z = 13})
		},
		bossStorage = Storage.BosstiaryCooldown.SirBaelocNictros
	},
	--Thais
	{
		leverPos = {x = 33454, y = 31493, z = 13},
		teleportTo = Position({x = 33456, y = 31477, z = 13}),
		bossName = "Duke Krule",
		bossPos = Position({x = 33456, y = 31468, z = 13}),
		bossStorage = Storage.BosstiaryCooldown.DukeKrule
	}
}

local function StartBattle(bossPos)
	local boss = Tile(bossPos):getTopCreature()
	if boss and boss:isMonster() then
		boss:teleportTo(Position({x = 33427, y = 31436, z = 13}))
	end
end

local lever = Action()
function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for b = 1, #levers do
		if item:getPosition() == Position(levers[b].leverPos) then
			for c = levers[b].leverPos.x + 1, levers[b].leverPos.x + 5 do
				local adventurers = Tile(Position(c, levers[b].leverPos.y, levers[b].leverPos.z)):getTopCreature()
				if adventurers and adventurers:isPlayer() then
					if adventurers:getStorageValue(levers[b].bossStorage) >= os.time() then
						adventurers:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This boss can only be done again in 20 hours")
						return true
					end
					adventurers:teleportTo(levers[b].teleportTo)
					adventurers:setStorageValue(levers[b].bossStorage, os.time() + 20 * 3600)
				end
			end
			if levers[b].bossNames then
				Game.createMonster(levers[b].bossNames[1], levers[b].bossPos[1]):registerEvent("SirBaelocThink")
				Game.createMonster(levers[b].bossNames[2], levers[b].bossPos[2]):registerEvent("SirNictrosThink")
				addEvent(StartBattle, 15 * 1000, levers[b].bossPos[2])
			else
				Game.createMonster(levers[b].bossName, levers[b].bossPos)
			end
		end
	end
	return true
end

for a = 1, #levers do
	lever:position(levers[a].leverPos)
end
lever:register()
