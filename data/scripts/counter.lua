--[[
    Monster Counter
    By: 𝓜𝓲𝓵𝓵𝓱𝓲𝓸𝓻𝓮 𝓑𝓣
    version: 1.0
]]--

local function timeFormat(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds - (hours * 3600)) / 60)
    local seconds = seconds - (hours * 3600) - (minutes * 60)
    local time = {}
    if hours > 0 then time[#time + 1] = hours .. "h " end
    if minutes > 0 then time[#time + 1] = minutes .. "m " end
    if seconds > 0 then time[#time + 1] = seconds .. "s " end
    return table.concat(time)
end

local Counter = Creature
local function getSeconds(counter) return counter:getStorageValue("MonsterCounter") end
local function setSeconds(counter, seconds) return counter:setStorageValue("MonsterCounter", seconds) end
local function decreaseSeconds(counter) return setSeconds(counter, getSeconds(counter) - 1) end
local function updateHealth(counter, initialSeconds) return counter:setHealth(math.ceil(counter:getMaxHealth() / 100 * math.ceil((getSeconds(counter) * 100) / initialSeconds))) end
local function updateName(counter, props)
    local name = {}
    if type(props.prefix) == "string" then
        name[#name + 1] = props.prefix
    end

    name[#name + 1] = timeFormat(getSeconds(counter))

    if type(props.suffix) == "string" then
        name[#name + 1] = props.suffix
    end

    return counter:rename(table.concat(name))
end

local function onThink(props)
    local counter = Counter(props.counterId)
    if not counter then
        error("Could not find counter.")
    end

    local seconds = getSeconds(counter)
    if seconds <= 0 then
        if props.onEnd then
            props.onEnd(counter:getPosition())
        end
        return counter:remove()
    end

    --updateName(counter, props)
    decreaseSeconds(counter)
    updateHealth(counter, props.initialSeconds)
    if props.onThink then
        props.onThink(getSeconds(counter), counter:getPosition())
    end

    if not counter:isRemoved() then
        addEvent(onThink, 1000, props)
    end
    return true
end

function Game.createMonsterCounter(props)
    if type(props) ~= "table" then
        error("Invalid props table.")
    end

    if getmetatable(props.position) ~= Position then
        error("Invalid position.")
    end

    if type(props.seconds) ~= "number" then
        error("Invalid seconds.")
    end

    local counter = Game.createMonster("Monster Counter", props.position, true, true)
    if not counter then
        error("Could not create counter.")
    end

    if type(props.outfit) == "table" then
        counter:setOutfit(props.outfit)
    elseif type(props.lookType) == "number" then
        local outfit = counter:getOutfit()
        outfit.lookType = props.lookType
        counter:setOutfit(outfit)
    end

    --updateName(counter, props)
    setSeconds(counter, props.seconds)
    props.initialSeconds = props.seconds
    props.counterId = counter:getId()
    addEvent(onThink, 1000, props)
    return true
end

-- Model
local mType = Game.createMonsterType("Monster Counter")
local monster = {}
monster.description = "an monster counter"
monster.experience = 0
monster.outfit = { lookType = 0 }
monster.health = 10000000
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
monster.changeTarget = { interval = 0, chance = 0 }
monster.flags = {
    summonable = false,
    attackable = false,
    hostile = false,
    challengeable = false,
    convinceable = false,
    ignoreSpawnBlock = false,
    illusionable = false,
    canPushItems = true,
    canPushCreatures = true,
    targetDistance = 1,
    staticAttackChance = 0
}

mType:register(monster)