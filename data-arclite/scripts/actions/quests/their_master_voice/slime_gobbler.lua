local slimeGobbler = Action()
function slimeGobbler.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    return Gobbler_onUse(player, item, fromPosition, target, toPosition, isHotkey)
end

slimeGobbler:id(12077)
slimeGobbler:register()