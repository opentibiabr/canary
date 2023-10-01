local vip = TalkAction("!vip")

function vip.onSay(player, words, param)
	local days = player:getVipDays()
    if days == 0 then
        player:sendCancelMessage('You do not have any vip days.')
    else
        player:sendCancelMessage(string.format('You have %s vip day%s left.', (days == 0xFFFF and 'infinite amount of' or days), (days == 1 and '' or 's')))
    end
    return false
end

vip:register()