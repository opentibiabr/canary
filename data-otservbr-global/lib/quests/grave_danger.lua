-- Encounter state is ephemeral, world-owned and replaced on every lever start.
-- State contains only IDs and values; no timer retains a creature userdata.
GraveDanger = {}
local activeLibrary = GraveDanger
-- Upstream is single-world; retain explicit ownership on multi-world servers.
local function owningWorldId(owner)
	if owner then
		return owner.getWorldId and owner:getWorldId() or 0
	end
	return Game.getWorldId and Game.getWorldId() or 0
end
local sessions = {}
local sequence = 0
local sessionStorage = 175800
-- Video jy-qVcwd94Q: channels around 0:43 and 1:41; calibrated, not official timers.
local osamFirstPhaseDelay = 40000
local osamPhaseInterval = 60000
local redKnightSupportInterval = 5000
local redKnightRespawnDelay = 10000 -- Per creature, measured further during live validation.
local rewarVulnerabilityWindow = 6000 -- About three attack turns (Tibia Life walkthrough).
local zelosResistanceHorizon = 12 * 60 -- Approximation of the documented ritual deadline.
local rewarFetterPositions = { Position(33463, 31558, 13), Position(33463, 31566, 13) }
-- Stable local anchors; video confirms the composition, not these exact coordinates.
local redKnightSupportSpawns = {
	{ name = "Risen Soldier", position = Position(33419, 31560, 13) },
	{ name = "Risen Soldier", position = Position(33423, 31566, 13) },
	{ name = "Risen Soldier", position = Position(33427, 31560, 13) },
	{ name = "Vampiric Blood", position = Position(33419, 31562, 13) },
	{ name = "Vampiric Blood", position = Position(33427, 31562, 13) },
}
local rooms = {
	["count vlarkorth"] = { center = Position(33456, 31437, 13), x = 8, y = 9, timer = "CountVlarkorth" },
	["earl osam"] = { center = Position(33488, 31438, 13), x = 9, y = 9, timer = "EarlOsam" },
	["lord azaram"] = { center = Position(33424, 31472, 13), x = 8, y = 9, timer = "LordAzaram" },
	["sir nictros"] = { center = Position(33424, 31438, 13), x = 10, y = 12, timer = "BaelocNictros" },
	["king zelos"] = { center = Position(33444, 31547, 13), x = 30, y = 27, timer = "KingZelos" },
	["scarlett etzel"] = { center = Position(33396, 32649, 6), x = 11, y = 11 },
}
local function monsters(state)
	return Game.getSpectators(state.room.center, false, false, state.room.x, state.room.x, state.room.y, state.room.y)
end
local function resolve(state, id)
	if GraveDanger ~= activeLibrary then
		return
	end
	local creature = id and Monster(id)
	if creature and owningWorldId(creature) == state.world and creature:getHealth() > 0 and creature:getStorageValue(sessionStorage) == state.token then
		return creature
	end
end
local function current(creature)
	if GraveDanger ~= activeLibrary then
		return
	end
	local world = sessions[owningWorldId(creature)]
	if not world then
		return
	end
	for _, state in pairs(world) do
		if state.members[creature:getId()] and creature:getStorageValue(sessionStorage) == state.token then
			return state
		end
	end
end
local function spawn(state, name, position, role, strictPlacement)
	local creature = Game.createMonster(name, position, not strictPlacement, not strictPlacement)
	if not creature then
		return
	end
	local id = creature:getId()
	state.members[id] = role or name:lower()
	creature:setStorageValue(sessionStorage, state.token)
	creature:registerEvent("GraveDangerHealth")
	creature:registerEvent("GraveDangerThink")
	creature:registerEvent("GraveDangerDeath")
	if role then
		state[role] = id
	end
	return creature
end
local function clearRole(state, role)
	for id, memberRole in pairs(state.members) do
		if memberRole == role then
			state.members[id] = nil
			local creature = resolve(state, id)
			if creature then
				creature:remove()
			end
		end
	end
end
local function damage(primary, primaryType, secondary, secondaryType)
	return (primaryType ~= COMBAT_HEALING and math.abs(primary) or 0) + (secondaryType ~= COMBAT_HEALING and math.abs(secondary) or 0)
end
local function createArmor()
	local pos = Position(33398, 32640, 6)
	local tile = Tile(pos)
	if tile and not tile:getItemById(31482) then
		local item = Game.createItem(31482, 1, pos)
		if item then
			item:setActionId(40003)
		end
	end
end
local function blocked(primaryType, secondaryType)
	return 0, primaryType, 0, secondaryType
