-- Run from the repository root: luajit tests/lua/test_dream_courts_teleport_access.lua
-- Real startup tables, loader and quest callback; doubles preserve the engine's
-- native-teleport-before-StepIn ordering and can reject Lua teleports.

local passed, failed = 0, 0
local errors, effects, world = {}, {}, {}
local movement
local now, day = 1000000, "Thursday"
local actionId = 23103

local function test(name, fn)
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		print("FAIL: " .. name .. ": " .. tostring(err))
	end
end

local positionMethods = {}
positionMethods.__index = positionMethods
function positionMethods:toString()
	return string.format("%d,%d,%d", self.x, self.y, self.z)
end
function positionMethods:sendMagicEffect(effect)
	table.insert(effects, { position = self, effect = effect })
end
function positionMethods.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end
function Position(x, y, z)
	if type(x) == "table" then
		return Position(x.x, x.y, x.z)
	end
	return setmetatable({ x = x, y = y, z = z }, positionMethods)
end

ITEM_ATTRIBUTE_ACTIONID = 1
ITEM_TYPE_TELEPORT = 2
CONST_ME_TELEPORT = 10
MESSAGE_EVENT_ADVANCE = 19
logger = {
	error = function(message)
		table.insert(errors, message)
	end,
}
function Tile(position)
	return world[Position(position):toString()]
end
function MoveEvent()
	local event = {}
	function event:aid(id)
		self.actionId = id
	end
	function event:register()
		movement = self
	end
	return event
end
os.time = function()
	return now
end
os.date = function(format)
	assert(format == "%A")
	return day
end

dofile("data-otservbr-global/lib/core/storages.lua")
dofile("data-otservbr-global/startup/tables/item.lua")
dofile("data-otservbr-global/startup/tables/teleport.lua")
dofile("data-otservbr-global/startup/others/functions.lua")
dofile("data-otservbr-global/scripts/quests/the_dream_courts_quest/movements_acessTeleports.lua")

local quest = Storage.Quest.U12_00.TheDreamCourts
local scar = Position(32208, 32033, 13)
local scarDestination = Position(32208, 32026, 13)
local nightmare = Position(32211, 32081, 15)
local nightmareDestination = Position(32211, 32075, 15)
local outside = Position(32208, 32034, 13)
local zero = Position(0, 0, 0)

local itemMethods = {}
itemMethods.__index = itemMethods
function itemMethods:getActionId()
	return self.actionId or 0
end
function itemMethods:setAttribute(attribute, value)
	assert(attribute == ITEM_ATTRIBUTE_ACTIONID)
	self.actionId = value
end
function itemMethods:removeAttribute(attribute)
	assert(attribute == ITEM_ATTRIBUTE_ACTIONID)
	self.actionId = nil
end
function itemMethods:setDestination(position)
	assert(self.teleport)
	self.destination = Position(position)
	return true
end
function itemMethods:getPosition()
	return self.position
end
local function makeItem(position, id, aid, destination)
	return setmetatable({ position = position, id = id, actionId = aid, destination = destination, teleport = destination ~= nil }, itemMethods)
end

local tileMethods = {}
tileMethods.__index = tileMethods
function tileMethods:getPosition()
	return self.position
end
function tileMethods:getGround()
	return self.ground
end
function tileMethods:getItems()
	return self.items
end
function tileMethods:getItemByType(itemType)
	assert(itemType == ITEM_TYPE_TELEPORT)
	for _, item in ipairs(self.items) do
		if item.teleport then
			return item
		end
	end
end
function tileMethods:getItemById(id)
	for _, item in ipairs(self.items) do
		if item.id == id then
			return item
		end
	end
end
function tileMethods:getItemCountById(id)
	return self:getItemById(id) and 1 or 0
end
function tileMethods:getTopDownItem()
	return self.items[1]
end
function tileMethods:getTopTopItem()
	return self.items[2]
end

local function makeTile(position, id, destination)
	local tile = setmetatable({ position = position, ground = makeItem(position, 8308, actionId), items = {} }, tileMethods)
	tile.items = { makeItem(position, id, actionId, destination) }
	world[position:toString()] = tile
	return tile
end

local function initialize()
	world, errors, effects = {}, {}, {}
	day = "Thursday"
	makeTile(scar, 1949, scarDestination)
	makeTile(nightmare, 1949, nightmareDestination)
	makeTile(Position(33619, 32526, 15), 1949, Position(33617, 32528, 15))
	makeTile(Position(32720, 32270, 8), 22761, zero)
	makeTile(Position(33618, 32546, 13), 22761, zero)
	loadLuaMapAction(ItemAction)
	loadLuaMapAction(TeleportAction)
end

