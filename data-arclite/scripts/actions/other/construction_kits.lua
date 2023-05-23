local constructionKits = {
	[2775] = 2374,
	[2776] = 2378,
	[2777] = 2360,
	[2778] = 2382,
	[2779] = 2366,
	[2780] = 2418,
	[2781] = 2422,
	[2782] = 2319,
	[2812] = 11812,
	[10207] = 2986,
	[2785] = 2314,
	[2786] = 2347,
	[2787] = 2348,
	[2788] = 2350,
	[2789] = 2433,
	[2790] = 2441,
	[2791] = 2449,
	[2792] = 2524,
	[2793] = 2523,
	[2794] = 2483,
	[2795] = 2465,
	[2796] = 2976,
	[2797] = 2979,
	[2798] = 2934,
	[2799] = 3485,
	[2800] = 2998,
	[2801] = 2445,
	[2802] = 2025,
	[2803] = 2029,
	[2804] = 2030,
	[2805] = 2904,
	[2806] = 3513,
	[2807] = 2959,
	[2808] = 2963,
	[2809] = 2426,
	[2810] = 2352,
	[2811] = 2982,
	[2812] = 2353,
	[5086] = 5046,
	[5087] = 5055,
	[5088] = 5056,
	[6114] = 6111,
	[6115] = 6109,
	[6371] = 6355,
	[6372] = 6370,
	[7864] = 7860,
	[9061] = 9062,
	[10209] = 10210,
	[10216] = 10212,
	[10207] = 10208,
	[10288] = 10286,
	[2783] = 2316,
	[2784] = 2315,
	[14741] = 14687,
	[14756] = 14755,
	[17974] = 18015,
	[17975] = 18017,
	[17977] = 18019
}

local jackToTheFuture_Kits = {
	[2775] = {
		itemId = 2374,
		kitMessage = "The red cushioned chair looks quite comfy in that corner.",
		jackSay = "Jack: Yeah uhm... impressive chair. Now would you please remove it? Thanks.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture01
	},
	[2797] = {
		itemId = 2979,
		kitMessage = "A globe like this should be in every household.",
		jackSay = "Jack: What the... what do I need a 'globe' for? Take this away.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture02
	},
	[2799] = {
		itemId = 3485,
		kitMessage = "The telescope just looks like it was the one thing missing from this room.",
		jackSay = "Jack: Nice, a... what is this actually?",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture03
	},
	[2800] = {
		itemId = 2998,
		kitMessage = "What a cute horse - and just the right thing to place into this cute room.",
		jackSay = "Jack: A rocking horse? What's wrong with you.",
		storage = Storage.TibiaTales.JackFutureQuest.Furniture04
	},
	[2805] = {
		itemId = 2904,
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
