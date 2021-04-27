local setting = {
	centerRoom = {x = 33364, y = 31318, z = 9},
	storage = Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer,
	Pillar1pos = {x = 33361, y = 31316, z = 9},
	bossPosition = {x = 33364, y = 31317, z = 9},
	kickPosition = {x = 33300, y = 31289, z = 9},
	playerTeleport = {x = 33364, y = 31322, z = 9}
}

local oberonLever = Action()

-- Start Script
function oberonLever.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 and item.actionid == 57605 then
	local clearOberonRoom = Game.getSpectators(Position(setting.centerRoom), false, false, 10, 10, 10, 10)       
	for index, spectatorcheckface in ipairs(clearOberonRoom) do
		if spectatorcheckface:isPlayer() then
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting against the boss! You need wait awhile.")
			return false
		end
	end	
	for index, removeOberon in ipairs(clearOberonRoom) do
		if (removeOberon:isMonster()) then
			removeOberon:remove()
		end
	end
		Game.createMonster("Grand Master Oberon", setting.bossPosition, false, true)
		Game.createMonster("Oberon's Bile", Position({x = setting.Pillar1pos.x, y = setting.Pillar1pos.y, z = setting.Pillar1pos.z}), false, true)
		Game.createMonster("Oberon's Hate", Position({x = setting.Pillar1pos.x + 6, y = setting.Pillar1pos.y, z = setting.Pillar1pos.z}), false, true)
		Game.createMonster("Oberon's Spite", Position({x = setting.Pillar1pos.x, y = setting.Pillar1pos.y + 4, z = setting.Pillar1pos.z}), false, true)
		Game.createMonster("Oberon's Ire", Position({x = setting.Pillar1pos.x + 6, y = setting.Pillar1pos.y + 4, z = setting.Pillar1pos.z}), false, true)
	local players = {}
	for i = 0, 4 do
		local player1 = Tile({x = (Position(item:getPosition()).x - 2) + i, y = Position(item:getPosition()).y + 1, z = Position(item:getPosition()).z}):getTopCreature()
		players[#players+1] = player1
	end
		for i, player in ipairs(players) do
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(Position(setting.playerTeleport), false)
			doSendMagicEffect(player:getPosition(), CONST_ME_TELEPORT)
			setPlayerStorageValue(player,setting.storage, os.time() + 20 * 60 * 60)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have 20 minute(s) to defeat the boss.')
				addEvent(function()
					local spectatorsOberon = Game.getSpectators(Position(setting.centerRoom), false, false, 10, 10, 10, 10)
						for u = 1, #spectatorsOberon, 1 do
							if spectatorsOberon[u]:isPlayer() and (spectatorsOberon[u]:getName() == player:getName()) then
								player:teleportTo(Position(setting.kickPosition))
								player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Time is over.')
							end
						end
				end, 20 * 60 * 1000)
		end
	end
	return true
end

oberonLever:aid(57605)
oberonLever:register()
