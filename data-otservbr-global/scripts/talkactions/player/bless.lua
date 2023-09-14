local bless = TalkAction("!bless")

function bless.onSay(player, words, param)
	return Blessings.BuyAllBlesses(player)
end

bless:register()