end
local function returnNargolAfterMassTimeout(worldId, token, massId, x, y, z)
	if GraveDanger ~= activeLibrary or owningWorldId() ~= worldId then
		return
	end
	local state = sessions[worldId] and sessions[worldId]["king zelos"]
	if not state or state.token ~= token or state.mass ~= massId then
		return
	end

	local mass = Monster(massId)
	if not mass or owningWorldId(mass) ~= worldId or mass:getHealth() <= 0 or mass:getStorageValue(sessionStorage) ~= token then
		return
	end

	local returned = spawn(state, "Nargol The Impaler", Position(x, y, z))
	if not returned then
		addEvent(returnNargolAfterMassTimeout, 1000, worldId, token, massId, x, y, z)
		return
	end
	state.members[massId] = nil
	state.mass = nil
	mass:remove()
end
local function replenishZelosSoldiers(state)
	if not resolve(state, state.boss) then
		return
	end
	local count = 0
	for id in pairs(state.zelosSoldiers) do
		if resolve(state, id) then
			count = count + 1
		else
			state.zelosSoldiers[id] = nil
		end
	end
	for _ = count + 1, 3 do
		for attempt = 1, 32 do
			local position = Position(math.random(33437, 33449), math.random(31533, 31547), 13)
			local tile = Tile(position)
			if tile and tile:isWalkable(true, true, true, true, true) then
				local soldier = spawn(state, "Risen Soldier", position, nil, true)
				if soldier then
					state.zelosSoldiers[soldier:getId()] = true
					break
				end
			end
		end
	end
end
local function replenishRedKnightSupports(state)
	local redKnight = resolve(state, state.redKnight)
	if not redKnight then
		return
	end
	for _, slot in ipairs(state.redKnightSlots) do
		if slot.id and not resolve(state, slot.id) then
			state.redKnightSupports[slot.id] = nil
			slot.id = nil
			slot.readyAt = state.elapsed + redKnightRespawnDelay
		end
		if not slot.id and state.elapsed >= slot.readyAt then
			for attempt = 1, 32 do
				local position = attempt == 1 and slot.position or Position(math.random(33415, 33431), math.random(31553, 31571), 13)
				local tile = Tile(position)
				if tile and tile:isWalkable(true, true, true, true, true) then
					local support = spawn(state, slot.name, position, nil, true)
					if support then
						slot.id = support:getId()
						state.redKnightSupports[slot.id] = slot.name
						break
					end
				end
			end
			if not slot.id then
				slot.readyAt = state.elapsed + 1000
			end
		end
	end
end
function GraveDanger.checkEntry(name, player)
	if type(name) ~= "string" then
		return false
	end
	local room = rooms[name:lower()]
	if not room or not room.timer then
		return false
	end
	local entry = Storage.Quest.U12_20.GraveDanger.Bosses[room.timer]
	if not entry or not entry.Timer then
		return false
	end
	local deadline = math.max(player:getStorageValue(entry.Timer), player:getBossCooldown(name))
	if name:lower() == "sir nictros" then
		deadline = math.max(deadline, player:getBossCooldown("Sir Baeloc"))
	end
	if deadline > os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. Game.getTimeInWords(deadline - os.time()) .. " to face " .. name .. " again!")
		return false
	end
	return true
end
local function ritualTick(worldId, token)
	if GraveDanger ~= activeLibrary or owningWorldId() ~= worldId then
		return
	end
	local state = sessions[worldId] and sessions[worldId]["king zelos"]
	if not state or state.token ~= token or state.finished then
		return
	end
	local boss = resolve(state, state.boss)
	if not boss then
		return
	end
	state.clockTicks = (state.clockTicks or 0) + 1
	if state.clockTicks > 24 * 60 then
		return
	end
	GraveDanger.think(boss, 1000, true)
	addEvent(ritualTick, 1000, worldId, token)
end

