local vipGod = TalkAction("/vip")

function vipGod.onSay(player, words, param)

    if not player:getGroup():getAccess() then
        return true
    end

    local params = param:split(',')
    if not params[2] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('Player is required.\nUsage:\n%s <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove', words))
        return false
    end

    local targetName = params[2]:trim()
    local target = Player(targetName)
    if not target then
        player:sendCancelMessage(string.format('Player (%s) is not online. Usage: %s <action>, <player> [, <value>]', targetName, words))
        return false
    end

    local action = params[1]:trim():lower()
    if action == 'adddays' then
        local amount = tonumber(params[3])
        if not amount then
            player:sendCancelMessage('<value> has to be a numeric value.')
            return false
        end

        target:addVipDays(amount)
        player:sendCancelMessage(string.format('%s received %s vip day(s) and now has %s vip day(s).', target:getName(), amount, target:getVipDays()))

    elseif action == 'removedays' then
        local amount = tonumber(params[3])
        if not amount then
            player:sendCancelMessage('<value> has to be a numeric value.')
            return false
        end

        target:removeVipDays(amount)
        player:sendCancelMessage(string.format('%s lost %s vip day(s) and now has %s vip day(s).', target:getName(), amount, target:getVipDays()))

    elseif action == 'addinfinite' then
        target:addInfiniteVip()
        player:sendCancelMessage(string.format('%s now has infinite vip time.', target:getName()))

    elseif action == 'remove' then
        target:removeVip()
        player:sendCancelMessage(string.format('You removed all vip days from %s.', target:getName()))

    elseif action == 'check' then
        local days = target:getVipDays()
        player:sendCancelMessage(string.format('%s has %s vip day(s).', target:getName(), (days == 0xFFFF and 'infinite' or days)))

    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('Action is required.\nUsage:\n%s <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove', words))
    end
    return false
end

vipGod:separator(" ")
vipGod:register()