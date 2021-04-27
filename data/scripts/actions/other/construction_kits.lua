local constructionKits = {
	[3901] = 1666,
	[3902] = 1670,
	[3903] = 1652,
	[3904] = 1674,
	[3905] = 1658,
	[3906] = 3813,
	[3907] = 3817,
	[3908] = 1619,
	[3909] = 12799,
	[3910] = 2105,
	[3911] = 1614,
	[3912] = 3806,
	[3913] = 3807,
	[3914] = 3809,
	[3915] = 1716,
	[3916] = 1724,
	[3917] = 1732,
	[3918] = 1775,
	[3919] = 1774,
	[3920] = 1750,
	[3921] = 3832,
	[3922] = 2095,
	[3923] = 2098,
	[3924] = 2064,
	[3925] = 2582,
	[3926] = 2117,
	[3927] = 1728,
	[3928] = 1442,
	[3929] = 1446,
	[3930] = 1447,
	[3931] = 2034,
	[3932] = 2604,
	[3933] = 2080,
	[3934] = 2084,
	[3935] = 3821,
	[3936] = 3811,
	[3937] = 2101,
	[3938] = 3812,
	[5086] = 5046,
	[5087] = 5055,
	[5088] = 5056,
	[6114] = 6111,
	[6115] = 6109,
	[6372] = 6356,
	[6373] = 6371,
	[8692] = 8688,
	[9974] = 9975,
	[11126] = 11127,
	[11133] = 11129,
	[11124] = 11125,
	[11205] = 11203,
	[14328] = 1616,
	[14329] = 1615,
	[16075] = 16020,
	[16099] = 16098,
	[20254] = 20295,
	[20255] = 20297,
	[20257] = 20299
}

local jackToTheFuture_Kits = {
	[3901] = {
		itemId = 1666,
		kitMessage = "The red cushioned chair looks quite comfy in that corner.",
		jackSay = "Jack: Yeah uhm... impressive chair. Now would you please remove it? Thanks.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture01
	},
	[3923] = {
		itemId = 2098,
		kitMessage = "A globe like this should be in every household.",
		jackSay = "Jack: What the... what do I need a 'globe' for? Take this away.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture02
	},
	[3925] = {
		itemId = 2582,
		kitMessage = "The telescope just looks like it was the one thing missing from this room.",
		jackSay = "Jack: Nice, a... what is this actually?",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture03
	},
	[3926] = {
		itemId = 2117,
		kitMessage = "What a cute horse - and just the right thing to place into this cute room.",
		jackSay = "Jack: A rocking horse? What's wrong with you.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture04
	},
	[3931] = {
		itemId = 2034,
		kitMessage = "There seems to be no better place for this amphora than right here.",
		jackSay = "Jack: Trying to get rid of your junk in my house? Do I look like I need such a... 'vase'?",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture05
	}
}

local jackToTheFuture_House = {
	beginPos = Position(33273, 31754, 7),
	finalPos = Position(33278, 31759, 7)
}

local constructionKit = Action()

function constructionKit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition():isInRange(jackToTheFuture_House.beginPos, jackToTheFuture_House.finalPos) then
		if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 3 then
			local setting = jackToTheFuture_Kits[item.itemid]
			if setting then
				if player:getStorageValue(setting.storage) < 1 then
					item:remove()
					Game.createItem(setting.itemId, 1, player:getPosition())
					player:say(setting.jackSay, TALKTYPE_MONSTER_SAY)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.kitMessage)
					player:setStorageValue(setting.storage, 1)
					return true
				end
			end
		end
	end

	local kit = constructionKits[item.itemid]
	if not kit then
		return false
	end

	if fromPosition.x == CONTAINER_POSITION then
		player:sendTextMessage(MESSAGE_FAILURE, "Put the construction kit on the floor first.")
	elseif not fromPosition:getTile():getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may construct this only inside a house.")
	else
		item:transform(kit)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:addAchievementProgress("Interior Decorator", 1000)
	end
	return true
end

for index, value in pairs(constructionKits) do
	constructionKit:id(index)
end

constructionKit:register()
