local talkaction = TalkAction("/testtaintconditions")

function talkaction.onSay(player, words, param)
	player:setTaintIcon()
	return false
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
