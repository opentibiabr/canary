local gravediggerBones = Action()
function gravediggerBones.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4633 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission19) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission19, 1)
		player:addItem(19089, 1)
		item:remove()
	end
	return true
end

gravediggerBones:id(19090)
gravediggerBones:register()
