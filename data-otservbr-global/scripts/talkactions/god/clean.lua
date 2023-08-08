local clean = TalkAction("/clean")

function clean.onSay(player, words, param)
	local itemCount = cleanMap()
	if itemCount ~= 0 then
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Cleaned " .. itemCount .. " item" .. (itemCount > 1 and "s" or "") .. " from the map.")
	end
	return false
end

clean:separator(" ")
clean:groupType("gamemaster")
clean:register()
