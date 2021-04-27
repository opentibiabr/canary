local heroRathletonCorpse = Action()
function heroRathletonCorpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 8641 then
		return false
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.LavaCounter, Game.getStorageValue(GlobalStorage.HeroRathleton.LavaCounter) + 1)
	item:remove()
	target:getPosition():sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

heroRathletonCorpse:id(24184)
heroRathletonCorpse:allowFarUse(true)
heroRathletonCorpse:register()