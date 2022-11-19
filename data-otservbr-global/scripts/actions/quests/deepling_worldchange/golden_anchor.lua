
local anchorIds = {13941, 13942}
local navigatorNpc = Position(33640, 31379, 9)
local goldenAnchorTeleport = Action()

function goldenAnchorTeleport.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
    if not creature:isPlayer() then
        return
    end

    if target and table.contains(anchorIds, target.itemid) then
        creature:teleportTo(navigatorNpc)
        navigatorNpc:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

	return true
end

goldenAnchorTeleport:id(14019)
goldenAnchorTeleport:register()