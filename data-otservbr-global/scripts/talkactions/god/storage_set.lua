local talkaction = TalkAction("/addstorage")

function talkaction.onSay(player, words, param)
	return player:setStorageValueTalkaction(param)
end

talkaction:separator(" ")
talkaction:register()
