local flaskBox = Action()

function flaskBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.FlaskBox) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already got the flask.")
		return true
	end

	player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.FlaskBox, 1)
	player:addItem(TwentyYearsACookQuest.TheRestOfRatha.Items.EmptySpiritFlask, 1)
	return true
end

flaskBox:uid(TwentyYearsACookQuest.TheRestOfRatha.FlaskBoxUID)
flaskBox:register()

local emptySpiritFlask = Action()

function emptySpiritFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target and not target:isItem() then
		return true
	end

	if target:getId() == TwentyYearsACookQuest.TheRestOfRatha.Items.GhostItem then
		target:getPosition():sendMagicEffect(CONST_ME_PIXIE_EXPLOSION)
		target:remove()
		item:transform(TwentyYearsACookQuest.TheRestOfRatha.Items.FullSpiritFlask)
	end
end

emptySpiritFlask:id(TwentyYearsACookQuest.TheRestOfRatha.Items.EmptySpiritFlask)
emptySpiritFlask:register()

local fullSpiritFlask = Action()

function fullSpiritFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target and not target:isMonster() then
		return true
	end

	local monster = target:getMonster()

	if not monster then
		return true
	end

	if monster:getName():lower() == "spirit container" then
		local icon = monster:getIcon("spirit-container")
		monster:setIcon("spirit-container", CreatureIconCategory_Quests, CreatureIconQuests_WhiteCross, icon and icon.count + 1 or 1)
		monster:getPosition():sendMagicEffect(CONST_ME_PIXIE_EXPLOSION)
		item:transform(TwentyYearsACookQuest.TheRestOfRatha.Items.EmptySpiritFlask)
		if TwentyYearsACookQuest.TheRestOfRatha.SpiritContainerPoints > 50 then
			local players = TwentyYearsACookQuest.TheRestOfRatha.BossZone:getPlayers()
			for i, player in ipairs(players) do
				player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 5)
			end
		end
	end
end

fullSpiritFlask:id(TwentyYearsACookQuest.TheRestOfRatha.Items.FullSpiritFlask)
fullSpiritFlask:register()
