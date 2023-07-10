local lionsRockSanctuaryRockId = 1852

local rewards = {
	'emerald bangle',
	'giant shimmering pearl',
	'gold ingot',
	'green gem',
	'red gem',
	"lion's heart",
	'yellow gem'
}

local tests = {
	{
		storage = Storage.LionsRock.OuterSanctum.LionsStrength,
		itemPosition = {x = 33137, y = 32291, z = 8},
		pagodaPosition = { x = 33134, y = 32289, z = 8},
		item = 9634,
		message = "You have sacrificed a cobra tongue at an ancient statue. The light in the small pyramid nearby begins to shine.",
		effect = CONST_ME_BLOCKHIT
	},
	{
		storage = Storage.LionsRock.OuterSanctum.LionsBeauty,
		itemPosition = {x = 33138, y = 32369, z = 8},
		pagodaPosition = { x = 33136, y = 32369, z = 8},
		item = 21389,
		message = "You burnt a lion's mane flower. The light in the small pyramid nearby begins to shine.",
		effect = CONST_ME_REDSMOKE
	},
	{
		storage = Storage.LionsRock.OuterSanctum.LionsTears,
		itemPosition = {x = 33154, y = 32279, z = 8},
		pagodaPosition = { x = 33156, y = 32279, z = 8},
		item = 21466,
		message = "You have purified a sacret pedestal with holy water. You have now passed the last test\z
		to enter thge inner sanctum.",
		effect = CONST_ME_LOSEENERGY
	}
}

-- Lions rock sacrifices
local lionsRockSacrificesTest = Action()

function lionsRockSacrificesTest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local function reset(setting)
		local pagodaLit = Tile(setting.pagodaPosition):getItemById(2075)
		if pagodaLit then
			pagodaLit:transform(2074)
		end
	end
	local setting
	for a = 1, #tests do
		setting = tests[a]
		if item.itemid == setting.item and target:getPosition() == Position(setting.itemPosition) then
			if player:getStorageValue(setting.storage) < 1 then
				local pagoda = Tile(setting.pagodaPosition):getItemById(2074)
				if pagoda then
					pagoda:transform(2075)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message)
					player:setStorageValue(setting.storage, 1)
					if player:getStorageValue(Storage.LionsRock.Questline) < 1 then
						player:setStorageValue(Storage.LionsRock.Questline, math.max(player:getStorageValue(Storage.LionsRock.Questline), 1))
						player:setStorageValue(Storage.LionsRock.Questline, player:getStorageValue(Storage.LionsRock.Questline) + 1)
					else
						player:setStorageValue(Storage.LionsRock.Questline, player:getStorageValue(Storage.LionsRock.Questline) + 1)
					end
					player:removeItem(setting.item, 1)
					toPosition:sendMagicEffect(setting.effect)
					addEvent(reset, 15 * 1000, setting)
				end
			end
		end
	end
	return true
end

lionsRockSacrificesTest:id(9634, 21389, 21466)
lionsRockSacrificesTest:register()

-- Get lions mane
local lionsGetLionsMane = Action()

function lionsGetLionsMane.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You picked a beautiful lion's mane flower.")
	player:addItem(21389, 1)
	player:setStorageValue(Storage.LionsRock.Questline, math.max(player:getStorageValue(Storage.LionsRock.Questline), 1))
	player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
	item:transform(21935)
	addEvent(function() item:transform(21388) end, 60 * 1000)
	return true
end

lionsGetLionsMane:id(21388)
lionsGetLionsMane:register()

-- Get holy water
local lionsGetHolyWater = Action()

function lionsGetHolyWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You took some holy water from the sacred well.')
	player:addItem(21466, 1)
	player:setStorageValue(Storage.LionsRock.Questline, math.max(player:getStorageValue(Storage.LionsRock.Questline), 1))
	player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
	return true
end

lionsGetHolyWater:position({x = 33137, y = 32351, z = 6})
lionsGetHolyWater:register()

-- Lions rock fountain
local lionsRockFountain = Action()

function lionsRockFountain.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.LionsRock.Time) < os.time() then
		local reward = ''
		if player:hasMount(40) then
			repeat
				reward = math.random(1, #rewards)
			until rewards[reward] ~= "lion's heart"
		else
			reward = math.random(1, #rewards)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"Something sparkles in the fountain's water. You draw out a " .. rewards[reward] .. '.')
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:addAchievement("Lion's Den Explorer")
		item:transform(lionsRockSanctuaryRockId)
		player:addItem(rewards[reward], 1)
		player:setStorageValue(Storage.LionsRock.Time, os.time() + 24 * 60 * 60)
		player:setStorageValue(Storage.LionsRock.Questline, 11)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		'At the moment there is neither a treasure nor anything else in the fountain. Perhaps you might return later.')
	end
	return true
end

lionsRockFountain:id(6389)
lionsRockFountain:register()
