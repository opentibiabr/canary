local storagesTable = {
	{ storage = Storage.Quest.U12_40.SoulWar.MurcionKilled, bossName = "Murcion" },
	{ storage = Storage.Quest.U12_40.SoulWar.VemiathKilled, bossName = "Vemiath" },
	{ storage = Storage.Quest.U12_40.SoulWar.ChagorzKilled, bossName = "Chagorz" },
	{ storage = Storage.Quest.U12_40.SoulWar.IchgahalKilled, bossName = "Ichgahal" },
}

local portalBakragore = MoveEvent()
function portalBakragore.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 500 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 500 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	local text = ""
	for value in pairs(storagesTable) do
		if player:getStorageValue(storagesTable[value].storage) < 0 then
			text = text .. "\n" .. storagesTable[value].bossName
		end
	end
	if text == "" then
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to defeat:" .. text)
		player:teleportTo(fromPosition, true)
		return false
	end
end

portalBakragore:type("stepin")
portalBakragore:position({x = 34106, y = 32053, z = 13})
portalBakragore:register()
