-- Isolated behavioral harness; run with LuaJIT (no server/SQL required).
local n = 0
setmetatable(_G, {
	__index = function(t, k)
		if k:match("^[A-Z][A-Z_0-9]+$") then
			n = n + 1
			rawset(t, k, n)
			return n
		end
	end,
})
local world, serial, now = 0, 100, 1000000
os.time = function()
	return now
end
local entities, tiles, messages = { [0] = {}, [1] = {} }, {}, {}
local position = {}
function Position(x, y, z)
	return setmetatable({ x = x, y = y, z = z }, { __index = position })
end
function position:getDistance(p)
	return math.max(math.abs(self.x - p.x), math.abs(self.y - p.y), math.abs(self.z - p.z))
end
function position:sendMagicEffect() end
local function tileKey(p)
	return world .. ":" .. p.x .. ":" .. p.y .. ":" .. p.z
end
local itemMethods = {}
local function item(id, pos)
	return setmetatable({ id = id, pos = pos, attrs = {} }, { __index = itemMethods })
end
function itemMethods:getId()
	return self.id
end
function itemMethods:getCustomAttribute(k)
	return self.attrs[k]
end
function itemMethods:setCustomAttribute(k, v)
	self.attrs[k] = v
end
function itemMethods:remove()
	if self.removed then
		return false
	end
	self.removed = true
	return true
end
function itemMethods:transform(id)
	self.id = id
end
function itemMethods:decay() end
function itemMethods:setActionId(id)
	self.actionid = id
end
function Tile(pos)
	local key = tileKey(pos)
	tiles[key] = tiles[key]
		or {
			items = {},
			getItemById = function(self, id)
				for _, v in pairs(self.items) do
					if v.id == id and not v.removed then
						return v
					end
				end
			end,
			isWalkable = function(self)
				if self.blocked then
					return false
				end
				for _, creature in pairs(entities[world]) do
					if creature.pos.x == pos.x and creature.pos.y == pos.y and creature.pos.z == pos.z then
						return false
					end
				end
				return true
			end,
		}
	return tiles[key]
end
local methods = {}
function methods:getId()
	return self.id
end
function methods:getGuid()
	return self.id
end
function methods:getWorldId()
	return self.world
end
function methods:getPosition()
	return self.pos
end
function methods:canSee(pos)
	return self.pos:getDistance(pos) <= 8
end
function methods:getName()
	return self.name
end
function methods:setName(name)
	self.name = name
end
function methods:hasCondition(kind)
	return self.conditions and self.conditions[kind] == true
end
function methods:removeCondition(kind)
	self.conditions[kind] = nil
	if kind == CONDITION_GREATERHEX and self.preHexMaximum then
		self.max = self.preHexMaximum
		self.preHexMaximum = nil
	end
end
function methods:isMonster()
	return not self.player
end
function methods:isPlayer()
	return self.player or false
end
function methods:getHealth()
	return self.hp
end
function methods:getMaxHealth()
	return self.max
end
function methods:getStorageValue(k)
	return self.storage[k] or -1
end
function methods:setStorageValue(k, v)
	self.storage[k] = v
end
function methods:getBossCooldown(k)
	return self.cooldowns[k:lower()] or 0
end
function methods:setBossCooldown(k, value)
	self.cooldowns[k:lower()] = value
end
function methods:setMoveLocked(v)
	self.locked = v
end
function methods:teleportTo(pos)
	self.pos = pos
end
function methods:registerEvent(name)
	self.events[name] = true
