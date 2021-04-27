local lionsRockSanctuaryRockId = 3608

local rewards = {
	'emerald bangle',
	'giant shimmering pearl',
	'gold ingot',
	'green gem',
	'red gem',
	"lion's heart",
	'yellow gem'
}

local UniqueTable = {
	[40004] = {
		storage = Storage.LionsRock.LionsStrength,
		itemPosition = {x = 33137, y = 32291, z = 8},
		pagodaPosition = { x = 33134, y = 32289, z = 8},
		item = 10551,
		storage = Storage.LionsRock.Questline,
		value = 1,
		newValue = 2,
		message = "You have sacrificed a cobra tongue at an ancient statue. The light in the small \z
		pyramid nearby begins to shine.",
		effect = CONST_ME_BLOCKHIT,
	},
	[40005] = {
		storage = Storage.LionsRock.LionsBeauty,
		itemPosition = {x = 33138, y = 32369, z = 8},
		pagodaPosition = { x = 33136, y = 32369, z = 8},
		item = 23760,
		storage = Storage.LionsRock.Questline,
		value = 2,
		newValue = 3,
		message = "You burnt a lion's mane flower. The light in the small pyramid nearby begins to shine.",
		effect = CONST_ME_REDSMOKE
	},
	[40006] = {
		storage = Storage.LionsRock.LionsTears,
		itemPosition = {x = 33154, y = 32279, z = 8},
		pagodaPosition = { x = 33156, y = 32279, z = 8},
		item = 23835,
		storage = Storage.LionsRock.Questline,
		value = 3,
		newValue = 4,
		message = "You have purified a sacret pedestal with holy water. You have now passed the last test\z
		to enter thge inner sanctum.",
		effect = CONST_ME_LOSEENERGY
	}
}

-- Lions rock skeleton
local lionsRockSkeleton = Action()

function lionsRockSkeleton.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = CorpseUnique[item.uid]
	if not setting then
		return true
	end

	if player:getStorageValue(Storage.LionsRock.Questline) < 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have discovered a skeleton. It seems to hold an old parchment.')
		player:addItem(23784, 1):setAttribute(
			ITEM_ATTRIBUTE_TEXT,
			"\"Still it is hard to believe that I finally found the mystical rock formations near Darashia, \z
			known as Lion's Rock. According to ancient records there is a temple for an unknown, probably long \z
			forgotten deity, built in the tunnels deep below the rock centuries ago. This holy site was once guarded \z
			by mystical lions and they may still be down there. But yet I haven't succeeded in entering the inner \z
			sanctum. The entrance to the lower temple areas is protected by an old and powerful enchantment. I \z
			studied the inscriptions on the temple walls and thus learned that the key to the inner sanctum is the \z
			passing of three tests. The first test is the Lion's Strength. In order to honour the site's mystical \z
			cats of prey one has to hunt and slay a cobra. The cobra's tongue must be laid down at a stone statue as \z
			a sacrifice. The second test is the Lion's Beauty. One has to burn the petals of a lion's mane flower on \z
			a coal basin. In the sand at the rock's foot I saw some dried lion's mane petals. Maybe these flowers \z
			grow somewhere upwards. The third test is called the Lion's Tears. It seems one has to purify an \z
			ornamented stone pedestal with ...\" At this point the records end because the parchment is destroyed. \z
			It seems that is was torn by a big paw ..."
		)
		player:setStorageValue(Storage.LionsRock.Questline, 1)
		player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return true
end

lionsRockSkeleton:uid(20002)
lionsRockSkeleton:register()

-- Lions rock sacrifices
local lionsRockSacrificesTest = Action()

