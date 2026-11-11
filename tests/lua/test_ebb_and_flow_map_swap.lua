-- Run from the repository root: lua tests/lua/test_ebb_and_flow_map_swap.lua
-- Optional second argument: another copy of the swap script, to compare an older version against this check.
--
-- Every swap of the Ebb and Flow map (one every 2 minutes) used to register one more mapOnLoad callback, and each
-- callback walked the zone and resent the whole login state of every player inside it, so a single map load cost more
-- with every swap of the server's uptime. This loads the real Soul War library and the real swap script into a model of
-- the engine pieces involved:
--   * Game.loadMap only queues the load; the map changes later and then every mapOnLoad callback runs (Map::loadMap);
--   * an EventCallback has no unregister (event_callback_functions.cpp only binds type and register), and the
--     duplicate check (EventsCallbacks::isCallbackRegistered) is skipped when the callback asks for it;
--   * Player:sendCreatureAppear resends the whole login state, not only the map (ProtocolGame::sendAddCreature).
local root = arg and arg[1] or "."
local scriptPath = arg and arg[2] or (root .. "/data-otservbr-global/scripts/quests/soul_war/globalevent-ebb_and_flow_change_maps.lua")

local passed, failed = 0, 0
local function test(name, callback)
	local ok, err = pcall(callback)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		print("FAIL: " .. name .. "\n" .. tostring(err))
	end
end

local function newKV()
	local values, children = {}, {}
	return {
		get = function(_, key)
			return values[key]
		end,
		set = function(_, key, value)
			values[key] = value
		end,
		remove = function(_, key)
			values[key] = nil
		end,
		scoped = function(_, key)
			children[key] = children[key] or newKV()
			return children[key]
		end,
	}
end

local function loadInto(env, path)
	local chunk, err
	if setfenv then
		chunk, err = loadfile(path)
		if chunk then
			setfenv(chunk, env)
		end
	else
		chunk, err = loadfile(path, "t", env)
	end
	assert(chunk, err)
	chunk()
end

-- Raft ground (SoulWarQuest.ebbAndFlow.boatId) and an ordinary hunting ground.
local RAFT, MUD = 7272, 10605

