local storageGet = TalkAction("/getstorage")

function storageGet.onSay(player, words, param)
	return player:getStorageValueTalkaction(param)
end

storageGet:separator(" ")
storageGet:register()