local playerMethods = {}
playerMethods.__index = playerMethods
function playerMethods:getPlayer()
	if not self.nonPlayer then
		return self
	end
end
function playerMethods:getPosition()
	return self.position
end
function playerMethods:getStorageValue(key)
	assert(type(key) == "number", "quest references an undefined storage key")
	return self.storages[key] or -1
end
function playerMethods:sendTextMessage(messageType, message)
	assert(messageType == MESSAGE_EVENT_ADVANCE and type(message) == "string")
	table.insert(self.messages, message)
end
function playerMethods:teleportTo(destination)
	self.calls = self.calls + 1
	-- Model failure, including the burst budget being charged before the engine's
	-- same-position check. This does not replace native rate-limit tests.
	if self.calls > self.limit or destination == self.position then
		return false
	end
	self.position = Position(destination)
	table.insert(self.visited, self.position)
	return true
end
local function makePlayer(limit)
	return setmetatable({ position = outside, storages = {}, messages = {}, calls = 0, limit = limit or math.huge, nativeMoves = 0, visited = {} }, playerMethods)
end

local function enter(player, position)
	local tile = assert(Tile(position))
	local fromPosition = player.position
	player.position = tile.position
	local teleport = tile:getItemByType(ITEM_TYPE_TELEPORT)
	if teleport and teleport.destination ~= zero then
		player.position = teleport.destination
		player.nativeMoves = player.nativeMoves + 1
		table.insert(player.visited, player.position)
	end
	local items = { tile.ground }
	for _, item in ipairs(tile.items) do
		table.insert(items, item)
	end
	local result, callbacks = true, 0
	for _, item in ipairs(items) do
		if item:getActionId() == movement.actionId then
			callbacks = callbacks + 1
			result = movement.onStepIn(player, item, tile.position, fromPosition)
			if not result then
				break
			end
		end
	end
	return result, callbacks
end

