local actions_dipthrah_signs_doors = Action()

local questSteps = {
	[40032] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign1,
	[40033] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign2,
	[40034] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign3,
	[40035] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign4,
	[40036] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign5,
	[40037] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign6,
	[40038] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign7,
	[40039] = Storage.Quest.U7_4.TheAncientTombs.Diprath_sign8,
}

local function hasCompletedPreviousStep(player, currentStep)
	if currentStep == Storage.Quest.U7_4.TheAncientTombs.Diprath_sign1 then
		return true
	end

	local previousStep = currentStep - 1
	return player:getStorageValue(previousStep) == 1
end

function actions_dipthrah_signs_doors.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local aid = item.actionid
	local currentStorageKey = questSteps[aid]

	if not currentStorageKey then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid action ID.")
		return false
	end

	if not hasCompletedPreviousStep(player, currentStorageKey) then
		return true
	end

	if player:getStorageValue(currentStorageKey) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already completed this step.")
		return true
	end

	player:setStorageValue(currentStorageKey, 1)

	return true
end

for aid in pairs(questSteps) do
	actions_dipthrah_signs_doors:aid(aid)
end

actions_dipthrah_signs_doors:register()
