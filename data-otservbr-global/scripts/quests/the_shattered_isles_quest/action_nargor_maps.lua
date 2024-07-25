local UniqueTable = {
	[40001] = {
		storage = Storage.Quest.U7_8.TheShatteredIsles.TavernMap1,
		message = "You have sucessfully read plan A.",
	},
	[40002] = {
		storage = Storage.Quest.U7_8.TheShatteredIsles.TavernMap2,
		message = "You have sucessfully read plan B.",
	},
	[40003] = {
		storage = Storage.Quest.U7_8.TheShatteredIsles.TavernMap3,
		message = "You have sucessfully read plan C.",
	},
}

local nargorMaps = Action()

function nargorMaps.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = UniqueTable[item.uid]
	if not setting then
		return true
	end

	if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission3) ~= 1 then
		return false
	end

	if player:getStorageValue(setting.storage) < 0 then
		player:setStorageValue(setting.storage, 1)
		player:say(setting.message, TALKTYPE_MONSTER_SAY)
		return true
	end
	return false
end

for index, value in pairs(UniqueTable) do
	nargorMaps:uid(index)
end

nargorMaps:register()
