local posdotp = Position(33104, 31908, 10)

local creatures = {
    "humongous fungus",
    "hideous fungus"
}

local function removeTp()
    local t = Tile(posdotp):getItemById(1387)
    if t then
        t:remove()
        Game.createItem(17999,1,posdotp)-- Stone pos
        posdotp:sendMagicEffect(CONST_ME_POFF)
    end
end

local function magicEffectWz(pos, cons)
    pos:sendMagicEffect(cons)
end

local function createTp()
    local cristal = Tile(posdotp):getItemById(17999)
    if cristal then
        cristal:remove()
        local tp = Game.createItem(1387, 1, posdotp)
        if tp then
            tp:setActionId(45700)
        end
    end
    return true
end

local bigfootWarzoneCrystal = Action()
function bigfootWarzoneCrystal.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
    local config = warzoneConfig.findByName("Deathstrike")
    if Game.getStorageValue(96974) < 1 then
        Game.setStorageValue(96974, 1)
        for i = 1, 10 do
          for k = 1, 6 do
            pos = Position(math.random(33094, 33101), math.random(31900, 31916), 10)
                addEvent(Game.createMonster, i * 20 * 1000, creatures[math.random(1,2)], pos)
                addEvent(magicEffectWz, i * 20 * 1000, pos, CONST_ME_TELEPORT)
            end
        end

        player:say("The crystals are charging!", TALKTYPE_MONSTER_SAY, false, player, toPosition)
        addEvent(createTp, 200000) -- 3.33 min
        addEvent(removeTp, 260000) -- 4.33 min
        addEvent(warzoneConfig.spawnBoss, 280000, config.boss, config.bossResp) -- 5 min
        addEvent(warzoneConfig.resetRoom, 30 * 60 * 1000, config, "You were teleported out by the gnomish emergency device.", true)
        addEvent(Game.setStorageValue, 30 * 60 * 1000, 96974, 0)
    else
        doPlayerSendCancel(player, "Wait 30 minutes to start again.")
    end
    return true
end

bigfootWarzoneCrystal:uid(3143)
bigfootWarzoneCrystal:register()