-- /mounts playername

local mounts = TalkAction("/mounts")
function mounts.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local target
    if param == '' then
        target = player:getTarget()
        if not target then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Unlocks all mounts for certain player. Usage: /mounts <player name>')
            return false
        end
    else
        target = Player(param)
    end

    if not target then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Player ' .. param .. ' is not currently online.')
        return false
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD  then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Cannot perform action.')
        return false
    end

    for i = 1, 197 do
        target:addMount(i)
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'All mounts unlocked for: ' .. target:getName())
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'All of your mounts have been unlocked!')
    return false
end

mounts:separator(" ")
mounts:register()
