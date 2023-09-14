local bosseye = TalkAction("!boss")
local bosseye = {
	-- Config
	mainTitle = "Boss Eye",
	mainMsg = "Status dos boss",
}
function bosseye.onSay(player, words, param)
    player:sendBossWindow(bosseye)
    return true
end
bosseye:separator(" ")
bosseye:register()