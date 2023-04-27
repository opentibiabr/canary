local function tpBack(players)
	local tpSomeone = false
	local boss = Creature("The Fear Feaster")
	if not boss then
		return false
	end
	for _, pid in pairs(players) do
		if Player(pid) and Player(pid):getPosition():isInRange({x = 33700, y = 31459, z = 14}, {x = 33719, y = 31480, z = 14}) then
			Player(pid):teleportTo({x = 33777, y = 31470, z = 14})
			tpSomeone = true
		end
	end
	if tpSomeone then
		local symbol = Game.createMonster("Symbol of Fear", Position({x = 33780, y = 31471, z = 14}), false, true)
		symbol:say("Face your fear!")
	end
	return true
end
	
local symbolOfFearDeath = CreatureEvent("symbolOfFearDeath")
function symbolOfFearDeath.onDeath(creature)
	local players = Game.getSpectators(creature:getPosition(), false, true, 3, 3, 3, 3)
	local toTpPlayers = {}
	for _, player in pairs(players) do
		table.insert(toTpPlayers, player:getId())
		player:teleportTo({x = 33712, y = 31470, z = 14})
	end
	local pos = ({Position({x = 33708, y = 31468, z = 14}),	Position({x = 33711, y = 31468, z = 14}), Position({x = 33714, y = 31468, z = 14})})[math.random(1,3)]
	Game.createMonster("Phobia", pos, false, true)
	
	addEvent(tpBack, 30000, toTpPlayers)
	return true
end
symbolOfFearDeath:register()
