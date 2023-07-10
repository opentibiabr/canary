local storagesTable = {
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarMaliceKilled, bossName = "Goshnar's Malice"},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarHatredKilled, bossName = "Goshnar's Hatred"},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarSpiteKilled, bossName = "Goshnar's Spite"},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarCrueltyKilled, bossName = "Goshnar's Cruelty"},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarGreedKilled, bossName = "Goshnar's Greed"},
}

local portalMegalomania = MoveEvent()
function portalMegalomania.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
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

portalMegalomania:type("stepin")
portalMegalomania:position({x = 33611, y = 31430, z = 10})
portalMegalomania:register()