local npcName = "Mercador Vip"

local npc_refiller = Action()

function npc_refiller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spawnPosition = player:getPosition()
	local npcCode = Game.createNpc(npcName, spawnPosition)
		if npcCode then
			-- npcCode:sendMagicEffect(CONST_ME_TELEPORT)
			addEvent(function()
				removeNpc()
			end, 5)
		end
	return true
end

removeNpc = function(self)
	local npcTarget = Npc(npcName)
	if npcTarget then
		-- npcTarget:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		npcTarget:remove()
	end
end


npc_refiller:id(10227)
npc_refiller:register()
