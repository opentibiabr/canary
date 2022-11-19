local TheHuntForTheSeaSerpent = Storage.Quest.U8_2.TheHuntForTheSeaSerpent
local bait = Action()

function bait.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) == 1 then
		if target.itemid == 3496 then -- crane
			if player:getStorageValue(TheHuntForTheSeaSerpent.Bait) == 1 then
				player:say("The bait is already set. Go up to the lookout and check the telescope!", TALKTYPE_MONSTER_SAY)
			else
				item:remove(1)
				toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
				player:setStorageValue(TheHuntForTheSeaSerpent.Bait, 1)
			end
		end
	end
	return true
end

bait:id(939)
bait:register()

local words = {
	phase = {
		"dot",
		"a dot",
		"a shadow",
		"a huge shadow"},
	direction = {
		" straight ahead of you",
		". It is to the starboard side",
		". It is on the larboard side"}}
local telescope = Action()

function telescope.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) == 1 then
		local randBait, randAppear, randPhase, randDirection, phase, direction
		randBait = math.random(2) -- 50% bait loss ratio
		if player:getStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch) == 1 then
			randAppear = math.random(10) -- 90%/10% nothing/success ratio
		else
			randAppear = math.random(9) -- always nothing
		end
		if player:getStorageValue(TheHuntForTheSeaSerpent.Bait) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You should set a new bait first.")
		elseif player:getStorageValue(TheHuntForTheSeaSerpent.Direction) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Oops! You lost it.")
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		elseif randAppear <= 4 then -- 40% nothing
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You see water as far as the eye can reach. No sea serpent in sight.")
		else
			if randAppear >= 5 and randAppear <= 8 then -- 40% nothing
				randPhase = math.random(#words.phase)
				randDirection = math.random(#words.direction)
				phase = words.phase[randPhase]
				direction = words.direction[randDirection]
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You see %s under the surface%s.", phase, direction))
				player:setStorageValue(TheHuntForTheSeaSerpent.Direction, randDirection)
				if randBait == 2 then
					player:setStorageValue(TheHuntForTheSeaSerpent.Bait, 0)
				end
			elseif randAppear == 9 then -- 10% nothing
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It's getting away! You should tell the captain to gain speed!")
				player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 4)
				if randBait == 2 then
					player:setStorageValue(TheHuntForTheSeaSerpent.Bait, 0)
				end
			elseif randAppear == 10 then -- 10% success
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There are multiple shadows under the surface. This has to be the right location.")
				Position(31933, 31037, 7):sendMagicEffect(CONST_ME_WATERCREATURE)
				player:setStorageValue(TheHuntForTheSeaSerpent.QuestLine, 2)
				player:setStorageValue(TheHuntForTheSeaSerpent.Access, 1)
			end
		end
	end
	return true
end

telescope:id(938)
telescope:register()