test("startup data gives the five quest portals one explicit owner", function()
	assert(ItemAction[actionId] == nil)
	assert(TeleportAction[actionId].scriptedTeleport == true)
	assert(#TeleportAction[actionId].itemPos == 5)
	initialize()
	assert(#errors == 0)
	for _, position in ipairs(TeleportAction[actionId].itemPos) do
		local tile = assert(Tile(position))
		assert(tile.ground:getActionId() == 0)
		assert(tile.items[1]:getActionId() == actionId)
		assert(tile.items[1].destination == zero)
	end
end)

test("startup removes duplicate quest hooks but preserves unrelated actions", function()
	initialize()
	local tile = Tile(scar)
	table.insert(tile.items, makeItem(scar, 14900, actionId))
	table.insert(tile.items, makeItem(scar, 14901, 9001))
	loadLuaMapAction(TeleportAction)
	loadLuaMapAction(TeleportAction)
	assert(tile.items[2]:getActionId() == 0)
	assert(tile.items[3]:getActionId() == 9001)
	assert(tile.items[1].destination == zero)
	local player = makePlayer()
	local result, callbacks = enter(player, scar)
	assert(result and callbacks == 1 and player.calls == 1)
	assert(player.position == outside and player.nativeMoves == 0)
end)

test("missing scripted portal is diagnosed without assigning its ground", function()
	initialize()
	local tile = Tile(scar)
	tile.items = {}
	loadLuaMapAction(TeleportAction)
	assert(#errors == 1 and tile.ground:getActionId() == 0)
end)

test("ordinary native portals keep their destination and explicit item binding", function()
	initialize()
	local position = Position(100, 100, 7)
	local destination = Position(110, 100, 7)
	local tile = makeTile(position, 1949, destination)
	loadLuaMapAction({ [9002] = { itemId = 1949, itemPos = { position } } })
	assert(tile.items[1].destination == destination)
	assert(tile.items[1]:getActionId() == 9002 and tile.ground:getActionId() == actionId)
end)

test("legacy itemId=false entries outside this quest keep their behavior", function()
	initialize()
	local position = Position(101, 100, 7)
	local tile = makeTile(position, 1949, scarDestination)
	loadLuaMapAction({ [9003] = { itemId = false, itemPos = { position } } })
	assert(tile.items[1]:getActionId() == 9003 and tile.ground:getActionId() == 9003)
	assert(tile.items[1].destination == scarDestination)
end)

test("negative control reproduces the sixth-entry bypass with the old map policy", function()
	initialize()
	local tile = Tile(scar)
	tile.items[1]:setDestination(scarDestination)
	tile.ground:setAttribute(ITEM_ATTRIBUTE_ACTIONID, actionId)
	local player = makePlayer(10)
	for _ = 1, 5 do
		enter(player, scar)
		assert(player.position == outside)
	end
	enter(player, scar)
	assert(player.position == scarDestination, "fixture must detect native entry before authorization")
end)

test("100 denied retries never enter the room even when return teleports fail", function()
	initialize()
	local player = makePlayer(10)
	for attempt = 1, 100 do
		player.position = outside -- Walk back outside before retrying the portal.
		local result, callbacks = enter(player, scar)
		assert(callbacks == 1 and player.calls == attempt)
		assert(player.position == (result and outside or scar))
	end
	assert(player.nativeMoves == 0 and #effects == 10)
	for _, position in ipairs(player.visited) do
		assert(position == outside, "denied player reached a protected destination")
	end
end)

local dailyBosses = {
	{ "Monday", "AlptramunTimer", "Alptramun" },
	{ "Tuesday", "IzcandarTimer", "Izcandar the Banished" },
	{ "Wednesday", "MalofurTimer", "Malofur Mangrinder" },
	{ "Thursday", "MaxxeniusTimer", "Maxxenius" },
	{ "Friday", "IzcandarTimer", "Izcandar the Banished" },
	{ "Saturday", "PlagueRootTimer", "Plagueroot" },
	{ "Sunday", "MaxxeniusTimer", "Maxxenius" },
}
for _, boss in ipairs(dailyBosses) do
	test(boss[1] .. ": permission and cooldown boundaries", function()
		initialize()
		day = boss[1]
		for _, cooldown in ipairs({ -1, now, now + 1 }) do
			local player = makePlayer()
			player.storages[quest.DreamScar.Permission] = 1
			player.storages[quest.DreamScarGlobal[boss[2]]] = cooldown
			local result, callbacks = enter(player, scar)
			assert(result and callbacks == 1 and player.calls == 1 and player.nativeMoves == 0)
			assert(player.position == (cooldown > now and outside or scarDestination))
			if cooldown > now then
				assert(player.messages[1] == "You have to wait to challenge " .. boss[3] .. " again!")
			end
		end
	end)
end

test("authorized entry fails closed when its teleport is rejected", function()
	initialize()
	local player = makePlayer(0)
	player.storages[quest.DreamScar.Permission] = 1
	assert(not enter(player, scar))
	assert(player.position == scar and player.nativeMoves == 0 and #effects == 0)
end)

test("rejected rollback has no success effect and never enters the room", function()
	initialize()
	local player = makePlayer(0)
	assert(not enter(player, scar))
	assert(player.position == scar and #effects == 0 and player.nativeMoves == 0)
end)

test("an unknown weekday does not authorize entry", function()
	initialize()
	day = "unknown"
	local player = makePlayer()
	player.storages[quest.DreamScar.Permission] = 1
	assert(enter(player, scar) and player.position == outside)
end)

test("Nightmare Beast preserves boss-count and cooldown requirements", function()
	initialize()
	for _, count in ipairs({ 4, 5 }) do
		for _, cooldown in ipairs({ now, now + 1 }) do
			local player = makePlayer()
			player.storages[quest.DreamScar.BossCount] = count
			player.storages[quest.DreamScar.NightmareTimer] = cooldown
			assert(enter(player, nightmare))
			local allowed = count >= 5 and cooldown <= now
			assert(player.position == (allowed and nightmareDestination or outside))
			assert(player.calls == 1 and player.nativeMoves == 0)
		end
	end
end)

local gateways = {
	{ Position(33618, 32546, 13), Position(32723, 32270, 8) },
	{ Position(32720, 32270, 8), Position(33618, 32544, 13) },
	{ Position(33619, 32526, 15), Position(33619, 32528, 15) },
}
for _, gateway in ipairs(gateways) do
	test("Haunted House gate " .. gateway[1]:toString(), function()
		initialize()
		for _, progress in ipairs({ -1, 1, 2 }) do
			local player = makePlayer()
			player.storages[quest.HauntedHouse.Questline] = progress
			assert(enter(player, gateway[1]))
			assert(player.position == (progress >= 2 and gateway[2] or outside))
			assert(player.calls == 1 and player.nativeMoves == 0)
		end
	end)
end

test("non-player creatures do not bypass quest admission through a native destination", function()
	initialize()
	local creature = makePlayer()
	creature.nonPlayer = true
	assert(enter(creature, scar))
	assert(creature.position == scar and creature.calls == 0 and creature.nativeMoves == 0)
end)

test("a failed rubble crossing does not report a successful crossing", function()
	initialize()
	local player = makePlayer(0)
	player.storages[quest.HauntedHouse.Questline] = 2
	local rubble = Position(33619, 32526, 15)
	assert(not enter(player, rubble))
	assert(player.position == rubble and #player.messages == 0 and #effects == 0)
end)

print(string.format("Dream Courts teleport access: %d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