function GraveDanger.start(name, position)
	if type(name) ~= "string" or not rooms[name:lower()] then
		return false
	end
	name = name:lower()
	local world = owningWorldId()
	sessions[world] = sessions[world] or {}
	local previous = sessions[world][name]
	if previous then
		for id in pairs(previous.members) do
			local member = resolve(previous, id)
			if member then
				member:remove()
			end
		end
	end
	sequence = sequence + 1
	local state = { world = world, token = sequence, name = name, room = rooms[name], members = {}, elapsed = 0, phase = 0, accumulated = 0 }
	sessions[world][name] = state
	local boss = spawn(state, name, position, "boss")
	if not boss then
		sessions[world][name] = nil
		return false
	end
	if name == "count vlarkorth" then
		state.remaining = {}
		for i = 1, 5 do
			spawn(state, "Soulless Minion", Position(33451 + i, 31435, 13))
		end
	elseif name == "earl osam" then
		state.osamReadyAt = osamFirstPhaseDelay
	elseif name == "sir nictros" then
		local brother = spawn(state, "Sir Baeloc", Position(33422, 31428, 13), "brother")
		if not brother then
			boss:remove()
			sessions[world][name] = nil
			return false
		end
		boss:setMoveLocked(true)
		brother:setMoveLocked(true)
	elseif name == "king zelos" then
		local tile = Tile(Position(33443, 31539, 13))
		local exhaustedVortex = tile and tile:getItemById(32416)
		if exhaustedVortex then
			exhaustedVortex:transform(32415)
		end
		state.started = os.time()
		state.zelosSoldiers = {}
		replenishZelosSoldiers(state)
		local guards = {
			{ "Rewar The Bloody", 33463, 31562 },
			{ "The Red Knight", 33423, 31562 },
			{ "Magnor Mournbringer", 33463, 31529 },
			{ "Nargol The Impaler", 33423, 31529 },
		}
		for _, guard in ipairs(guards) do
			local guardBoss = spawn(state, guard[1], Position(guard[2], guard[3], 13))
			if not guardBoss then
				for id in pairs(state.members) do
					local member = resolve(state, id)
					if member then
						member:remove()
					end
				end
				sessions[world][name] = nil
				return false
			end
			if guard[1] == "The Red Knight" then
				state.redKnight = guardBoss:getId()
			end
			if guard[1] == "Rewar The Bloody" then
				state.rewar = guardBoss:getId()
			end
		end
		-- Each mini-boss room starts with its intended support creatures.
		spawn(state, "Risen Soldier", Position(33459, 31562, 13))
		spawn(state, "Risen Soldier", Position(33467, 31562, 13))
		state.redKnightSupports = {}
		state.redKnightSlots = {}
		for _, spec in ipairs(redKnightSupportSpawns) do
			state.redKnightSlots[#state.redKnightSlots + 1] = { name = spec.name, position = spec.position, readyAt = 0 }
		end
		replenishRedKnightSupports(state)
		state.fetters = {}
		for _, position in ipairs(rewarFetterPositions) do
			local fetter = spawn(state, "Fetter", position)
			if fetter then
				state.fetters[fetter:getId()] = true
			end
		end
	elseif name == "scarlett etzel" then
		createArmor()
	end
	if name == "king zelos" then
		addEvent(ritualTick, 1000, world, state.token)
	end
	return true
end

function GraveDanger.scarlettArmor(player, item)
	local state = sessions[owningWorldId(player)] and sessions[owningWorldId(player)]["scarlett etzel"]
	local boss = state and resolve(state, state.boss)
	if not boss or state.armorAt then
		return false
	end
	if not item:remove(1) then
		return false
	end
	state.vulnerableUntil = state.elapsed + 8000
	state.armorAt = state.elapsed + 30000
	boss:setMoveLocked(true)
	boss:say("Galthen... is that you?", TALKTYPE_MONSTER_SAY)
	return true
end
local function scarlettMirrors(boss)
	local pos = boss:getPosition()
	for x = 33390, 33398, 4 do
		for y = 32642, 32650, 4 do
			if pos.x >= x and pos.x <= x + 4 and pos.y >= y and pos.y <= y + 4 then
				local a, b, c, d = Tile(Position(x, y, 6)), Tile(Position(x + 4, y, 6)), Tile(Position(x, y + 4, 6)), Tile(Position(x + 4, y + 4, 6))
				if a and b and c and d and a:getItemById(31474) and b:getItemById(31475) and c:getItemById(31477) and d:getItemById(31476) then
					return true
				end
			end
		end
	end
	return false
end

-- Count: one dark counterpart per participant, and one matching remains per counterpart.
local darkVocations = { [1] = "Dark Sorcerer", [2] = "Dark Druid", [3] = "Dark Paladin", [4] = "Dark Knight", [9] = "Dark Merudri" }
local function reconcileCount(state)
	local present = {}
	for _, player in ipairs(Game.getSpectators(state.room.center, false, true, 8, 8, 9, 9)) do
		if player:getHealth() > 0 then
			present[player:getVocation():getBase():getId()] = true
		end
	end
	for vocation in pairs(state.remaining) do
		if not present[vocation] then
			state.remaining[vocation] = nil
		end
	end
	state.shield = next(state.remaining) ~= nil
end

local function countPhase(state, boss)
	if (state.countPhases or 0) >= 2 then
		return
	end
	state.countPhases = (state.countPhases or 0) + 1
	state.remaining = {}
	for _, player in ipairs(Game.getSpectators(state.room.center, false, true, 8, 8, 9, 9)) do
		local vocation = player:getVocation():getBase():getId()
		local name = darkVocations[vocation]
		if name and spawn(state, name, boss:getPosition()) then
			state.remaining[vocation] = (state.remaining[vocation] or 0) + 1
		end
	end
	state.shield = next(state.remaining) ~= nil
	boss:say("Face your own darkness!", TALKTYPE_MONSTER_SAY)
end
function GraveDanger.useRemains(player, item, target, vocation)
	if not target or not target:isMonster() or target:getName():lower() ~= "count vlarkorth" or owningWorldId(player) ~= owningWorldId(target) then
		return false
	end
	local state = current(target)
	vocation = item:getCustomAttribute("grave-danger-vocation") or vocation
	if not state or not state.shield or item:getCustomAttribute("grave-danger-token") ~= state.token or item:getCustomAttribute("grave-danger-world") ~= state.world or player:getVocation():getBase():getId() ~= vocation or (state.remaining[vocation] or 0) <= 0 then
		return false
	end
	if not item:remove(1) then
		return false
	end
	state.remaining[vocation] = state.remaining[vocation] - 1
	if state.remaining[vocation] == 0 then
		state.remaining[vocation] = nil
	end
	state.shield = next(state.remaining) ~= nil
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	return true
end

local spherePositions = { Position(33480, 31438, 13), Position(33488, 31430, 13), Position(33496, 31438, 13), Position(33488, 31446, 13) }
local function osamPhase(state, boss)
	state.osamPhases = (state.osamPhases or 0) + 1
	state.osamReadyAt = state.elapsed + osamPhaseInterval
	state.shield = true
	state.sphereClock = 0
	boss:teleportTo(state.room.center)
	boss:setMoveLocked(true)
	boss:setName("Channeling Earl Osam")
	for _, pos in ipairs(spherePositions) do
		spawn(state, "Magical Sphere", pos)
	end
end
local function azaramPhase(state, boss)
	-- The soul/splinter ritual is deliberately limited to two rounds.
	if (state.azaramPhases or 0) >= 2 then
		return
	end
	state.azaramPhases = (state.azaramPhases or 0) + 1
	local soul = spawn(state, "Azaram's Soul", state.room.center, "soul")
	if not soul then
		return
	end
	-- Healing persists across transformations; a full soul needs the fragment ritual.
	soul:setHealth(state.soulHealth or 1)
	state.soulStartedFull = soul:getHealth() >= soul:getMaxHealth()
	state.shield = true
	state.cleansed = 0
	state.azaramHealth = boss:getHealth()
	clearRole(state, "condensed sin")
	clearRole(state, "condensed sins")
	state.members[boss:getId()] = nil
	boss:remove()
	for _, pos in ipairs({ Position(33422, 31470, 13), Position(33427, 31470, 13), Position(33422, 31476, 13), Position(33427, 31476, 13) }) do
		spawn(state, "Tainted Soul Splinter", pos)
	end
end
local function finishAzaramSoul(state, soul)
	if not state.shield or state.soul ~= soul:getId() then
		return
	end
	local boss = spawn(state, "Lord Azaram", state.room.center, "boss")
	if not boss then
		return
	end -- Keep the soul available for a later retry.
	state.soulHealth = soul:getHealth()
	state.members[soul:getId()] = nil
	soul:remove()
	clearRole(state, "tainted soul splinter")
	for _, spectator in ipairs(monsters(state)) do
		if spectator:isMonster() and spectator:getName():lower() == "tainted soul splinter" then
			spectator:remove()
		end
	end
	state.shield = false
	boss:setHealth(math.max(1, state.azaramHealth or boss:getHealth()))
	boss:setMoveLocked(false)
end
function GraveDanger.cleanse(soul, item)
	local state = current(soul)
	if not state or state.soul ~= soul:getId() or not state.shield or item:getId() ~= 31160 or item:getCustomAttribute("grave-danger-token") ~= state.token or item:getCustomAttribute("grave-danger-world") ~= state.world or item:getCustomAttribute("grave-danger-phase") ~= state.azaramPhases then
		return false
	end
	if not item:remove() then
		return false
	end
	state.cleansed = state.cleansed + 1
	-- Three fragments complete the ritual without requiring a healing vocation.
	soul:addHealth(math.ceil(soul:getMaxHealth() / 3))
	if state.cleansed >= 3 then
		finishAzaramSoul(state, soul)
	end
	return true
end

function GraveDanger.health(creature, attacker, primary, primaryType, secondary, secondaryType)
	local state = current(creature)
	if state and state.name == "count vlarkorth" and state.shield then
		reconcileCount(state)
	end
	if not state then
		return primary, primaryType, secondary, secondaryType
	end
	if state.members[creature:getId()] == "soul" then
		-- The soul can be healed by runes and spells such as exura gran mas res.
		-- It is otherwise immune until a completed heal returns Lord Azaram.
		if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
			return primary, primaryType, secondary, secondaryType
		end
		return blocked(primaryType, secondaryType)
	end
	if state.members[creature:getId()] == "shard of magnor" and not state.shardUpdating then
		state.shardUpdating = true
		local delta = math.abs(primary) + math.abs(secondary)
		state.shardHealth = math.max(0, math.min(creature:getMaxHealth(), state.shardHealth + (primaryType == COMBAT_HEALING and delta or -delta)))
		for id, role in pairs(state.members) do
			local shard = role == "shard of magnor" and id ~= creature:getId() and resolve(state, id)
			if shard then
				if state.shardHealth == 0 then
					shard:addHealth(-shard:getHealth())
				else
					shard:setHealth(state.shardHealth)
				end
			end
		end
		state.shardUpdating = false
	end
	if primaryType == COMBAT_HEALING then
		return primary, primaryType, secondary, secondaryType
	end
	local id, name = creature:getId(), creature:getName():lower()
	local total = damage(primary, primaryType, secondary, secondaryType)
	if state.name == "scarlett etzel" then
		if not state.vulnerableUntil or state.elapsed >= state.vulnerableUntil then
			creature:addHealth(5000)
			return blocked(primaryType, secondaryType)
		end
		if scarlettMirrors(creature) then
			state.vulnerableUntil = nil
			creature:setMoveLocked(false)
			for _, player in ipairs(Game.getSpectators(creature:getPosition(), false, true, 2, 2, 2, 2)) do
				doTargetCombatHealth(creature, player, COMBAT_EARTHDAMAGE, -7500, -7500, CONST_ME_GROUNDSHAKER)
			end
			return 7500, primaryType, 0, secondaryType
		end
	elseif state.name == "sir nictros" then
		local active = state.phase == 3 or (state.phase == 1 and id == state.boss) or (state.phase == 2 and id == state.brother)
		if not active then
			return blocked(primaryType, secondaryType)
		end
		if state.phase < 3 and creature:getHealth() - total <= creature:getMaxHealth() * 0.60 then
			local allowed = math.max(0, creature:getHealth() - math.ceil(creature:getMaxHealth() * 0.60))
			local ratio = total > 0 and allowed / total or 0
			primary, secondary = math.floor(math.abs(primary) * ratio), math.floor(math.abs(secondary) * ratio)
			state.phase = state.phase + 1
			local nictros, baeloc = resolve(state, state.boss), resolve(state, state.brother)
			if nictros and baeloc then
				nictros:teleportTo(state.phase == 2 and Position(33427, 31428, 13) or Position(33424, 31435, 13))
				nictros:setMoveLocked(state.phase == 2)
				baeloc:teleportTo(Position(33426, 31435, 13))
				baeloc:setMoveLocked(false)
			end
		elseif state.phase == 3 then
			local brother = resolve(state, id == state.boss and state.brother or state.boss)
			if brother and creature:getHealth() / creature:getMaxHealth() < 0.55 and brother:getHealth() / brother:getMaxHealth() - creature:getHealth() / creature:getMaxHealth() > 0.05 then
				creature:addHealth(18000)
			end
		end
	elseif id == state.boss and state.name == "king zelos" then
		if not state.ritualDuration then
			return blocked(primaryType, secondaryType)
		end
		-- Strength is fixed by ritual duration, not by how long the final fight takes.
		-- The linear interpolation is calibration; the official curve is unpublished.
		local multiplier = math.max(0, math.min(1, 1 - state.ritualDuration / zelosResistanceHorizon))
		primary, secondary = math.floor(math.abs(primary) * multiplier), math.floor(math.abs(secondary) * multiplier)
	elseif name == "rewar the bloody" or name == "rewar the bloody inv" then
		local guarded = false
		if state.fetters then
			for fetterId in pairs(state.fetters) do
				local fetter = resolve(state, fetterId)
				if fetter then
					guarded = true
					break
				end
			end
		end
		if guarded then
			return blocked(primaryType, secondaryType)
		end
	elseif id == state.boss then
		if state.shield then
			return blocked(primaryType, secondaryType)
		end
		if state.name == "earl osam" then
			return primary, primaryType, secondary, secondaryType
		end
		state.accumulated = state.accumulated + total
		local threshold = creature:getMaxHealth() * (state.name == "lord azaram" and 0.10 or 0.15)
		if state.accumulated >= threshold and state.name ~= "earl osam" and (state.name ~= "lord azaram" or (state.azaramPhases or 0) < 2) then
			state.accumulated = 0
			if state.name == "count vlarkorth" then
				countPhase(state, creature)
			elseif state.name == "lord azaram" then
				azaramPhase(state, creature)
			end
			-- The triggering strike is absorbed so a lethal hit cannot skip the phase.
			if state.shield then
				return blocked(primaryType, secondaryType)
			end
		end
	end
	return primary, primaryType, secondary, secondaryType
end

local function ritualComplete(state, deadId)
	for id, role in pairs(state.members) do
		if id ~= deadId and role ~= "boss" and (role == "rewar the bloody" or role == "the red knight" or role == "nargol the impaler" or role == "magnor mournbringer" or role == "regenerating mass" or role == "shard of magnor") and resolve(state, id) then
			return
		end
	end
	state.ritualDuration = state.ritualDuration or math.max(0, os.time() - state.started)
end
function GraveDanger.brotherAttackers(creature)
	local state = sessions[owningWorldId(creature)] and sessions[owningWorldId(creature)]["sir nictros"]
	if not state or (creature:getId() ~= state.boss and creature:getId() ~= state.brother) then
		return creature:getDamageMap()
	end
	state.attackers = state.attackers or {}
	for id in pairs(creature:getDamageMap()) do
		state.attackers[id] = true
	end
	return state.attackers
end

local function finishEncounter(state, lever)
	if lever.finishEncounter then
		return lever:finishEncounter(state.world)
	end
	-- Match upstream BossLeverOnDeath without requiring personal-server helpers.
	if lever.timeoutEvent then
		stopEvent(lever.timeoutEvent)
		lever.timeoutEvent = nil
	end
	if (lever.timeAfterKill or 0) <= 0 then
		return
	end
	local zone = lever:getZone()
	zone:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. state.name .. " has been defeated. You have " .. lever.timeAfterKill .. " seconds to leave the room.")
	lever.timeoutEvent = addEvent(function(worldId, token, name)
		local active = sessions[worldId] and sessions[worldId][name]
		if GraveDanger ~= activeLibrary or owningWorldId() ~= worldId or not active or active.token ~= token then
			return
		end
		local currentLever = BossLever[name]
		if not currentLever then
			return
		end
		local currentZone = currentLever:getZone()
		currentZone:refresh()
		currentZone:removePlayers()
	end, lever.timeAfterKill * 1000, state.world, state.token, state.name)
