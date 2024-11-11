local fromPos = Position(33768, 32227, 14)
local toPos = Position(33851, 32352, 14)
local radius = 10

local lostExileKill = CreatureEvent("LastExileDeath")

function lostExileKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local function isMakeshiftHomeNearby(creature)
		local creaturePosition = creature:getPosition()
		local spectators = Game.getSpectators(creaturePosition, false, false, radius, radius, radius, radius) -- Busca criaturas em torno da posição da morte

		for _, spectator in ipairs(spectators) do
			if spectator:isMonster() and spectator:getName():lower() == "makeshift home" then
				return true
			end
		end
		return false
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) ~= 1 then
			return
		end

		if not creature:getPosition():isInRange(fromPos, toPos) then
			return
		end

		if isMakeshiftHomeNearby(creature) then
			return
		end

		local storage = player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles)
		if storage < 20 then
			if storage < 0 then
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles, 1)
			end
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles, storage + 1)
		end
	end)

	return true
end

lostExileKill:register()

local wormKill = CreatureEvent("WarzoneWormDeath")

function wormKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local storage = mostDamageKiller:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) ~= 1 then
			return
		end
		if storage < 50 then
			if storage < 0 then
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms, 1)
			end
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms, storage + 1)
		end
	end)

	return true
end

wormKill:register()

local makeshiftKill = CreatureEvent("MakeshiftHomeDeath")

function makeshiftKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local woodenTrash = Game.createItem(398, 1, creature:getPosition())
	woodenTrash:setActionId(57233)
	return true
end

makeshiftKill:register()
