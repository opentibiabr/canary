local xRay = {
	{x = 32764, y = 31758, z = 10},
	{x = 32765, y = 31758, z = 10},
	{x = 32766, y = 31758, z = 10},
	{x = 32764, y = 31759, z = 10},
	{x = 32765, y = 31759, z = 10},
	{x = 32766, y = 31759, z = 10},
	{x = 32764, y = 31760, z = 10},
	{x = 32765, y = 31760, z = 10},
	{x = 32766, y = 31760, z = 10},
	{x = 32764, y = 31761, z = 10},
	{x = 32765, y = 31761, z = 10},
	{x = 32766, y = 31761, z = 10},
	{x = 32764, y = 31762, z = 10},
	{x = 32765, y = 31762, z = 10},
	{x = 32766, y = 31762, z = 10},
	{x = 32764, y = 31763, z = 10}, -- Endline
	{x = 32765, y = 31763, z = 10},
	{x = 32766, y = 31763, z = 10},
	{x = 32767, y = 31763, z = 10}
}

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(2000)
condition:setOutfit({lookType = 33}) -- skeleton looktype

local taskXRay = MoveEvent()

function taskXRay.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    for a = 1, #xRay do
        if player:getPosition() == Position(xRay[a]) and player:getStorageValue(Storage.BigfootBurden.QuestLine) ==8 then
            player:addCondition(condition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            if a >= 16 then
                player:setStorageValue(Storage.BigfootBurden.QuestLine, 10)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been succesfully g-rayed. Now let Doctor Gnomedix inspect your ears!")
            end
        end
    end
    return true
end

for b = 1, #xRay do
    taskXRay:position(xRay[b])
end
taskXRay:register()