end

function GraveDanger.death(creature, corpse)
	local state = current(creature)
	if not state then
		return true
	end
	local id, role = creature:getId(), state.members[creature:getId()]
	if state.name == "sir nictros" then
		GraveDanger.brotherAttackers(creature)
	end
	local redKnightSupport = state.redKnightSupports and state.redKnightSupports[id]
	local darkRole = { ["dark sorcerer"] = 1, ["dark druid"] = 2, ["dark paladin"] = 3, ["dark knight"] = 4, ["dark merudri"] = 9 }
	if darkRole[role] and corpse then
		corpse:setCustomAttribute("grave-danger-token", state.token)
		corpse:setCustomAttribute("grave-danger-world", state.world)
		corpse:setCustomAttribute("grave-danger-vocation", darkRole[role])
	elseif role == "tainted soul splinter" then
		local fragment = corpse or Game.createItem(31160, 1, creature:getPosition())
		if fragment then
			fragment:transform(31160)
			fragment:setCustomAttribute("grave-danger-token", state.token)
			fragment:setCustomAttribute("grave-danger-world", state.world)
			fragment:setCustomAttribute("grave-danger-phase", state.azaramPhases)
			fragment:decay()
		end
	elseif role == "nargol the impaler" then
		local mass = spawn(state, "Regenerating Mass", Position(33423, 31529, 13))
		if mass then
			local massId, position = mass:getId(), mass:getPosition()
			state.mass = massId
			addEvent(returnNargolAfterMassTimeout, 30000, state.world, state.token, massId, position.x, position.y, position.z)
		end
	elseif role == "soulless minion" then
		local boss = resolve(state, state.boss)
		if boss and creature:getPosition():getDistance(boss:getPosition()) <= 3 then
			boss:addHealth(1500)
		end
	elseif role == "magnor mournbringer" then
		for i = 1, 4 do
			local shard = spawn(state, "Shard of Magnor", creature:getPosition())
			if shard then
				state.shardHealth = shard:getMaxHealth()
			end
		end
	elseif role == "vampiric blood" or role == "shard of magnor" then
		local blood = role == "vampiric blood"
		local pos = creature:getPosition()
		for _, target in ipairs(Game.getSpectators(pos, false, false, blood and 1 or 2, blood and 1 or 2, blood and 1 or 2, blood and 1 or 2)) do
			if target:isPlayer() or (blood and target:isMonster() and target:getName():lower() == "the red knight") then
				doTargetCombatHealth(0, target, blood and COMBAT_DROWNDAMAGE or COMBAT_LIFEDRAIN, blood and -20000 or -2000, blood and -25000 or -2500, CONST_ME_MAGIC_RED)
			end
		end
	end
	state.members[id] = nil
	if state.fetters then
		state.fetters[id] = nil
	end
	if role == "fetter" and resolve(state, state.rewar) then
		local guarded = false
		for fetterId in pairs(state.fetters) do
			if resolve(state, fetterId) then
				guarded = true
				break
			end
		end
		if not guarded then
			resolve(state, state.rewar):teleportTo(Position(33463, 31562, 13))
			state.rewarFetterAt = state.elapsed + rewarVulnerabilityWindow
		end
	end
	if redKnightSupport then
		state.redKnightSupports[id] = nil
		for _, slot in ipairs(state.redKnightSlots) do
			if slot.id == id then
				slot.id = nil
				slot.readyAt = state.elapsed + redKnightRespawnDelay
				break
			end
		end
	end
	if state.name == "king zelos" then
		ritualComplete(state, id)
	end
	local finished = id == state.boss
	if state.name == "sir nictros" then
		finished = (id == state.boss or id == state.brother) and not GraveDanger.brothersAlive(creature)
	end
	if finished then
		state.finished = true
		local lever = BossLever[state.name]
		if lever then
			finishEncounter(state, lever)
		end
	end
	return true