local function newWorld()
	local world = {
		callbacks = {}, -- registered mapOnLoad callbacks, in registration order
		queue = {}, -- paths queued by Game.loadMap, waiting for the dispatcher
		loaded = {}, -- paths whose load already ran
		members = {}, -- creatures inside the Ebb and Flow zone
		ground = {}, -- "x,y,z" -> ground item id
		globalEvents = {},
		stopped = {},
		scheduled = 0,
		addAreaCalls = 0,
	}

	local env = setmetatable({}, { __index = _G })
	env.Player, env.Monster, env.MonsterType, env.Creature = {}, {}, {}, {}
	env.CONST_ME_TELEPORT = 11
	env.logger = {
		debug = function() end,
		trace = function() end,
		info = function() end,
		warn = function() end,
		error = function() end,
	}
	env.table = setmetatable({
		contains = function(values, expected)
			for _, value in ipairs(values) do
				if value == expected then
					return true
				end
			end
			return false
		end,
	}, { __index = table })
	env.KV = {
		scoped = function()
			return newKV()
		end,
	}
	env.Condition = function()
		return {}
	end
	for index, element in ipairs({ "PHYSICAL", "FIRE", "EARTH", "ENERGY", "ICE", "HOLY", "DEATH" }) do
		env["COMBAT_" .. element .. "DAMAGE"] = index
	end

	local function newPosition(x, y, z)
		local position = { x = x, y = y, z = z }
		function position:sendMagicEffect()
			world.effects = (world.effects or 0) + 1
		end
		return position
	end
	env.Position = setmetatable({}, {
		__call = function(_, x, y, z)
			return newPosition(x, y, z)
		end,
	})

	-- The box SoulWarQuest.ebbAndFlow.zone covers.
	local function inEbbBox(position)
		return position.x >= 33869 and position.x <= 33964 and position.y >= 30991 and position.y <= 31147 and position.z >= 8 and position.z <= 9
	end
	local zones = {}
	env.Zone = setmetatable({
		getByName = function(name)
			return zones[name]
		end,
	}, {
		__call = function(_, name)
			if zones[name] then
				return zones[name]
			end
			local zone = {}
			function zone:addArea()
				if name == "ebb-and-flow-zone" then
					world.addAreaCalls = world.addAreaCalls + 1
				end
			end
			function zone:subtractArea() end
			function zone:setRemoveDestination() end
			function zone:isInZone(position)
				return inEbbBox(position)
			end
			function zone:countPlayers()
				local count = 0
				for _, creature in ipairs(world.members) do
					count = count + (creature.kind == "player" and 1 or 0)
				end
				return count
			end
			function zone:countMonsters()
				local count = 0
				for _, creature in ipairs(world.members) do
					count = count + (creature.kind == "monster" and 1 or 0)
				end
				return count
			end
			function zone:getCreatures()
				local list = {}
				for _, creature in ipairs(world.members) do
					list[#list + 1] = creature
				end
				return list
			end
			function zone:getPlayers()
				local list = {}
				for _, creature in ipairs(world.members) do
					if creature.kind == "player" then
						list[#list + 1] = creature
					end
				end
				return list
			end
			zones[name] = zone
			return zone
		end,
	})

	env.Tile = function(position)
		local key = position.x .. "," .. position.y .. "," .. position.z
		local ground = world.ground[key]
		return {
			getGround = function()
				return ground and {
					getId = function()
						return ground
					end,
				} or nil
			end,
			getItemById = function()
				return nil
			end,
		}
	end

	env.Game = setmetatable({
		-- Game.loadMap only queues the load on the dispatcher (GameFunctions::luaGameLoadMap).
		loadMap = function(path)
			world.queue[#world.queue + 1] = path
		end,
	}, {
		__index = function(_, key)
			error("this fixture does not model Game." .. tostring(key))
		end,
	})

	-- EventsCallbacks::addCallback: the same name is only added twice when the callback skips the duplicate check.
	-- The class binds type and register only: there is no unregister.
	env.EventCallback = function(name, skipDuplicationCheck)
		local callback = {}
		function callback:register()
			for _, entry in ipairs(world.callbacks) do
				if entry.name == name and not skipDuplicationCheck then
					return false
				end
			end
			world.callbacks[#world.callbacks + 1] = { name = name, run = self.mapOnLoad }
			return true
		end
		return callback
	end

	env.GlobalEvent = function(name)
		local event = { name = name }
		function event:register()
			world.globalEvents[name] = self
			return true
		end
		function event:interval() end
		return event
	end

	env.addEvent = function()
		world.scheduled = world.scheduled + 1
		return world.scheduled
	end
	env.stopEvent = function(id)
		world.stopped[#world.stopped + 1] = id
	end

	-- Map::loadMap: the path is replaced, then every registered mapOnLoad callback runs.
	function world.runDispatcher()
		while #world.queue > 0 do
			local path = table.remove(world.queue, 1)
			world.loaded[#world.loaded + 1] = path
			local snapshot = {}
			for _, entry in ipairs(world.callbacks) do
				snapshot[#snapshot + 1] = entry
			end
			for _, entry in ipairs(snapshot) do
				entry.run(path)
			end
		end
	end

	-- ProtocolGame::sendAddCreature for the player himself: the whole login state, not only the map.
	function world.newCreature(spec)
		local creature = { name = spec.name, kind = spec.kind, pos = spec.pos, master = spec.master, appear = 0, teleports = {} }
		function creature:getName()
			return self.name
		end
		function creature:getPosition()
			return newPosition(self.pos.x, self.pos.y, self.pos.z)
		end
		function creature:isPlayer()
			return self.kind == "player"
		end
		function creature:isMonster()
			return self.kind == "monster"
		end
		function creature:getMaster()
			return self.master
		end
		function creature:getPlayer()
			if self.kind == "player" then
				return self
			end
			return nil
		end
		function creature:teleportTo(position)
			self.teleports[#self.teleports + 1] = position
			self.pos = { x = position.x, y = position.y, z = position.z }
			return true
		end
		function creature:sendCreatureAppear()
			self.appear = self.appear + 1
			return true
		end
		-- Creature:isInBoatSpot is defined by the real library on env.Creature.
		return setmetatable(creature, { __index = env.Creature })
	end

	function world.join(spec)
		local creature = world.newCreature(spec)
		world.members[#world.members + 1] = creature
		return creature
	end

	function world.put(position, groundId)
		world.ground[position.x .. "," .. position.y .. "," .. position.z] = groundId
	end

	loadInto(env, root .. "/data-otservbr-global/lib/quests/soul_war.lua")
	loadInto(env, scriptPath)
	world.env = env
	world.ebb = env.SoulWarQuest.ebbAndFlow

	function world.startup()
		world.globalEvents["SoulWarQuest.ebbAndFlow"].onStartup()
		world.runDispatcher()
	end
	-- The 2-minute global event: it moves the creatures and queues the map; the dispatcher loads it afterwards.
	function world.think()
		world.globalEvents["eddAndFlowInundate"].onThink(120000, 0)
	end
	function world.swap()
		world.think()
		world.runDispatcher()
	end
	return world
end

test("the script registers a single mapOnLoad callback and later swaps do not add more", function()
	local world = newWorld()
	world.startup()
	assert(#world.callbacks == 1, "expected one callback after the start, got " .. #world.callbacks)
	for swap = 1, 40 do
		world.swap()
		assert(#world.callbacks == 1, "swap " .. swap .. " left " .. #world.callbacks .. " mapOnLoad callbacks registered")
	end
end)

test("a map load refreshes the zone and tells each player in it once", function()
	local world = newWorld()
	world.startup()
	local player = world.join({ name = "Hunter", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	for _ = 1, 30 do
		world.swap()
	end

	local areaBefore, appearBefore = world.addAreaCalls, player.appear
	world.swap()
	assert(world.addAreaCalls - areaBefore == 1, "the last swap refreshed the zone " .. (world.addAreaCalls - areaBefore) .. " times")
	assert(player.appear - appearBefore == 1, "the last swap resent the player state " .. (player.appear - appearBefore) .. " times")
	print(string.format("info: swap 31 refreshed the zone %d time(s) and resent the login state %d time(s)", world.addAreaCalls - areaBefore, player.appear - appearBefore))
end)

test("a day of swaps does not make a load more expensive", function()
	local world = newWorld()
	world.startup()
	local player = world.join({ name = "Hunter", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	local first
	for swap = 1, 720 do
		local before = player.appear
		world.swap()
		first = first or (player.appear - before)
		assert(player.appear - before == first, "swap " .. swap .. " resent the state " .. (player.appear - before) .. " times, the first one " .. first)
	end
end)

test("nothing is sent to the client before the map has been replaced", function()
	local world = newWorld()
	world.startup()
	local standing = world.join({ name = "Standing", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	local diver = world.join({ name = "Diver", kind = "player", pos = { x = 33930, y = 31020, z = 9 } })
	world.put(diver.pos, RAFT)
	for swap = 1, 3 do -- flood (the player on the raft goes up), ebb, flood again
		local standingBefore, diverBefore = standing.appear, diver.appear
		world.think() -- the event ran, the dispatcher has not replaced the map yet
		assert(standing.appear == standingBefore and diver.appear == diverBefore, "swap " .. swap .. ": the state was resent before the new map was loaded")
		world.runDispatcher()
		assert(standing.appear == standingBefore + 1 and diver.appear == diverBefore + 1, "swap " .. swap .. ": the new map was not sent once after the load")
	end
end)

test("flood: the raft goes to the nearest room, the rest to the entrance, a summon follows its master, strangers stay", function()
	local world = newWorld()
	world.startup()
	local onRaft = world.join({ name = "OnRaft", kind = "player", pos = { x = 33930, y = 31020, z = 9 } })
	local offRaft = world.join({ name = "OffRaft", kind = "player", pos = { x = 33910, y = 31030, z = 9 } })
	local summon = world.join({ name = "Summon", kind = "monster", pos = { x = 33931, y = 31020, z = 9 }, master = onRaft })
	local stranger = world.join({ name = "Stranger", kind = "monster", pos = { x = 33931, y = 31021, z = 9 } })
	local upstairs = world.join({ name = "Upstairs", kind = "player", pos = { x = 33903, y = 31049, z = 8 } })
	world.put(onRaft.pos, RAFT)
	world.put(summon.pos, RAFT)
	world.put(stranger.pos, RAFT)
	world.put(offRaft.pos, MUD)

	world.swap()

	local room = { x = 33939, y = 31021, z = 8 }
	local function at(creature, expected)
		return creature.pos.x == expected.x and creature.pos.y == expected.y and creature.pos.z == expected.z
	end
	assert(at(onRaft, room), "the player on the raft did not reach the nearest room")
	assert(at(summon, room), "the summon did not follow its master")
	assert(at(offRaft, { x = 33893, y = 31020, z = 8 }), "the player off the raft did not reach the entrance")
	assert(#stranger.teleports == 0, "a monster nobody owns was moved")
	assert(#upstairs.teleports == 0, "a player already on the upper floor was moved")
	assert(world.ebb.isActive() == true and world.ebb.isLoadedEmptyMap() == false, "the flood flags were not set")
	assert(world.loaded[#world.loaded] == world.ebb.mapsPath.inundate, "the inundate map was not the one loaded")
end)

test("ebb: a player on a raft on the upper floor goes down to the same tile, the others stay", function()
	local world = newWorld()
	world.startup()
	world.swap() -- flood
	local onRaft = world.join({ name = "OnRaft", kind = "player", pos = { x = 33930, y = 31020, z = 8 } })
	local inRoom = world.join({ name = "InRoom", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	world.put(onRaft.pos, RAFT)
	world.put(inRoom.pos, 9720)

	world.swap() -- ebb

	assert(onRaft.pos.x == 33930 and onRaft.pos.y == 31020 and onRaft.pos.z == 9, "the player on the raft did not go down")
	assert(#inRoom.teleports == 0, "a player in a room was moved")
	assert(world.ebb.isActive() == false and world.ebb.isLoadedEmptyMap() == true, "the ebb flags were not set")
	assert(world.loaded[#world.loaded] == world.ebb.mapsPath.empty, "the empty map was not the one loaded")
end)

test("only the two overlay maps refresh the zone", function()
	local world = newWorld()
	world.startup()
	world.join({ name = "Hunter", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	local before = world.addAreaCalls
	world.queue[#world.queue + 1] = "data-otservbr-global/world/quest/soul_war/other_chunk.otbm"
	world.runDispatcher()
	assert(world.addAreaCalls == before, "an unrelated map load refreshed the Ebb and Flow zone")
	world.queue[#world.queue + 1] = world.ebb.mapsPath.ebbFlow
	world.runDispatcher()
	assert(world.addAreaCalls == before, "the base map load refreshed the Ebb and Flow zone")
end)

test("running the script again without a reload of the callbacks keeps one callback", function()
	local world = newWorld()
	world.startup()
	loadInto(world.env, scriptPath)
	assert(#world.callbacks == 1, "a second run of the script left " .. #world.callbacks .. " callbacks")
	world.swap()
	world.swap()
	assert(#world.callbacks == 1, "swaps after a second run left " .. #world.callbacks .. " callbacks")
end)

test("after a scripts reload (callbacks cleared) the swap still refreshes the player", function()
	local world = newWorld()
	world.startup()
	world.callbacks = {} -- Scripts reload: g_callbacks().clear()
	loadInto(world.env, scriptPath)
	local player = world.join({ name = "Hunter", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	world.swap()
	assert(player.appear == 1, "the player was not refreshed once after the reload, got " .. player.appear)
	assert(#world.callbacks == 1, "expected one callback after the reload, got " .. #world.callbacks)
end)

test("the save hook clears the pool timers and keeps the map callback", function()
	local world = newWorld()
	world.startup()
	assert(world.scheduled == 1, "the ebb should schedule the pool timer once")
	world.globalEvents["EbbFlowCleanupOnSave"].onSave()
	assert(#world.stopped == 1, "the pending pool timer was not stopped")
	assert(#world.callbacks == 1, "the save hook changed the callbacks")
	local player = world.join({ name = "Hunter", kind = "player", pos = { x = 33939, y = 31021, z = 8 } })
	world.swap()
	assert(player.appear == 1, "the swap after a save did not refresh the player")
end)

print(string.format("%d passed, %d failed", passed, failed))
if failed > 0 then
	os.exit(1)
end
