TheWayOfTheMonkShrines = {
	{ pos = Position(32454, 32292, 7), name = "Guidance", level = 6, rewards = { item = 50267 } },
	{ pos = Position(32323, 32380, 6), name = "Tranquility", level = 20, rewards = { item = 50271, exp = 2500 } },
	{ pos = Position(32410, 31272, 3), name = "Respect", level = 30, rewards = { exp = 5000, spell = "Mystic Repulse", attack = true } },
	{ pos = Position(32610, 31634, 7), name = "Legacy", level = 40, rewards = { item = 50269, exp = 10000, attack = true } },
	{ pos = Position(32532, 31569, 1), name = "Empathy", level = 50, rewards = { item = 50273, exp = 15000, attack = true } },
	{ pos = Position(32966, 32649, 8), name = "Harmony", level = 70, rewards = { item = 50274, exp = 30000, attack = true } },
	{ pos = Position(32890, 32352, 1), name = "Power", level = 100, rewards = { item = 50272, exp = 60000, attack = true } },
	{ pos = Position(33369, 31155, 8), name = "Knowledge", level = 110, rewards = { exp = 75000, spell = "Forceful Uppercut" } },
	{ pos = Position(32778, 31525, 9), name = "Serenity", level = 150, rewards = { item = 50268, exp = 150000 } },
	{ pos = Position(33842, 31622, 3), name = "Eternity", level = 275, rewards = { exp = 500000, spell = "Focus Harmony" } },
}

local function parseRewards(player, rewardsTable)
	for type, reward in pairs(rewardsTable) do
		if type == "item" then
			player:addItem(reward)
		elseif type == "exp" then
			player:addExperience(reward, true)
		elseif type == "spell" then
			player:learnSpell(reward)
		elseif type == "attack" then
			local currentAttackBonus = player:kv():get("monk-basic-atk-bonus") or 0
			player:kv():set("monk-basic-atk-bonus", currentAttackBonus + 1)
		end
	end
	return true
end

local Shrines = Action()
function Shrines.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, shrine in ipairs(TheWayOfTheMonkShrines) do
		if fromPosition == shrine.pos then
			fromPosition:sendMagicEffect(37)
			item:transform(50244)

			addEvent(function()
				item:transform(50242)
			end, 30 * 1000)

			local shrinesStorage = Storage.Quest.U14_15.TheWayOfTheMonk.ShrinesCount
			if player:getStorageValue(shrinesStorage) ~= index or player:getLevel() < shrine.level then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Three-Fold Path dictates the order of the shrines to visit and when to do this. This is either not the time for this shrine or you are not yet experienced enough to prepare yourself for the gifts of the Merudri.")
				return false
			end

			if player:getVocation():getId() >= 9 then
				parseRewards(player, shrine.rewards)
			else
				local exp = shrine.rewards.exp or 300
				player:addExperience(exp, true)
			end

			player:setStorageValue(shrinesStorage, index + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You honour the ways of the Merudri at the shrine of %s.", shrine.name))
		end
	end
	return true
end

for _, shrine in ipairs(TheWayOfTheMonkShrines) do
	Shrines:position(shrine.pos)
end
Shrines:register()
