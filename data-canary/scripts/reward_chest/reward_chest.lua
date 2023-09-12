local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey) end

-- Create reward chest in the Montag temple
chest:position({ x = 5003, y = 4996, z = 7 }, 19250)

chest:register()
