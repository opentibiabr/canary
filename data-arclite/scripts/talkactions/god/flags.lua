local flag = TalkAction("/hasflag")

function flag.onSay(player, words, param)
	return player:talkactionHasFlag(param)
end

flag:separator(" ")
flag:register()

flag = TalkAction("/setflag")

function flag.onSay(player, words, param)
	return player:talkactionSetFlag(param)
end

flag:separator(" ")
flag:register()

flag = TalkAction("/removeflag")

function flag.onSay(player, words, param)
	return player:talkactionRemoveFlag(param)
end

flag:separator(" ")
flag:register()
