local boneLever = Position(33204, 32069, 8)
local middleLever = Position(33251, 32039, 8)
local thirdLever = Position(33218, 32096, 10)

local transform = {
	[9110] = 9111,
	[9111] = 9110,
}

local actions_museum_levers = Action()

function actions_museum_levers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.LeverPermission) ~= 6 then
		if item:getPosition() == boneLever then
			if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 3 then
				player:say("You don't know what to do.", TALKTYPE_MONSTER_SAY)
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 4)
			elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 5 then
				if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.MuseumTimer) > os.time() then
					player:say("back, back, up, right, left", TALKTYPE_MONSTER_SAY)
					player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.LeverPermission, 1)
				else
					player:say("You're too late.", TALKTYPE_MONSTER_SAY)
					return true
				end
			end
		elseif item:getPosition() == middleLever then
			if item.itemid == 9110 then
				if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 5 and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.MuseumTimer) < os.time() then
					player:say("As you turn the lever you can heart it ticking. Maybe you should hurry up!", TALKTYPE_MONSTER_SAY)
					player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.MuseumTimer, os.time() + 2 * 60)
					item:transform(item.itemid + 1)
				end
			end
		end
	end

	if item:getPosition() == thirdLever and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin) ~= 1 then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.TakenRod) < os.time() then
			player:addItem(28709, 1)
			player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.TakenRod, os.time() + 2 * 60)
		else
			return true
		end
	end

	if item.itemid == 9110 or item.itemid == 9111 then
		item:transform(transform[item:getId()])
	end

	return true
end

actions_museum_levers:aid(4906)
actions_museum_levers:register()
