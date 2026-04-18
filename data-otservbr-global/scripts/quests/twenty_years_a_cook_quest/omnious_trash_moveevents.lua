local positions = {
	["33117,31672,7"] = {
		{ toPosition = Position(33327, 31481, 15), storageValue = 10 },
	},
	["32367,31596,7"] = {
		{ toPosition = Position(32299, 31698, 8), storageValue = 8 },
	},
	["32301,31697,8"] = {
		{ toPosition = Position(32368, 31598, 7), storageValue = 8, boss = "Fryclops" },
	},
	["32297,31706,8"] = {
		{ toPosition = Position(32246, 31834, 7), storageValue = 8 },
	},
	["32246,31832,7"] = {
		{ toPosition = Position(32298, 31704, 8), storageValue = 8 },
	},
	["32591,31936,5"] = {
		{ toPosition = Position(32587, 31937, 5), storageValue = 4, boss = "The Rest Of Ratha" },
		{ toPosition = Position(33380, 31440, 15), storageValue = 2 },
	},
	["32974,32110,7"] = {
		{ toPosition = Position(32974, 32087, 8), storageValue = 1 },
	},
	["32973,32089,8"] = {
		{ toPosition = Position(32975, 32112, 7), storageValue = 1 },
	},
}

local function posToStr(pos)
	return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function sortRulesByPriority(rules)
	table.sort(rules, function(a, b)
		return a.storageValue > b.storageValue -- maior prioridade primeiro
	end)
end

for _, rules in pairs(positions) do
	sortRulesByPriority(rules)
end

local omniousTrashCan = MoveEvent()

function omniousTrashCan.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- ✅ Garante que seja número, mesmo que a quest tenha setado como string
	local playerStorage = tonumber(player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine)) or -1
	local currentPos = posToStr(player:getPosition())
	local rules = positions[currentPos]

	if not rules then
		return true
	end

	local hasBossCooldown = false

	for _, data in ipairs(rules) do
		if playerStorage >= data.storageValue then
			-- 🔍 Debug (remova após testar)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Regra ativada: Storage "..data.storageValue..(data.boss and " (Boss: "..data.boss..")" or ""))

			if data.boss then
				local cooldown = player:getBossCooldown(data.boss)
				-- ✅ Verifica se cooldown existe e se ainda está ativo
				if cooldown and cooldown > os.time() then
					hasBossCooldown = true
					break
				end
			end

			-- Teleporta e encerra a função imediatamente
			fromPosition:sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(data.toPosition, true)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end

	-- ❌ Falha: nenhuma regra válida ou cooldown ativo
	player:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		hasBossCooldown and "You need to wait to challenge again." or "You are not ready for this yet"
	)

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:teleportTo(fromPosition, true)
	fromPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

for key, _ in pairs(positions) do
	local x, y, z = key:match("(%d+),(%d+),(%d+)")
	omniousTrashCan:position(Position(tonumber(x), tonumber(y), tonumber(z)))
end

omniousTrashCan:type("stepin")
omniousTrashCan:register()