function lionsRockSacrificesTest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = UniqueTable[target.uid]
	if not setting then
		return true
	end

	local function reset()
		local pagodaLit = Tile(setting.itemPosition):getItemById(3710)
		if pagodaLit then
			pagodaLit:transform(3709)
		end
	end

	if item.itemid == setting.item then
		if player:getStorageValue(setting.storage) == setting.value then
			local pagoda = Tile(setting.pagodaPosition):getItemById(3709)
			if pagoda then
				pagoda:transform(3710)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message)
				player:setStorageValue(setting.storage, setting.newValue)
				player:removeItem(setting.item, 1)
				toPosition:sendMagicEffect(setting.effect)
				addEvent(reset, 15 * 1000)
			end
		end
	end
	return true
end

lionsRockSacrificesTest:id(10551)
lionsRockSacrificesTest:id(23760)
lionsRockSacrificesTest:id(23835)
lionsRockSacrificesTest:register()

-- Get lions mane
local lionsGetLionsMane = Action()

function lionsGetLionsMane.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 23759 then
		if player:getStorageValue(Storage.LionsRock.Questline) > 0 then
			if player:getStorageValue(Storage.LionsRock.GetLionsMane) < 0 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You picked a beautiful lion's mane flower.")
				player:addItem(23760, 1)
				player:setStorageValue(Storage.LionsRock.GetLionsMane, 1)
			end
		end
	end
	return true
end

lionsGetLionsMane:id(23759)
lionsGetLionsMane:register()

-- Get holy water
local lionsGetHolyWater = Action()

function lionsGetHolyWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = ItemUnique[item.uid]
	if not setting then
		return true
	end

	if player:getStorageValue(Storage.LionsRock.Questline) > 0 then
		if player:getStorageValue(Storage.LionsRock.GetHolyWater) < 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You took some holy water from the sacred well.')
			player:addItem(23835, 1)
			player:setStorageValue(Storage.LionsRock.GetHolyWater, 1)
		end
	end
	return true
end

lionsGetHolyWater:uid(40007)
lionsGetHolyWater:register()

-- Rock translation scroll
local lionsRockTranslationScroll = Action()

function lionsRockTranslationScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local amphoraPos = Position(33119, 32247, 9)
	local amphoraID = 24314
	local amphoraBrokenID = 24315

	local function reset()
		local brokenAmphora = Tile(amphoraPos):getItemById(amphoraBrokenID)
		if brokenAmphora then
			brokenAmphora:transform(amphoraID)
		end
	end

	if player:getStorageValue(Storage.LionsRock.Questline) == 4 then
		local amphora = Tile(amphoraPos):getItemById(amphoraID)
		if amphora then
			amphora:transform(amphoraBrokenID)
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				'As you pass incautiously, the ancient amphora crumbles to shards and dust. \z
				Amidst the debris you discover an old scroll.'
			)
			player:setStorageValue(Storage.LionsRock.Questline, 5)
			player:addItem(23836, 1)
			toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			addEvent(reset, 15 * 1000)
		end
	end
	return true
end

lionsRockTranslationScroll:uid(40008)
lionsRockTranslationScroll:register()

-- Lions rock fountain
local lionsRockFountain = Action()

function lionsRockFountain.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.LionsRock.Time) < os.time() then
		local reward = ''
		if (player:hasMount(40)) then
			repeat
				reward = math.random(1, #rewards)
			until (rewards[reward] ~= "lion's heart")
		else
			reward = math.random(1, #rewards)
		end

		if (player:getStorageValue(Storage.LionsRock.Questline) == 10) then
			player:setStorageValue(Storage.LionsRock.Questline, 11)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"Something sparkles in the fountain's water. You draw out a " .. rewards[reward] .. '.')
		player:sendMagicEffect(CONST_ME_HOLYAREA)
		player:addAchievement("Lion's Den Explorer")
		item:transform(lionsRockSanctuaryRockId)
		player:addItem(rewards[reward], 1)
		player:setStorageValue(Storage.LionsRock.Time, os.time() + 24 * 60 * 60)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		'At the moment there is neither a treasure nor anything else in the fountain. Perhaps you might return later.')
	end
	return true
end

lionsRockFountain:id(6390)
lionsRockFountain:register()
