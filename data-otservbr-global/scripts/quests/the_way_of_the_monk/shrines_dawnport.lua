local config = {
	{ pos = Position(32046, 31861, 5), storage = Storage.Quest.U14_15.TheWayOfTheMonk.DawnportFirstShrine },
	{ pos = Position(32082, 31879, 5), storage = Storage.Quest.U14_15.TheWayOfTheMonk.DawnportSecondShrine },
	{ pos = Position(32048, 31888, 6), storage = Storage.Quest.U14_15.TheWayOfTheMonk.DawnportThirdShrine },
	{ pos = Position(32067, 31915, 6), storage = Storage.Quest.U14_15.TheWayOfTheMonk.DawnportFourthShrine },
}

local Shrines = Action()
function Shrines.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, shrine in ipairs(config) do
		if fromPosition == shrine.pos then
			fromPosition:sendMagicEffect(37)
			item:transform(50244)

			addEvent(function()
				item:transform(50242)
			end, 30 * 1000)

			if player:getStorageValue(shrine.storage) >= 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Three-Fold Path dictates the order of the shrines to visit and when to do this. This is either not the time for this shrine or you are not yet experienced enough to prepare yourself for the gifts of the Merudri.")
				return true
			end

			player:setStorageValue(shrine.storage, 1)

			player:addExperience(50, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You honour the ways of the Merudri at the shrine of Darkness.")
		end
	end
	return true
end

for _, shrine in ipairs(config) do
	Shrines:position(shrine.pos)
end
Shrines:register()
