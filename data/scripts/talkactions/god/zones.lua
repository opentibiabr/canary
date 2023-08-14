local testZone = Zone('test-zone')

testZone:addArea(Position(32366, 32213, 7), Position(32372, 32218, 7))
testZone:register()

local onEnter = EventCallback()

function onEnter.zoneOnCreatureEnter(zone, creature)
	if testZone ~= zone then
		return true
	end
	Spdlog.info("Creature " .. creature:getName() .. " entered zone " .. zone:getName())
	return false
end

onEnter:register()

local onLeave = EventCallback()

function onLeave.zoneOnCreatureLeave(zone, creature)
	if testZone ~= zone then
		return true
	end

	Spdlog.info("Creature " .. creature:getName() .. " left zone " .. zone:getName())
	return true
end

onLeave:register()

local zones = TalkAction("/zones")

function zones.onSay(player, words, param)
	testZone:clearMonsters()
	return false
end

zones:separator(" ")
zones:groupType("gamemaster")
zones:register()
