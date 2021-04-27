local thirdSealLever = Action()

function thirdSealLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1946 then
		return false
	end

	local switchNum = Game.getStorageValue("switchNum")
	if switchNum == -1 then
		Game.setStorageValue("switchNum", 1)
	end

	local table = thirdSealTable[switchNum]
	if not table then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSeal) == 1 then
		return false
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSeal) < 1 then
		if item.uid == table then
			item:transform(1945)
			Game.setStorageValue("switchNum", Game.getStorageValue("switchNum") + 1)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			for i = 1, #thirdSealTable.effectPosition[switchNum] do
				Position(thirdSealTable.effectPosition[switchNum][i]):sendMagicEffect(CONST_ME_ENERGYHIT)
			end
			if Game.getStorageValue("switchNum") == 6 then
				for i = 1, #thirdSealTable.coalBasinPosition do
					local positions = thirdSealTable.coalBasinPosition[i]
					Position(positions):removeItem(1485)
					Position(positions):createItem(1484)
				end
			end
		else
			toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		end
	end
	return true
end

for uniqueRange = 30013, 30017 do
	thirdSealLever:uid(uniqueRange)
end

thirdSealLever:register()