end

function GraveDanger.disappear(creature)
	local state = current(creature)
	if state then
		local id = creature:getId()
		if id == state.boss then
			state.finished = true
		end
		state.members[id] = nil
		if state.fetters then
			state.fetters[id] = nil
		end
	end
end

function GraveDanger.canEnterZelos(player)
	local state = sessions[owningWorldId(player)] and sessions[owningWorldId(player)]["king zelos"]
	return state and state.ritualDuration ~= nil and resolve(state, state.boss) ~= nil
end
function GraveDanger.unleashHex(player)
	local state = sessions[owningWorldId(player)] and sessions[owningWorldId(player)]["king zelos"]
	if not state or not resolve(state, state.boss) then
		return false
	end
	return spawn(state, "Unleashed Hex", player:getPosition()) ~= nil
end

local vortexPosition = Position(33443, 31539, 13)
local function restoreHexVortex(worldId, token, generation)
	local state = sessions[worldId] and sessions[worldId]["king zelos"]
	if owningWorldId() ~= worldId or not state or state.token ~= token or state.vortexGeneration ~= generation then
		return
	end
	local tile = Tile(vortexPosition)
	local vortex = tile and tile:getItemById(32416)
	if vortex then
		vortex:transform(32415)
	end
	state.vortexExhausted = false
