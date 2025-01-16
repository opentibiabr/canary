-- Helper function for checking if a value exists in a table
local function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

-- Event for Cobra Flask Effect on Monster Spawn
local applyCobraFlaskEffectOnMonsterSpawn = EventCallback("CobraFlaskEffectOnMonsterSpawn")

applyCobraFlaskEffectOnMonsterSpawn.monsterOnSpawn = function(monster, position)
    local cobraMonsters = { "cobra scout", "cobra vizier", "cobra assassin" }
    if tableContains(cobraMonsters, monster:getName():lower()) then
        local flaskStorage = Game.getStorageValue(Global.Storage.CobraFlask)
        if flaskStorage >= os.time() then
            monster:setHealth(monster:getMaxHealth() * 0.75)
            monster:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
        else
            Game.setStorageValue(Global.Storage.CobraFlask, -1)
        end
    end
    return true
end

applyCobraFlaskEffectOnMonsterSpawn:register()

-- Action for using the Cobra Flask
local cobraFlask = Action()

function cobraFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local cobraTargets = { 31284, 31285, 31286, 31287 }
    local resetTargets = { 4188, 4189, 4190 }

    if tableContains(cobraTargets, target:getId()) then
        target:getPosition():sendMagicEffect(CONST_ME_GREENSMOKE)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
            "You carefully pour just a tiny, little, finely dosed... and there goes the whole content of the bottle. Stand back!")
        item:transform(31297)
        Game.setStorageValue(Global.Storage.CobraFlask, os.time() + 30 * 60)
    elseif tableContains(resetTargets, target:getId()) then
        item:transform(31296)
    end
    return true
end

cobraFlask:id(31296, 31297) -- Register both flask item IDs
cobraFlask:register()
