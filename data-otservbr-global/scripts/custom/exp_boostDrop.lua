local custom_exp_damage_effect = CreatureEvent("custom_exp_damage_effect")
--[[
local config = {
    ['Rotworm'] = { chance = 50 }, -- 100 means 10%, 1000 means 100%
    ['Demon'] = { chance = 50 },
	['Cyclops'] = { chance = 50 },
	['Dragon'] = { chance = 50 },
	['Carniphila'] = { chance = 50 },
	['Dragon Lord'] = { chance = 50 },
	['Green Djinn'] = { chance = 50 },
	['Hellfire Fighter'] = { chance = 50 },
	['Hero'] = { chance = 50 },
	['Medusa'] = { chance = 50 },
	['Hellspawn'] = { chance = 50 },
	['Minotaur'] = { chance = 50 },
	['Giant Spider'] = { chance = 50 },
	['Mutated Human'] = { chance = 50 },
	['Mummy'] = { chance = 50 },
	['Nightmare'] = { chance = 50 },
	['Orc Leader'] = { chance = 50 },
	['Pirate Buccaneer'] = { chance = 50 },
	['Quara Mantassin'] = { chance = 100 },
	['Serpent Spawn'] = { chance = 100 },
	['Frost Dragon'] = { chance = 100 },
	['Vampire'] = { chance = 100 },
	['Warlock'] = { chance = 100 },
	['Wyrm'] = { chance = 100 },
	['Wyvern'] = { chance = 100 },
	['Young Sea Serpent'] = { chance = 100 },
	['Defiler'] = { chance = 100 },
	['Dwarf'] = { chance = 100 },
	['Destroyer'] = { chance = 100 },
	['Behemoth'] = { chance = 100 },
	['Braindeath'] = { chance = 100 },
	['Grim Reaper'] = { chance = 100 },
	['War Golem'] = { chance = 100 },
	['Fury'] = { chance = 100 },
	['Bog Raider'] = { chance = 100 },
	['Ashmunrah'] = { chance = 100 },
	
}
]]--

local config = {
    chance = 100, --10%
}
local function sendMessage(target)
    if not target then
        return true
    end
    target:sendMagicEffect(56)
    target:sendMagicEffect(57)
end


local function removeBoostExp(target)
    if not target then
        return true
    end
	local tile = Tile(target)
    if tile then
		local ground = tile:getGround()
		if ground then
			ground:setActionId()
		end
	end
end

function custom_exp_damage_effect.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if creature:isPlayer() then
        return true
    end
    --[[
    local monster = config[creature:getName()]
    if not monster then
        return true
    end
    ]]--
    --if math.random(1, 1000) <= monster.chance then
    if math.random(1, 1000) <= config.chance then
        local tile = Tile(creature:getPosition())
        if tile then
            local ground = tile:getGround()
            if ground then
                ground:setActionId(6000)
                creature:say('BONUS EXP!', TALKTYPE_MONSTER_SAY)
                for i = 0, 3 do
                    addEvent(sendMessage, 750 * i, creature:getPosition())
                end
				
				addEvent(removeBoostExp, 1000 * 3, creature:getPosition())
            end
        end
    end
    return true
end

custom_exp_damage_effect:type("death")
custom_exp_damage_effect:register()
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

--[[
local monsterSpawnExpBoostEvent = EventCallback("monsterSpawnExpBoostEvent")

monsterSpawnExpBoostEvent.monsterOnSpawn = function(monster, position)
    if monster:getType():isRewardBoss() then
        return true
    else
        monster:registerEvent("custom_exp_damage_effect")
    end

	return true
end

monsterSpawnExpBoostEvent:register()
]]--

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

--[[
local custom_exp_damage_effect_login = CreatureEvent("custom_exp_damage_effect_login")

function custom_exp_damage_effect_login.onLogin(player)
    player:registerEvent("custom_exp_damage_effect")
    return true
end

custom_exp_damage_effect_login:type("login")
custom_exp_damage_effect_login:register()

]]--
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
local custom_exp_damage_effect_movement = MoveEvent()
custom_exp_damage_effect_movement:type("stepin")

local function sendEffect(cid)
    local player = Player(cid)
    if not player then
        return true
    end
    local pos = player:getPosition()
    local pos2 = player:getPosition() + Position(math.random(-2, 2), math.random(-2, 2), 0)
    pos2:sendDistanceEffect(pos, 31)
end

function custom_exp_damage_effect_movement.onStepIn(player, item, position, fromPosition)
    if player:isMonster() then
        return true
    end
    local tile = Tile(player:getPosition())
    if tile then
        local ground = tile:getGround()
        if ground then
            ground:setActionId()
            player:setStorageValue(6000, os.time() + 60)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You will received 10% bonus exp for the next 60 seconds.')
            for i = 0, 25 do
                addEvent(sendEffect, 100 * i, player:getId())
            end
        end
    end
    return true
end

custom_exp_damage_effect_movement:aid(6000)

custom_exp_damage_effect_movement:register()
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
local expCheck = TalkAction("!exp")

local function secondsToReadable(s)
    local hours   = math.floor(s / 3600)
    local minutes = math.floor(math.fmod(s, 3600)/60)
    local seconds = math.floor(math.fmod(s, 60))
    return (hours   > 0 and (hours   .. ' hour'   .. (hours   > 1 and 's ' or ' ')) or '') ..
           (minutes > 0 and (minutes .. ' minute' .. (minutes > 1 and 's ' or ' ')) or '') ..
           (seconds > 0 and (seconds .. ' second' .. (seconds > 1 and 's ' or ' ')) or '')
end

function expCheck.onSay(player, words)
 
    local exhaust = 6000
    if player:getStorageValue(exhaust) - os.time() > 0 then
        player:sendTextMessage(MESSAGE_STATUS, "Your bonus exp will end in : "..secondsToReadable(player:getStorageValue(exhaust) - os.time()).."")
        return false
	else
		player:sendTextMessage(MESSAGE_STATUS, "You don't have extra bonus exp active.")
		return false
    end
    return false
end

expCheck:groupType("normal")
expCheck:separator(" ")
expCheck:register()
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
