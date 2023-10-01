local nextWeaponUpgrade = Action()

function nextWeaponUpgrade.onUse(player, item, fromPosition, target, toPosition, isHotkey)
                                                                                          
    item:remove(1)
    player:setStorageValue(67231, 1)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Next Weapon Training Ativado")
                                                                                           
    return true
end

nextWeaponUpgrade:id(30202)
nextWeaponUpgrade:register()