local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local config = {
        [25024] = {
            message = "You found some more feathers on the grass near the wheat. Now you should have enough for an entire cloak.", -- Edron
            storage = ThreatenedDreams.Mission01.Feathers1},
        [25025] = {
            message = "You found some beautiful swan feathers in the dustbin.", -- Darasha in City
            storage = ThreatenedDreams.Mission01.Feathers2},
        [25026] = {
            message = "You found some beautiful swan feathers entangled in the cactus stings.", -- Darashia Nort of City
            storage = ThreatenedDreams.Mission01.Feathers3},
        [25027] = {
            message = "You found some beautiful swan feathers beneath the dragon skull.", -- Darashia Nort + Far of City
            storage = ThreatenedDreams.Mission01.Feathers4},
        [25028] = {
            message = "You found some more feaathers under the dead tree. Now you should have enough for an entire cloak.", -- Darashia Nort + Far of City
            storage = ThreatenedDreams.Mission01.Feathers5}
    }

local swanFeathers = MoveEvent()
function swanFeathers.onStepIn(creature, item, position, fromPosition)
    local feathersFound = config[item.actionid]
	local player = creature:getPlayer()
	if not player then
		return false
	end
    if player:getStorageValue(ThreatenedDreams.Mission01[1]) ~= 13 then
        return true
    end
    if player:getStorageValue(feathersFound.storage) == 1 then
        return true
    end

    if player:getStorageValue(ThreatenedDreams.Mission01.FeathersCount) < 5 then
        player:setStorageValue(ThreatenedDreams.Mission01.FeathersCount, player:getStorageValue(ThreatenedDreams.Mission01.FeathersCount)+1)
        player:addItem(25244, 1)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, feathersFound.message)
        player:setStorageValue(feathersFound.storage, 1)
        if player:getStorageValue(ThreatenedDreams.Mission01.FeathersCount) == 5 then
            player:setStorageValue(ThreatenedDreams.Mission01[1], 14) -- Finish the mission
        end
        return true
    end
end

swanFeathers:aid(25024,25025,25026,25027,25028)
swanFeathers:register()
