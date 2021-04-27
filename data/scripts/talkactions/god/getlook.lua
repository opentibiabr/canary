local getlook = TalkAction("/getlook")

function getlook.onSay(player, words, param)
	if player:getGroup():getAccess() then	
		local lookt = Creature(player):getOutfit()
		player:sendTextMessage(MESSAGE_INFO_DESCR, "<look type=\"".. lookt.lookType .."\" head=\"".. lookt.lookHead .."\" body=\"".. lookt.lookBody .."\" legs=\"".. lookt.lookLegs .."\" feet=\"".. lookt.lookFeet .."\" addons=\"".. lookt.lookAddons .."\" mount=\"".. lookt.lookMount .."\" />")
		return false
	end
end

getlook:separator(" ")
getlook:register()
