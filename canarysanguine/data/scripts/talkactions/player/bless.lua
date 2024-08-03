local bless = TalkAction("!bless")

function bless.onSay(player, words, param)
	Blessings.BuyAllBlesses(player)
	return true
end

bless:groupType("normal")
bless:register()
