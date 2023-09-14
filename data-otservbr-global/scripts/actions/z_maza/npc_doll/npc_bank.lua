local npcName = "Naji Vip"

local npc_bank = Action()

function npc_bank.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spawnPosition = player:getPosition()
	local npcCode = Game.createNpc(npcName, spawnPosition)
		if npcCode then
			-- npcCode:sendMagicEffect(CONST_ME_TELEPORT)
			addEvent(function()
				removeNpc()
			end, 5000)
		end
	return true
end

removeNpc = function(self)
	local npcTarget = Npc(npcName)
	if npcTarget then
		npcTarget:doRemoveNpc()
	end
end


npc_bank:id(43863)
npc_bank:register()

