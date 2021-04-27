local config = {
	[12545] = {itemId = 12506, storage = Storage.FathersBurden.Corpse.Scale, text = 'Glitterscale\'s scale.'},
	[12546] = {itemId = 12504, storage = Storage.FathersBurden.Corpse.Sinew, text = 'Heoni\'s sinew'}
}

local fatherCorpse = Action()
function fatherCorpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local corpse = config[item.itemid]
	if not corpse then
		return true
	end

	if player:getStorageValue(corpse.storage) == 1 then
		return false
	end

	player:addItem(corpse.itemId, 1)
	player:setStorageValue(corpse.storage, 1)
	player:say('You acquired ' .. corpse.text, TALKTYPE_MONSTER_SAY)
	return true
end

fatherCorpse:id(12545, 12546)
fatherCorpse:register()