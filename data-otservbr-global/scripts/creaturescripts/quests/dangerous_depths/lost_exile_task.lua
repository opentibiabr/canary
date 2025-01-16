local fromPos = Position(33768, 32227, 14)
local toPos = Position(33781, 32249, 14)

local lostExileKill = CreatureEvent("LastExileDeath")
function lostExileKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) ~= 1 then
			return
		end
		if not creature:getPosition():isInRange(fromPos, toPos) then
			return
		end
		local storage = player:getStorageValue(Storage.DangerousDepths.Dwarves.LostExiles)
		if storage < 20 then
			if storage < 0 then
				player:setStorageValue(Storage.DangerousDepths.Dwarves.LostExiles, 1)
			end
			player:setStorageValue(Storage.DangerousDepths.Dwarves.LostExiles, storage + 1)
		end
	end)
	return true
end

lostExileKill:register()

local wormKill = CreatureEvent("WarzoneWormDeath")
function wormKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local storage = mostDamageKiller:getStorageValue(Storage.DangerousDepths.Dwarves.Organisms)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) ~= 1 then
			return
		end
		if storage < 50 then
			if storage < 0 then
				player:setStorageValue(Storage.DangerousDepths.Dwarves.Organisms, 1)
			end
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Organisms, storage + 1)
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