end
function methods:say() end
function methods:sendTextMessage(_, message)
	messages[#messages + 1] = message
end
function methods:getVocation()
	local id = self.vocation
	return {
		getBase = function()
			return {
				getId = function()
					return id
				end,
			}
		end,
	}
end
function methods:remove()
	entities[self.world][self.id] = nil
end
function methods:setHealth(hp)
	self.hp = math.min(self.max, hp)
end
function methods:addHealth(delta)
	self.lastHealthDelta = delta
	if delta < 0 then
		self.hp = math.max(0, self.hp + delta)
		if self.hp == 0 then
			GraveDanger.death(self, item(1, self.pos))
			self:remove()
		end
	else
		self.hp = math.min(self.max, self.hp + delta)
	end
end
local definitions = {}
local function entity(name, pos, player, vocation)
	serial = serial + 1
	local definition = definitions[name:lower()] or { health = 75000, maxHealth = 75000 }
	local obj = setmetatable({ id = serial, name = name, pos = pos, world = world, player = player, vocation = vocation, hp = definition.health, max = definition.maxHealth, storage = {}, cooldowns = {}, events = {} }, { __index = methods })
	entities[world][serial] = obj
	return obj
end
Game = {
	createMonsterType = function(name)
		return {
			register = function(_, definition)
				definitions[name:lower()] = definition
			end,
		}
	end,
	getWorldId = function()
		return world
	end,
	createMonster = function(name, pos)
		return entity(name, pos)
	end,
	createItem = function(id, count, pos)
		local obj = item(id, pos)
		Tile(pos).items[id] = obj
		return obj
	end,
	getTimeInWords = tostring,
	getSpectators = function(pos, multifloor, players, left, right, up, down)
		local result = {}
		for _, c in pairs(entities[world]) do
			local p = c.pos
			if c.hp > 0 and (not players or c.player) and p.z == pos.z and p.x >= pos.x - left and p.x <= pos.x + right and p.y >= pos.y - up and p.y <= pos.y + down then
				result[#result + 1] = c
			end
		end
		return result
	end,
}
for _, path in ipairs({ "bosses/lord_azaram", "bosses/king_zelos", "bosses/scarlett_etzel", "bosses/sir_nictros", "bosses/duke_krule", "bosses/earl_osam", "azarams_soul", "shard_of_magnor", "dark_merudri", "bosses/sir_baeloc", "regenerating_mass", "condensed_sin", "condensed_sins", "rewar_the_bloody", "rewar_the_bloody_inv" }) do
	dofile("data-otservbr-global/monster/quests/grave_danger/" .. path .. ".lua")
end
assert(definitions["duke krule"].health == 290000 and definitions["duke krule"].heals[1].percent == 100)
assert(definitions["sir nictros"].health == 150000 and definitions["sir nictros"].heals[1].percent == 300)
assert(definitions["lord azaram"].heals[1].percent == 260)
assert(definitions["dark merudri"].corpse == 50311)
assert(definitions["earl osam"].health == 300000 and definitions["sir baeloc"].health == 150000)
assert(definitions["shard of magnor"].health == 205000 and definitions["regenerating mass"].health == 110000)
-- Validate the real registration adapter, not a second assumed heal format.
MonsterType = {}
dofile("data/scripts/lib/register_monster_type.lua")
for _, name in ipairs({ "duke krule", "sir nictros", "lord azaram", "earl osam", "sir baeloc", "king zelos" }) do
	local registered = {}
	registerMonsterType.heals({
		addHealing = function(_, kind, percent)
			registered[kind] = percent
		end,
	}, definitions[name])
	local heal = definitions[name].heals[1]
	assert(registered[heal.type] == heal.percent)
	local immune = false
	for _, element in ipairs(definitions[name].elements) do
		if element.type == heal.type then
			immune = element.percent == 100
		end
	end
	assert(immune) -- Native conversion heals without also applying elemental damage.
end
configKeys = { MAX_DAMAGE_REFLECTION = 1 }
configManager = {
	getNumber = function()
		return 100
	end,
}
for _, name in ipairs({ "condensed sin", "condensed sins" }) do
	local reflected
	registerMonsterType.reflects({
		addReflect = function(_, kind, percent)
			reflected = { kind, percent }
		end,
	}, definitions[name])
	assert(reflected[1] == COMBAT_DEATHDAMAGE and reflected[2] == 100)
end
local timers = {}
function addEvent(fn, delay, ...)
	timers[#timers + 1] = { fn = fn, at = now + delay / 1000, args = { ... }, world = world }
end
local function advance(seconds)
	now = now + seconds
	local pending = timers
	timers = {}
	for _, timer in ipairs(pending) do
		if timer.at <= now then
			local previous = world
			world = timer.world
			timer.fn(unpack(timer.args))
			world = previous
		else
			timers[#timers + 1] = timer
		end
	end
end
function Monster(id)
	return entities[world][id]
end
local hits = {}
function doTargetCombatHealth(source, target, kind, low, high)
	assert(target.world == world)
	hits[#hits + 1] = { target = target, low = low }
end
BossLever = setmetatable({}, {
	__index = function(t, key)
		local v = { finishEncounter = function() end }
		rawset(t, key, v)
		return v
	end,
})
Storage = { Quest = { U12_20 = { GraveDanger = { Bosses = {} } } } }
for i, key in ipairs({ "CountVlarkorth", "EarlOsam", "LordAzaram", "BaelocNictros", "KingZelos" }) do
	Storage.Quest.U12_20.GraveDanger.Bosses[key] = { Timer = i }
end
dofile("data-otservbr-global/lib/quests/grave_danger.lua")
local function find(name)
	for _, c in pairs(entities[world]) do
		if c.name:lower() == name:lower() then
			return c
		end
	end
end
local function list(name)
	local result = {}
	for _, c in pairs(entities[world]) do
		if c.name:lower() == name:lower() then
			result[#result + 1] = c
		end
	end
	return result
end
local function health(c, amount)
	return GraveDanger.health(c, nil, amount, COMBAT_PHYSICALDAMAGE, 0, COMBAT_NONE)
end
local function kill(c)
	c.hp = 0
	local corpse = item(31203, c.pos)
	GraveDanger.death(c, corpse)
	c:remove()
	return corpse
end
local function start(name, x, y)
	assert(GraveDanger.start(name, Position(x, y, 13)))
	return find(name)
end

-- Count: lethal strikes cannot skip immunity; corpse vocation/world/session are mandatory.
local knight = entity("player", Position(33456, 31440, 13), true, 4)
local count = start("Count Vlarkorth", 33456, 31434)
assert(#list("Soulless Minion") == 5)
assert(health(count, 90000) == 0)
assert(find("Dark Knight"))
assert(health(count, 1) == 0)
assert(health(count, 999999) == 0) -- No damage can bypass the remains phase.

-- Monk participates in both rounds; only matching, current-world/session remains work.
local monk = entity("monk", Position(33456, 31440, 13), true, 9)
count = start("Count Vlarkorth", 33456, 31434)
health(count, 20000)
assert(#list("Dark Merudri") == 1)
local monkRemains = kill(find("Dark Merudri"))
assert(not GraveDanger.useRemains(knight, monkRemains, count, 9))
assert(GraveDanger.useRemains(monk, monkRemains, count, 9))
-- Verify the new item is actually reachable through the registered Action.
local remainsAction = {
	id = function(self, ...)
		self.ids = { ... }
	end,
	register = function() end,
}
function Action()
	return remainsAction
end
dofile("data-otservbr-global/scripts/quests/grave_danger_quest/actions_dark_remains.lua")
assert(remainsAction.ids[5] == 50311)
assert(GraveDanger.useRemains(knight, kill(find("Dark Knight")), count, 4))
health(count, 20000)
assert(#list("Dark Merudri") == 1)
local remains = kill(find("Dark Knight"))
assert(GraveDanger.useRemains(knight, remains, count, 4))
assert(not GraveDanger.useRemains(knight, remains, count, 4))
local secondMonkRemains = kill(find("Dark Merudri"))
secondMonkRemains.itemid = 50311
assert(remainsAction.onUse(monk, secondMonkRemains, nil, count))
assert(health(count, 1) == 1)
count = start("Count Vlarkorth", 33456, 31434)
health(count, 20000)
assert(not GraveDanger.useRemains(knight, remains, count, 4))
-- Identical encounter in the other world must not change this shield.
world = 1
local otherCount = start("Count Vlarkorth", 33456, 31434)
assert(health(otherCount, 1) == 1)
world = 0
assert(health(count, 1) == 0)

-- Osam is time-driven: damage cannot accelerate the channel and no hit is required.
local osam = start("Earl Osam", 33488, 31441)
assert(health(osam, 60000) == 60000 and not osam.locked)
GraveDanger.think(osam, 39999)
assert(health(osam, 60000) == 60000 and #list("Magical Sphere") == 0)
GraveDanger.think(osam, 1)
assert(osam.locked and osam:getName() == "Channeling Earl Osam")
assert(health(osam, 60000) == 0 and #list("Magical Sphere") == 4)
for _, sphere in ipairs(list("Magical Sphere")) do
	kill(sphere)
end
GraveDanger.think(osam, 4000)
assert(not osam.locked and osam:getName() == "Earl Osam")
GraveDanger.think(osam, 55999)
assert(#list("Magical Sphere") == 0)
GraveDanger.think(osam, 1)
assert(osam.locked and #list("Magical Sphere") == 4) -- 60 seconds start-to-start.
osam.hp = 100
for i = 1, 8 do
	GraveDanger.think(osam, 4000)
end
assert(osam.hp == osam.max and not osam.locked and osam.lastHealthDelta == 80000)
-- Further channels do not stop after an arbitrary four-round cap.
for round = 1, 4 do
	GraveDanger.think(osam, 60000)
	assert(osam.locked and #list("Magical Sphere") == 4)
	for _, sphere in ipairs(list("Magical Sphere")) do
		kill(sphere)
	end
	GraveDanger.think(osam, 4000)
end

-- Azaram: three cleansed fragments release the boss, even at full soul health.
local azaram = start("Lord Azaram", 33424, 31473)
GraveDanger.think(azaram, 5000)
assert(find("Condensed Sin"))
assert(health(azaram, 40000) == 0)
assert(not find("Condensed Sin"))
local soul = find("Azaram's Soul")
assert(soul)
assert(GraveDanger.health(soul, knight, 25000, COMBAT_HEALING, 0, COMBAT_NONE) == 25000)
-- Apply real healing rather than substituting a full-health fixture.
soul:addHealth(soul.max)
GraveDanger.think(soul, 1000)
assert(not find("Azaram's Soul") and not azaram.locked)
azaram = find("Lord Azaram")
-- A new soul round remains immune to damage but accepts area/rune healing.
assert(health(azaram, 40000) == 0)
soul = find("Azaram's Soul")
assert(health(soul, 1000) == 0)
local foreignFragment = item(31160, soul.pos)
assert(not GraveDanger.cleanse(soul, foreignFragment))
-- Even full direct healing cannot skip the last fragment ritual.
soul:addHealth(soul.max)
GraveDanger.think(soul, 1000)
assert(find("Azaram's Soul"))
for i = 1, 3 do
	local fragment = kill(list("Tainted Soul Splinter")[1])
	assert(fragment.id == 31160)
	assert(GraveDanger.cleanse(soul, fragment))
end
azaram = find("Lord Azaram")
assert(not find("Azaram's Soul") and not azaram.locked and health(azaram, 1) == 1)
-- Azaram can run the soul/splinter ritual twice, but never enter a third loop.
assert(health(azaram, 40000) == 40000)
GraveDanger.think(azaram, 5000)
GraveDanger.think(azaram, 5000)
assert(#list("Condensed Sin") <= 2)
azaram.pos = Position(33400, 31472, 13)
GraveDanger.think(azaram, 1)
assert(azaram.pos.x == 33424 and azaram.pos.y == 31472)

-- Both rounds complete using actual fragments alone, starting at the native 1 HP.
azaram = start("Lord Azaram", 33424, 31473)
local staleFragment
for round = 1, 2 do
	health(azaram, 40000)
	soul = find("Azaram's Soul")
	assert(soul.hp == (round == 1 and 1 or 100000) and soul.max == 100000)
	if staleFragment then
		assert(not GraveDanger.cleanse(soul, staleFragment))
	end
	local fragments = list("Tainted Soul Splinter")
	if round == 1 then
		staleFragment = kill(fragments[4])
	end
	for i = 1, 3 do
		local createMonster = Game.createMonster
		if round == 2 and i == 3 then
			Game.createMonster = function(name, ...)
				if name == "Lord Azaram" then
					return nil
				end
				return createMonster(name, ...)
			end
		end
		assert(GraveDanger.cleanse(soul, kill(fragments[i])))
		if round == 2 and i == 3 then
			assert(find("Azaram's Soul") and not find("Lord Azaram"))
			Game.createMonster = createMonster
			GraveDanger.think(soul, 1000)
		end
		if i < 3 then
			assert(find("Azaram's Soul"))
		end
	end
	azaram = find("Lord Azaram")
	assert(azaram and not find("Azaram's Soul"))
end

-- Brothers: introduction protection, clamped swaps at 60%, then simultaneous combat.
local nictros = start("Sir Nictros", 33427, 31428)
local baeloc = find("Sir Baeloc")
assert(health(nictros, 1) == 0 and health(baeloc, 1) == 0)
GraveDanger.think(nictros, 12000)
assert(health(nictros, 1) == 1 and health(baeloc, 1) == 0)
assert(health(nictros, 999999) == nictros.max * 0.4)
assert(nictros.locked and not baeloc.locked)
assert(health(nictros, 1) == 0)
health(baeloc, 999999)
assert(not nictros.locked and health(nictros, 1) == 1)
assert(GraveDanger.brothersAlive(nictros))
kill(nictros)
assert(not GraveDanger.brothersAlive(baeloc))
assert(health(baeloc, 1) == 1)

-- Zelos: guards, fetters, blood explosions, shared shards, 30-second mass retry.
local function assertFetterPositions()
	local expected = { [31558] = true, [31566] = true }
	assert(#list("Fetter") == 2)
	for _, fetter in ipairs(list("Fetter")) do
		local p = fetter:getPosition()
		assert(p.x == 33463 and p.z == 13 and expected[p.y])
		expected[p.y] = nil
	end
	assert(next(expected) == nil)
end
local zelos = start("King Zelos", 33443, 31545)
assertFetterPositions()
local soldierPositions = { [33459] = true, [33467] = true }
for _, soldier in ipairs(list("Risen Soldier")) do
	local p = soldier:getPosition()
	if p.x > 33450 then
		assert(p.y == 31562 and p.z == 13 and soldierPositions[p.x])
		soldierPositions[p.x] = nil
	end
end
assert(next(soldierPositions) == nil)
assert(#list("Vampiric Blood") == 2 and #list("Risen Soldier") == 8) -- Red room 3 + Zelos room 3 + Rewar 2.
local spawnPositions = {}
for _, blood in ipairs(list("Vampiric Blood")) do
	local p = blood.pos
	assert(p.x >= 33415 and p.x <= 33431 and p.y >= 31553 and p.y <= 31571 and p.z == 13)
	assert(not spawnPositions[tileKey(p)])
	spawnPositions[tileKey(p)] = true
end
world = 1
local otherZelos = start("King Zelos", 33443, 31545)
assertFetterPositions()
assert(#list("Vampiric Blood") == 2)
kill(find("Vampiric Blood"))
assert(#list("Vampiric Blood") == 1)
world = 0
assert(#list("Vampiric Blood") == 2)
world = 1
GraveDanger.think(otherZelos, 10000)
assert(#list("Vampiric Blood") == 2)
world = 0
assert(health(zelos, 1000) == 0 and not GraveDanger.canEnterZelos(knight))
local rewar = find("Rewar The Bloody")
assert(health(rewar, 100) == 0 and #list("Fetter") == 2)
rewar:teleportTo(Position(33453, 31553, 13))
assert(health(rewar, 999999) == 0) -- Protection belongs to the room, not Fetter view range.
for _, fetter in ipairs(list("Fetter")) do
	kill(fetter)
end
assert(health(rewar, 100) == 100)
assert(rewar.pos.x == 33463 and rewar.pos.y == 31562)
GraveDanger.think(zelos, 5999)
assert(#list("Fetter") == 0 and health(rewar, 100) == 100)
GraveDanger.think(zelos, 1)
assert(#list("Fetter") == 2 and health(rewar, 100) == 0)
assertFetterPositions()
for _, fetter in ipairs(list("Fetter")) do
	kill(fetter)
end
GraveDanger.think(zelos, 5000)
assert(find("Vampiric Blood"))
local blood = find("Vampiric Blood")
blood:teleportTo(find("The Red Knight"):getPosition()) -- Lure the randomly spawned blood.
kill(blood)
assert(#hits > 0)
assert(#list("Vampiric Blood") == 1)
GraveDanger.think(zelos, 9999)
assert(#list("Vampiric Blood") == 1)
GraveDanger.think(zelos, 1)
assert(#list("Vampiric Blood") == 2)
GraveDanger.think(zelos, 20000)
assert(#list("Vampiric Blood") == 2 and #list("Risen Soldier") == 8)
local finalSoldiers = {}
for _, soldier in ipairs(list("Risen Soldier")) do
	if soldier.pos.y < 31550 then
		finalSoldiers[#finalSoldiers + 1] = soldier
	end
end
assert(#finalSoldiers == 3)
kill(finalSoldiers[1])
GraveDanger.think(zelos, 5000)
assert(#list("Risen Soldier") == 8)
-- A failed placement is retried at the next maintenance pulse, without exceeding caps.
kill(find("Vampiric Blood"))
local createSupport = Game.createMonster
Game.createMonster = function(name, ...)
	if name == "Vampiric Blood" then
		return nil
	end
	return createSupport(name, ...)
end
GraveDanger.think(zelos, 10000)
assert(#list("Vampiric Blood") == 1)
Game.createMonster = createSupport
GraveDanger.think(zelos, 1000)
assert(#list("Vampiric Blood") == 2)
kill(rewar)
kill(find("The Red Knight"))
kill(find("Vampiric Blood"))
GraveDanger.think(zelos, 5000)
assert(#list("Vampiric Blood") == 1) -- Stop replenishing after the owner dies.
kill(find("Magnor Mournbringer"))
local shards = list("Shard of Magnor")
assert(#shards == 4)
health(shards[1], 100)
assert(shards[2].hp == shards[2].max - 100)
for _, shard in ipairs(shards) do
	kill(shard)
end
kill(find("Nargol The Impaler"))
assert(find("Regenerating Mass") and not GraveDanger.canEnterZelos(knight))
advance(29)
assert(find("Regenerating Mass") and not find("Nargol The Impaler"))
advance(1)
assert(find("Nargol The Impaler") and not find("Regenerating Mass"))
kill(find("Nargol The Impaler"))
assert(find("Regenerating Mass") and not GraveDanger.canEnterZelos(knight))
advance(30)
assert(find("Nargol The Impaler") and not find("Regenerating Mass"))
kill(find("Nargol The Impaler"))
assert(find("Regenerating Mass") and not GraveDanger.canEnterZelos(knight))
kill(find("Regenerating Mass"))
now = now + 360
assert(GraveDanger.canEnterZelos(knight))
assert(health(zelos, 1000) > 0)
local earlyDamage = health(zelos, 1000)
advance(60)
assert(health(zelos, 1000) == earlyDamage) -- Ritual strength is fixed after the guardians die.
advance(1000)
assert(health(zelos, 1000) == earlyDamage) -- No artificial final-fight immunity timer.
assert(not find("Nargol The Impaler")) -- A killed mass invalidates its pending callback.
-- Compare separate rituals rather than strengthening an already completed one.
world = 1
for _, sample in ipairs({ { 0, 1000 }, { 450, 375 }, { 720, 0 }, { 1020, 0 } }) do
	local sampleZelos = start("King Zelos", 33443, 31545)
	advance(sample[1])
	for _, name in ipairs({ "Rewar The Bloody", "The Red Knight", "Magnor Mournbringer", "Nargol The Impaler" }) do
		kill(find(name))
	end
	for _, shard in ipairs(list("Shard of Magnor")) do
		kill(shard)
	end
	kill(find("Regenerating Mass"))
	assert(health(sampleZelos, 1000) == sample[2])
	advance(10)
	assert(health(sampleZelos, 1000) == sample[2])
end
world = 0
assert(GraveDanger.unleashHex(knight) and find("Unleashed Hex"))

-- Cleansing is atomic on spawn failure, exhausts the vortex and rejects stale timers.
knight.conditions = { [CONDITION_GREATERHEX] = true }
knight.preHexMaximum = 10000
knight.max = 4000
knight.hp = 2000
local vortex = Game.createItem(32415, 1, Position(33443, 31539, 13))
zelos.hp = 100000
assert(GraveDanger.cleanseHex(knight))
assert(not knight:hasCondition(CONDITION_GREATERHEX) and vortex.id == 32416)
assert(knight.max == 10000 and knight.hp == 2000) -- Native max-HP reversal never heals current HP.
assert(zelos.hp >= 110000 and zelos.hp <= 115000)
knight.conditions[CONDITION_GREATERHEX] = true
assert(not GraveDanger.cleanseHex(knight) and knight:hasCondition(CONDITION_GREATERHEX))
advance(60)
assert(vortex.id == 32415)
-- Exercise the actual movement callbacks; neither trigger offers a free cleanse.
local movements = {}
function MoveEvent()
	local event = {
		position = function() end,
		register = function(self)
			movements[#movements + 1] = self
		end,
	}
	return event
end
dofile("data-otservbr-global/scripts/quests/grave_danger_quest/movements_zelos_cleanse.lua")
knight.conditions[CONDITION_GREATERHEX] = true
knight.preHexMaximum = 10000
knight.max = 4000
knight.hp = 4000
movements[1].onStepIn(knight)
assert(not knight:hasCondition(CONDITION_GREATERHEX))
assert(knight.max == 10000 and knight.hp == 4000)
knight.conditions[CONDITION_GREATERHEX] = true
movements[2].onStepIn(knight)
assert(knight:hasCondition(CONDITION_GREATERHEX))
advance(60)
local createMonster = Game.createMonster
Game.createMonster = function(name, ...)
	if name == "Unleashed Hex" then
		return nil
	end
	return createMonster(name, ...)
end
local before = zelos.hp
assert(not GraveDanger.cleanseHex(knight))
assert(knight:hasCondition(CONDITION_GREATERHEX) and vortex.id == 32415 and zelos.hp == before)
Game.createMonster = createMonster
assert(GraveDanger.cleanseHex(knight))
world = 1
assert(not GraveDanger.cleanseHex(knight)) -- Owner's world must match callback context.
world = 0
start("King Zelos", 33443, 31545)
assert(vortex.id == 32415)
advance(30)
knight.conditions[CONDITION_GREATERHEX] = true
assert(GraveDanger.cleanseHex(knight))
advance(30) -- Old encounter's callback must not restore the new encounter's vortex.
assert(vortex.id == 32416)
advance(30)
assert(vortex.id == 32415)

-- Scarlett: armor vulnerability, one mirror hit, protection and 30-second armor return.
local scarlett = start("Scarlett Etzel", 33396, 32643)
assert(health(scarlett, 1000) == 0)
local armor = Tile(Position(33398, 32640, 6)):getItemById(31482)
assert(GraveDanger.scarlettArmor(knight, armor))
for _, data in ipairs({ { 33394, 32642, 31474 }, { 33398, 32642, 31475 }, { 33394, 32646, 31477 }, { 33398, 32646, 31476 } }) do
	Game.createItem(data[3], 1, Position(data[1], data[2], 6))
end
assert(health(scarlett, 1) == 7500)
assert(health(scarlett, 1) == 0)
GraveDanger.think(scarlett, 30000)
assert(Tile(Position(33398, 32640, 6)):getItemById(31482))

-- Legacy cooldown gate preserves previous timestamps without writing on health hits.
knight.storage[Storage.Quest.U12_20.GraveDanger.Bosses.EarlOsam.Timer] = now + 72000
assert(not GraveDanger.checkEntry("Earl Osam", knight))
now = now + 72001
assert(GraveDanger.checkEntry("Earl Osam", knight))
local leverRegistry = BossLever
local scarlettConfig
BossLever = function(config)
	scarlettConfig = config
	return { position = function() end, register = function() end }
end
Action = function()
	return { aid = function() end, register = function() end }
end
dofile("data-otservbr-global/scripts/quests/grave_danger_quest/cobra_bastion/actions_scarlett.lua")
assert(scarlettConfig.timeToDefeat == 600 and scarlettConfig.timeToFightAgain == 72000)
BossLever = leverRegistry
print("Grave Danger: Count, Osam, Azaram, brothers, Zelos guardians/ritual, Scarlett and world/session isolation OK")

-- Upstream single-world servers do not expose the optional world API.
world = 0
Game.getWorldId = nil
local legacyBoss = start("Earl Osam", 33488, 31441)
legacyBoss.getWorldId = false
GraveDanger.think(legacyBoss, 40000)
assert(legacyBoss:getName() == "Channeling Earl Osam", "single-world Osam channel")
