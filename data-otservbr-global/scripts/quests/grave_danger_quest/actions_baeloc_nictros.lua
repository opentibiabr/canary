local nictrosPosition = Position(33427, 31428, 13)
local baelocPosition = Position(33422, 31428, 13)

local healthStates = {
	nictros85 = false,
	baeloc85 = false,
}

local config = {
	boss = {
		name = "Sir Nictros",
		createFunction = function()
			local nictros = Game.createMonster("Sir Nictros", nictrosPosition, true, true)
			local baeloc = Game.createMonster("Sir Baeloc", baelocPosition, true, true)

			if nictros then
				nictros:registerEvent("BossHealthCheck")
				-- Start with Nictros active
				nictros:setMoveLocked(false)
			end
			if baeloc then
				-- Start with Baeloc locked
				baeloc:setMoveLocked(true)
				baeloc:registerEvent("BossHealthCheck")
			end

			-- Reset health triggers in case this is a retry
			healthStates.nictros85 = false
			healthStates.baeloc85 = false

			return nictros and baeloc
		end,
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33424, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33425, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33426, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33427, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33428, 31413, 13), teleport = Position(33423, 31448, 13) },
	},
	specPos = {
		from = Position(33414, 31426, 13),
		to = Position(33433, 31449, 13),
	},
	onUseExtra = function(player)
		addEvent(function()
			local baeloc = Creature("Sir Baeloc")
			local nictros = Creature("Sir Nictros")

			if baeloc then
				baeloc:say("Ah look my Brother! Challengers! After all this time finally a chance to prove our skills!")
				addEvent(function()
					local nictros = Creature("Sir Nictros")
					if nictros then
						nictros:say("Indeed! It has been a while! As the elder one I request the right of the first battle!")
					end
				end, 6 * 1000)
			end

			addEvent(function()
				local baeloc = Creature("Sir Baeloc")
				local nictros = Creature("Sir Nictros")
				if baeloc then
					baeloc:say("Oh, man! You always get the fun!")
					-- Keep Baeloc locked initially - will be released later
					baeloc:setMoveLocked(true)
				end
				if nictros then
					nictros:teleportTo(Position(33426, 31437, 13))
					-- Make sure Nictros can move and attack
					nictros:setMoveLocked(false)
				end
			end, 12 * 1000)
		end, 4 * 1000)
	end,
	exit = Position(33290, 32474, 9),
}

local lever = BossLever(config)
lever:position(Position(33423, 31413, 13))
lever:register()

-- Health Trigger Logic
local BossHealthCheck = CreatureEvent("BossHealthCheck")

function BossHealthCheck.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	-- Safety check
	if not creature or not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local name = creature:getName()

	-- Calculate health percentage correctly
	local function getHealthPercentage(creature)
		local health = creature:getHealth()
		local maxHealth = creature:getMaxHealth()
		return (health / maxHealth) * 100
	end

	local healthPercent = getHealthPercentage(creature)

	-- Debug logging
	print("[BossHealthCheck] Health check for:", name, "Health:", creature:getHealth(), "/", creature:getMaxHealth(), "=", healthPercent, "%")

	-- NICTROS reaches 85% health
	if name == "Sir Nictros" and not healthStates.nictros85 and healthPercent <= 85 then
		healthStates.nictros85 = true
		print("[BossHealthCheck] Nictros at 85% or below - releasing Baeloc")

		creature:say("I'll step back now. Let's see how you handle my brother!")
		creature:teleportTo(nictrosPosition)
		creature:setMoveLocked(true) -- Lock Nictros until Baeloc hits 85%

		-- Release Baeloc to fight
		local baeloc = Creature("Sir Baeloc")
		if baeloc then
			baeloc:teleportTo(Position(33426, 31435, 13))
			baeloc:setDirection(DIRECTION_SOUTH)
			baeloc:setMoveLocked(false) -- Allow Baeloc to move and attack
			baeloc:say("My turn! Let me show you my skills!")
		end

		-- BAELOC reaches 85% health
	elseif name == "Sir Baeloc" and healthStates.nictros85 and not healthStates.baeloc85 and healthPercent <= 85 then
		healthStates.baeloc85 = true
		print("[BossHealthCheck] Baeloc at 85% - releasing Nictros for joint attack")

		creature:say("Brother! I need your assistance!")

		-- Release Nictros to join the fight
		local nictros = Creature("Sir Nictros")
		if nictros then
			nictros:setMoveLocked(false) -- Allow Nictros to move and attack again
			nictros:teleportTo(Position(33424, 31435, 13)) -- Teleport near Baeloc
			nictros:say("Now we fight together, brother!")
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

BossHealthCheck:register()