end

function GraveDanger.cleanseHex(player)
	if owningWorldId() ~= owningWorldId(player) then
		return false
	end
	local state = sessions[owningWorldId(player)] and sessions[owningWorldId(player)]["king zelos"]
	local boss = state and resolve(state, state.boss)
	if not boss or state.vortexExhausted or not player:hasCondition(CONDITION_GREATERHEX) then
		return false
	end
	local tile = Tile(vortexPosition)
	local vortex = tile and tile:getItemById(32415)
	if not vortex or not GraveDanger.unleashHex(player) then
		return false
	end
	-- Remove only the active condition; preserve current HP without healing or damage.
	player:removeCondition(CONDITION_GREATERHEX, CONDITIONID_COMBAT, 0, true)
	boss:addHealth(math.random(10000, 15000))
	vortex:transform(32416)
	state.vortexExhausted = true
	state.vortexGeneration = (state.vortexGeneration or 0) + 1
	addEvent(restoreHexVortex, 60000, state.world, state.token, state.vortexGeneration)
	return true
end
function GraveDanger.brothersAlive(creature)
	local state = sessions[owningWorldId(creature)] and sessions[owningWorldId(creature)]["sir nictros"]
	if not state then
		return false
	end
	local other = creature:getId() == state.boss and state.brother or state.boss
	return resolve(state, other) ~= nil
