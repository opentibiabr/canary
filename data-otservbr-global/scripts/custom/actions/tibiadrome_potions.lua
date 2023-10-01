local dromePotions = Action()
function dromePotions.onUse(player, item, frompos, item2, topos)
	DROME_POTIONS.parseUseAction(player, item)
	return true
end

for _, id in pairs(DROME_POTIONS.POTIONS_IDS) do
	dromePotions:id(id)
end

dromePotions:register()

