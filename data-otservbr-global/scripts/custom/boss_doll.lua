local bosstalk = TalkAction("!boss")
local bosstalk = {
	-- Config
	mainTitle = "Boss talk",
	mainMsg = "Status dos boss",
}
function bosstalk.onSay(player, words, param)
    player:sendBossWindow(bosseye)
    return true
end
bosstalk:separator(" ")
bosstalk:register()