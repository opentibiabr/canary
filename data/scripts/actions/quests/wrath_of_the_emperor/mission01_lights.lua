local function transformLamp(position, itemId, transformId)
	local lampItem = Tile(position):getItemById(itemId)
	if lampItem then
		lampItem:transform(transformId)
	end
end

local wrathEmperorMiss1Light = Action()
function wrathEmperorMiss1Light.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3171) then
		if Game.getStorageValue(GlobalStorage.WrathOfTheEmperor.Light01) ~= 1 then
			Game.setStorageValue(GlobalStorage.WrathOfTheEmperor.Light01, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorage.WrathOfTheEmperor.Light01, 0)
			local pos = {
				Position(33369, 31075, 8),
				Position(33372, 31075, 8)
			}
			for i = 1, #pos do
				transformLamp(pos[i], 11447, 11446)
				addEvent(transformLamp, 20 * 1000, pos[i], 11446, 11447)
			end
		end
	elseif(item.uid == 3172) then
		if Game.getStorageValue(GlobalStorage.WrathOfTheEmperor.Light02) ~= 1 then
			Game.setStorageValue(GlobalStorage.WrathOfTheEmperor.Light02, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorage.WrathOfTheEmperor.Light02, 0)
			local pos = Position(33360, 31079, 8)
			transformLamp(pos, 11449, 11463)
			addEvent(transformLamp, 20 * 1000, pos, 11463, 11449)
		end
	elseif(item.uid == 3173) then
		if Game.getStorageValue(GlobalStorage.WrathOfTheEmperor.Light03) ~= 1 then
			Game.setStorageValue(GlobalStorage.WrathOfTheEmperor.Light03, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorage.WrathOfTheEmperor.Light03, 0)
			local pos = Position(33346, 31074, 8)
			transformLamp(pos, 11449, 11463)
			addEvent(transformLamp, 20 * 1000, pos, 11463, 11449)
		end
	elseif(item.uid == 3174) then
		if Game.getStorageValue(GlobalStorage.WrathOfTheEmperor.Light04) ~= 1 then
			Game.setStorageValue(GlobalStorage.WrathOfTheEmperor.Light04, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorage.WrathOfTheEmperor.Light04, 0)
			local wallItem, pos
			for i = 1, 4 do
				pos = Position(33355, 31067 + i, 9)
				wallItem = Tile(pos):getItemById(9264)
				if wallItem then
					wallItem:remove()
					addEvent(Game.createItem, 20 * 1000, 9264, 1, pos)
				end
			end
		end
	end
	return true
end

wrathEmperorMiss1Light:uid(3171,3172,3173,3174)
wrathEmperorMiss1Light:register()