local blessbook = Action()

function blessbook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
		Blessings.BuyAllBlesses(player)
		return true
	end
	
	

blessbook:id(60908)
blessbook:register()
