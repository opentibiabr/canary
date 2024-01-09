
tpScroll = Action()
tpScroll:id(60132) 


local savePos = {}

local function sendEffects(position, effect, pid)
    if savePos[pid] then
        if savePos[pid].Enabled then
            local player = Player(pid)
            if isPlayer(player) then
                position:sendMagicEffect(effect, player)
                addEvent(sendEffects, 400, position, effect, pid, CS)
            end
        end
    end
end

function tpScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local pid = player:getId()
    if not player:isPzLocked() then
        if not savePos[pid] then
            savePos[pid] = {
                ScrollActivatedPosition = player:getPosition(),
                RandomTemplePosition = nil,
                Enabled = true,
                Cooldown = os.time() + 31
            }
            player:teleportTo(player:getTown():getTemplePosition())
			item:remove(1)
            local pos = player:getPosition()
            savePos[pid].RandomTemplePosition = Position(pos.x+math.random(1), pos.y+math.random(1), pos.z)
            sendEffects(savePos[pid].RandomTemplePosition, 246, pid)
            sendEffects(savePos[pid].ScrollActivatedPosition, 246, pid)
            local item = Item(Tile(savePos[pid].RandomTemplePosition):getGround().uid)
            item:setActionId(57417)
            addEvent(
                function()
                    if item:getActionId(57417) then
                        item:removeAttribute('aid')
                        savePos[pid] = nil
                    end
                end
            ,180 * 1000) 

        else 
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            if savePos[pid].Enabled then
                player:sendTextMessage(MESSAGE_INFO_DESCR, 'You must enter on your teleport first before you use this again. The teleport will exist for ' .. savePos[pid].Cooldown - os.time() .. ' more seconds.')
            else 
                player:sendTextMessage(MESSAGE_INFO_DESCR, 'Remaining cooldown: ' .. savePos[pid].Cooldown - os.time() .. ' seconds.')
            end
        end
    else 
        player:sendTextMessage(MESSAGE_INFO_DESCR, 'You may not use this while you are in battle.')
    end
    return true
end


tpScroll:register()


randomTemplePosition = MoveEvent()
randomTemplePosition:aid(57417)

function randomTemplePosition.onStepIn(creature, item, position, fromPosition)
    local pid = creature:getId()
    local pos = savePos[pid]
    if pos and pos.RandomTemplePosition then
        creature:teleportTo(pos.ScrollActivatedPosition)
        pos.ScrollActivatedPosition:sendMagicEffect(CONST_ME_STUN)
        pos.RandomTemplePosition:sendMagicEffect(CONST_ME_STUN)
        item:removeAttribute('aid')
        savePos[pid].Enabled = false
    end
    return true
end

randomTemplePosition:register()

local tpscroll_player = CreatureEvent("tpscroll_player")


function tpscroll_player.onLogout(player)
    local pid = player:getId()
    if savePos[pid] then
        Item(Tile(savePos[pid].RandomTemplePosition):getGround().uid):removeAttribute('aid')
        savePos[pid].Enabled = false
    end
    return true
end

tpscroll_player:register()