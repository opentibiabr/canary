local actions_falcon_oberon_lever = Action()

function actions_falcon_oberon_lever.onUse(player, item, fromPosition, itemEx, toPosition)
	local bossName = "Grand Master Oberon"
	local playersTable = {}
	local fromPosition_ = Position(33356, 31311, 9)
	local toPosition_ = Position(33376, 31328, 9)
	local exitPosition = Position(33297, 31285, 9)

	if item:getId() == 2772 then
		if doCheckBossRoom(player:getId(), bossName, fromPosition_, toPosition_) then
			for i = 33362, 33366, 1 do
				local newpos = Position(i, 31344, 9)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					nplayer:teleportTo(Position(33364, 31322, 9), true)
					nplayer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					table.insert(playersTable, nplayer:getId())
					nplayer:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.OberonTimer, os.time() + 20 * 60 * 60)
				end
			end
			local oberon = Game.createMonster("Grand Master Oberon", Position(33365, 31318, 9))
			if oberon then
				oberon:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.OberonHeal, 0)
			end
			Game.setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.OberonSay, -1)
			Game.createNpc("Oberon's Spite", Position(33361, 31320, 9))
			Game.createNpc("Oberon's Ire", Position(33367, 31320, 9))
			Game.createNpc("Oberon's Bile", Position(33361, 31316, 9))
			Game.createNpc("Oberon's Hate", Position(33367, 31316, 9))
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, fromPosition_, toPosition_, exitPosition)
		end
	end

	return true
end

actions_falcon_oberon_lever:aid(4922)
actions_falcon_oberon_lever:register()
