
-----------MURCION-----
---hub to murcion----
local config = {
    minLevel = 400,
    firstPosition = Position(34092, 31978, 14), 
    secondPosition = Position(33843, 31652, 13)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4000)
treePass:register()

---murcion to hub----
local config = {
    minLevel = 400,
    firstPosition = Position(33842, 31650, 13), 
    secondPosition = Position(34093, 31979, 14)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4001)
treePass:register()


----murcion boss entrance---
local config = {
    minLevel = 400,
    firstPosition = Position(33905, 31693, 15), 
    secondPosition = Position(32972, 32364, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4002)
treePass:register()



---------------CHAGORZ---------------
----hub to chargoz--
local config = {
    minLevel = 400,
    firstPosition = Position(34093, 32009, 14), 
    secondPosition = Position(33810, 31816, 13)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4003)
treePass:register()


-----chargoz to hub-----
local config = {
    minLevel = 400,
    firstPosition = Position(33809, 31814, 13), 
    secondPosition = Position(34092, 32008, 14)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4004)
treePass:register()

------ chargoz boss----
local config = {
    minLevel = 400,
    firstPosition = Position(33902, 31881, 15), 
    secondPosition = Position(33075, 32364, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4005)
treePass:register()

-----------------VEMIATH------------

------hub to vemiath--------
local config = {
    minLevel = 400,
    firstPosition = Position(34117, 32010, 15), 
    secondPosition = Position(34120, 31877, 14)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4006)
treePass:register()

----vemiath to hub----
local config = {
    minLevel = 400,
    firstPosition = Position(34119, 31875, 14), 
    secondPosition = Position(34119, 32009, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4007)
treePass:register()

----vemiath boss----
local config = {
    minLevel = 400,
    firstPosition = Position(34002, 31820, 15), 
    secondPosition = Position(33076, 32330, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4008)
treePass:register()



------------ICHGAHAL----------

----HUB TO ichgahal----
local config = {
    minLevel = 400,
    firstPosition = Position(34120, 31978, 14), 
    secondPosition = Position(34100, 31679, 13)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4009)
treePass:register()

----ichgahal to hub----
local config = {
    minLevel = 400,
    firstPosition = Position(34101, 31677, 13), 
    secondPosition = Position(34118, 31977, 14)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4010)
treePass:register()

----ichgahal boss----
local config = {
    minLevel = 400,
    firstPosition = Position(34065, 31716, 15), 
    secondPosition = Position(32974, 32331, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4011)
treePass:register()


-------------BAKRAGORE--------

----hub to bakragore----
local config = {
    minLevel = 400,
    firstPosition = Position(34106, 32054, 13), 
    secondPosition = Position(33011, 32389, 15)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(4012)
treePass:register()


