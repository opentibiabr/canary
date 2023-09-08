-- Used for getting a chance at obtaining the modified gnarlhound mount without
-- having completed The Shadows of Yalahar quest
local spikedSquelcher = Action()

function spikedSquelcher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseSpikedSquelcher(player, item, fromPosition, target, toPosition, isHotkey)
end

spikedSquelcher:id(7452)
spikedSquelcher:register()
