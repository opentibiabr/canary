local config = { -- Ref: https://www.tibiawiki.com.br/wiki/Threatened_Dreams_Quest#Troubled_Animals
    storages = { -- Positions https://www.tibiawiki.com.br/images/3/30/WinterUp9.png
        [50301] = "You found some more feathers on the grass near the wheat. Now you should have enough for an entire cloak.", -- Edron
        [50302] = "You found some beautiful swan feathers in the dustbin.", -- Darasha in City
        [50303] = "You found some beautiful swan feathers entangled in the cactus stings.", -- Darashia Nort of City
        [50304] = "You found some beautiful swan feathers beneath the dragon skull.", -- Darashia Nort + Far of City
        [50305] = "You found some more feaathers under the dead tree. Now you should have enough for an entire cloak." -- Darashia Nort + Far + Far of City
    }
}

local swanFeathers = MoveEvent()

function swanFeathers.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

    if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 15) then
        if (player:getStorageValue(Storage.ThreatenedDreams.TatteredSwanFeathers) <= 5) then
            if (player:getStorageValue(item.actionid) == 1) then
                player:sendCancelMessage("You have already completed this mission.")
            else
                player:addItem(28605, 1)
                player:setStorageValue(item.actionid, 1)
                player:setStorageValue(Storage.ThreatenedDreams.TatteredSwanFeathers, player:getStorageValue(Storage.ThreatenedDreams.TatteredSwanFeathers)+1)
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.storages[item.actionid])
                if (player:getStorageValue(Storage.ThreatenedDreams.TatteredSwanFeathers) == 5) then
                    player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01, 13) -- Finish the mission
                end
            end
        else
            player:sendCancelMessage("You have already completed this mission.")
        end
    else
        player:sendCancelMessage("You are not on that mission.")
    end
	return true
end

swanFeathers:aid(50301,50302,50303,50304,50305)
swanFeathers:register()