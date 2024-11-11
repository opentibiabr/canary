---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

--[[
local monsterSpawnHuntKill = EventCallback("monsterSpawnHuntKill")

monsterSpawnHuntKill.monsterOnSpawn = function(monster, position)
    monster:registerEvent("monsterHuntKill")
	return true
end

monsterSpawnHuntKill:register()
]]--
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local monsterHuntKill = CreatureEvent("monsterHuntKill")

function monsterHuntKill.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageUnjustified)

	if creature and creature:isMonster() then
		
		if not Game.getStorageValue(MONSTER_HUNT.storages.started) == 1 or (Game.getStorageValue(MONSTER_HUNT.storages.monster) == -1) or (Game.getStorageValue(MONSTER_HUNT.storages.monster) == 0) then
			return true
		end
		
		if Game.getStorageValue(MONSTER_HUNT.storages.monster) == nil then
			return true
		end
		
		if killer:getStorageValue(MONSTER_HUNT.storages.killer) == -1 then
			killer:setStorageValue(MONSTER_HUNT.storages.killer, 0)
		end
		
		
			if not killer:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
				return true
			end
		
		--Spdlog.warn("[MonsterHunt] - Debug: ".. (MONSTER_HUNT.list[Game.getStorageValue(MONSTER_HUNT.storages.monster)]):lower())
		if creature:isMonster() and creature:getName():lower() == (MONSTER_HUNT.list[Game.getStorageValue(MONSTER_HUNT.storages.monster)]):lower() then
			killer:setStorageValue(MONSTER_HUNT.storages.killer, killer:getStorageValue(MONSTER_HUNT.storages.killer) + 1)
			killer:sendTextMessage(MESSAGE_EVENT_ADVANCE,MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.kill:format(killer:getStorageValue(MONSTER_HUNT.storages.killer), creature:getName()))
			table.insert(MONSTER_HUNT.players, {killer:getId(), killer:getStorageValue(MONSTER_HUNT.storages.killer)})		
		end

	end	
	
	return true
end
monsterHuntKill:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local monsterHunt = GlobalEvent("monsterHunt")
function monsterHunt.onThink(interval, lastExecution)

--Spdlog.warn("[HUNT EVENT] - Debug: ".. tostring(os.date("%A-%H")))
	if Game.getStorageValue(MONSTER_HUNT.storages.started) == 1 then
	
	return true
	end

	if table.find(MONSTER_HUNT.days, tostring(os.date("%A-%H"))) then
		--if isInArray(MONSTER_HUNT.days[os.date("%A")], hrs) then
			Spdlog.info("[HUNT EVENT] - Started Hunt Event at "..tostring(os.date("%A-%H")))
			Game.setStorageValue(MONSTER_HUNT.storages.started, 1)
			MONSTER_HUNT:initEvent()
	end
return true
end


monsterHunt:interval(60000) --1 minutes
monsterHunt:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------