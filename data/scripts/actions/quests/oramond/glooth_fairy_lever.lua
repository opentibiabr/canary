local function removeBosst(fromArea1, fromArea2, bossName)
	for x = fromArea1.x, fromArea2.x do
		for y = fromArea1.y, fromArea2.y do
			for z = fromArea1.z, fromArea2.z do
				if(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid > 0) then
					if(isMonster(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid)) then
						if(string.lower(getCreatureName(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid)) == bossName) then
						doRemoveCreature(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid)
						end
					end
				end
			end
		end
	end
	return true
end

local function teleportAllPlayersFromAreat(fromArea1, fromArea2, toPos)
	for x = fromArea1.x, fromArea2.x do
		for y = fromArea1.y, fromArea2.y do
			for z = fromArea1.z, fromArea2.z do
				if(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid > 0) then
					if(isPlayer(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid)) then
					doTeleportThing(getTopCreature({x = x, y = y, z = z, stackpos = 255}).uid, toPos)
					doSendMagicEffect(toPos, CONST_ME_TELEPORT)
					end
				end
			end
		end
	end
	return true
end

local function PrepareEnter()
	removeBosst({x=33679,y=31919,z=9}, {x=33701,y=31941,z=9}, "glooth fairy")
	teleportAllPlayersFromAreat({x=33659,y=31935,z=9},{x=33668,y=31939,z=9},{x=33684,y=31935,z=9})
	Game.createMonster("Glooth Fairy", {x=33688,y=31937,z=9})
end

local oramondGloothLever = Action()
function oramondGloothLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9827 then
		if getGlobalStorageValue(18081) >= os.time() then
			doPlayerSendTextMessage(player, 19, "You need to wait 15 minutes to use again.")
			return true
		end

		local specs, spec = Game.getSpectators({x=33688,y=31932,z=9}, false, false, 13, 13, 13, 13)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
				return true
			end
			spec:remove()
		end
		setGlobalStorageValue(18081, os.time()+15*60)
		player:say("Everyone in this place will be teleported into Glooth Fairy\'s hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
		addEvent(PrepareEnter,60*1000)

	end

	item:transform(item.itemid == 9827 and 9828 or 9827)
	return true
end

oramondGloothLever:uid(1020)
oramondGloothLever:register()