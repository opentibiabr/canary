local gravediggerBones = Action()
function gravediggerBones.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4633 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission19) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission19, 1)
		player:addItem(21406, 1)
		item:remove()
	end
	return true
end

gravediggerBones:id(21407)
gravediggerBones:register()