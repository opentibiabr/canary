local refiller = Action()
local timeToDisapear = 100 * 1000
function refiller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and  player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked() then
        player:sendCancelMessage("You can't use this while in battle.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end
    
    
    local pid = player:getId()
    if HUNT_REFILLER[pid] and HUNT_REFILLER[pid].time > os.time() then
        player:sendCancelMessage("You need to wait before use this item again")
        return true
    end

    if not HUNT_REFILLER[pid] then HUNT_REFILLER[pid] = {} end
        local position = player:getPosition()
        local npc = Game.createNpc('Hunt Refiller', position)
        HUNT_REFILLER[pid].time = os.time() + 15 * 60
        HUNT_REFILLER[pid].npc = npc:getId()
        
        addEvent(function() 
            npc:remove()
        end, timeToDisapear)
        if npc then
            npc:setMasterPos(position)
            position:sendMagicEffect(CONST_ME_MAGIC_RED)
        end


    return true
end

refiller:id(44912) -- REPLACE HERE
refiller:register()