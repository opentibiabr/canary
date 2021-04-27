local items = {
    { description = 'a platinum coins', items = {{ id = ITEM_PLATINUM_COIN, count = 5 }}},
    { description = 'some gems', items = {
        { id = 2146, count = 1 },
        { id = 2149, count = 1 },
        { id = 2147, count = 1 }
    }},
    { description = 'a life ring', items = {{ id = 2205, count = 1 }} },
    { description = 'a red gem', items = {{ id = 2156, count = 1 }} },
    { description = 'a mana potion', items = {{ id = 7589, count = 10 }} },
    { description = 'a health potion', items = {{ id = 7588, count = 8 }} }
}

local adventurersTreasure = Action()
function adventurersTreasure.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.AdventurersGuild.GreatDragonHunt.DragonCounter) >= 50 then
        local treasure = items[math.random(#items)]
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is impossible to take along all of the treasures here. Buy you pick out " .. treasure.description)
        for _, item in ipairs(treasure.items) do 
            player:addItem(item.id, item.count)
        end

        -- reset dragon counter
        player:setStorageValue(Storage.AdventurersGuild.GreatDragonHunt.DragonCounter, 0)

        -- hoard of the dragon achievement
        local achievement = getAchievementInfoByName('Hoard of the Dragon')
        if not achievement or player:hasAchievement(achievement.id) then
            return true
        end

        local times = player:getStorageValue(achievement.actionStorage)
        if times < 10 then
            player:setStorageValue(achievement.actionStorage, times + 1)
        end

        if times + 1 == 10 then
            player:addAchievement(achievement.id)
        end

    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You try to pick a treasure, but you hear further dragons approaching. You should kill some more before picking out something.")
    end

	return true
end

adventurersTreasure:aid(50808)
adventurersTreasure:register()