end

function GraveDanger.think(creature, interval, ritualClock)
	local state = current(creature)
	if not state then
		return true
	end
	if state.name == "king zelos" and not ritualClock then
		return true
	end
	if state.name == "count vlarkorth" and state.shield then
		reconcileCount(state)
	end
	if state.members[creature:getId()] == "soul" then
		if (state.cleansed or 0) >= 3 or (not state.soulStartedFull and creature:getHealth() >= creature:getMaxHealth()) then
			finishAzaramSoul(state, creature)
		end
		return true
	end
	if creature:getId() ~= state.boss then
		return true
	end
	for id in pairs(state.members) do
		if id ~= state.boss and not resolve(state, id) then
			state.members[id] = nil
			if state.fetters then
				state.fetters[id] = nil
			end
		end
	end
	state.elapsed = state.elapsed + interval
	if state.name == "earl osam" and not state.shield and state.elapsed >= state.osamReadyAt then
		osamPhase(state, creature)
		return true -- The new spheres get their full movement interval.
	end
	if state.name == "king zelos" then
		replenishRedKnightSupports(state)
		state.supportClock = (state.supportClock or 0) + interval
		if state.supportClock >= redKnightSupportInterval then
			state.supportClock = 0
			replenishZelosSoldiers(state)
		end
	end
	if state.name == "lord azaram" then
		local pos, room = creature:getPosition(), state.room
		if pos.z ~= room.center.z or pos.x < room.center.x - room.x or pos.x > room.center.x + room.x or pos.y < room.center.y - room.y or pos.y > room.center.y + room.y then
			creature:teleportTo(room.center)
			creature:setMoveLocked(state.shield == true)
		end
	end
	if state.name == "scarlett etzel" then
		if state.vulnerableUntil and state.elapsed >= state.vulnerableUntil then
			state.vulnerableUntil = nil
			creature:setMoveLocked(false)
		end
		if state.armorAt and state.elapsed >= state.armorAt then
			createArmor()
			state.armorAt = nil
		end
	elseif state.name == "sir nictros" and state.phase == 0 and state.elapsed >= 12000 then
		state.phase = 1
		creature:teleportTo(Position(33426, 31437, 13))
		creature:setMoveLocked(false)
	elseif state.name == "earl osam" and state.shield then
		state.sphereClock = state.sphereClock + interval
		if state.sphereClock >= 4000 then
			state.sphereClock = 0
			local alive = 0
			for id, role in pairs(state.members) do
				local sphere = role == "magical sphere" and resolve(state, id)
				if sphere then
					local pos, center = sphere:getPosition(), state.room.center
					local nextPos = Position(pos.x + (center.x > pos.x and 1 or center.x < pos.x and -1 or 0), pos.y + (center.y > pos.y and 1 or center.y < pos.y and -1 or 0), pos.z)
					if nextPos:getDistance(center) == 0 then
						state.members[id] = nil
						sphere:remove()
						creature:addHealth(80000)
					else
						sphere:teleportTo(nextPos)
						alive = alive + 1
					end
				end
			end
			if alive == 0 then
				state.shield = false
				creature:setMoveLocked(false)
				creature:setName("Earl Osam")
				for _, player in ipairs(Game.getSpectators(state.room.center, false, true, 1, 1, 1, 1)) do
					local pos = player:getPosition()
					if (pos.x == state.room.center.x or pos.y == state.room.center.y) and pos:getDistance(state.room.center) == 1 then
						player:teleportTo(Position(pos.x + (pos.x - state.room.center.x) * 2, pos.y + (pos.y - state.room.center.y) * 2, pos.z))
					end
				end
			end
		end
	end
	if state.name == "king zelos" and resolve(state, state.rewar) and state.rewarFetterAt and state.elapsed >= state.rewarFetterAt then
		state.rewarFetterAt = nil
		state.fetters = {}
		for _, position in ipairs(rewarFetterPositions) do
			local fetter = spawn(state, "Fetter", position)
			if fetter then
				state.fetters[fetter:getId()] = true
			end
		end
		if next(state.fetters) == nil then
			state.rewarFetterAt = state.elapsed + rewarVulnerabilityWindow
		end
	end
	-- Bounded periodic summons and healing, driven by the owning live boss.
	state.tick = (state.tick or 0) + interval
	if state.tick >= 5000 then
		state.tick = 0
		if state.name == "count vlarkorth" then
			for _, minion in ipairs(monsters(state)) do
				if minion:isMonster() and minion:getName():lower() == "soulless minion" then
					for _, target in ipairs(Game.getSpectators(minion:getPosition(), false, false, 3, 3, 3, 3)) do
						if target:isMonster() and state.members[target:getId()] and target:getId() ~= minion:getId() then
							target:addHealth(500)
						end
					end
				end
			end
		elseif state.name == "earl osam" or state.name == "lord azaram" then
			local name = state.name == "earl osam" and "Frozen Soul" or "Condensed Sin"
			local limit = state.name == "lord azaram" and 2 or 4
			local count = 0
			for _, member in ipairs(monsters(state)) do
				if member:isMonster() and member:getName():lower() == name:lower() then
					count = count + 1
				end
			end
			if count < limit then
				spawn(state, name, creature:getPosition())
			end
		end
	end
	return true
end
