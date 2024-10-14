--[[
4914 = leaving
4915 = entering
--]]

local entrances = {
	[1] = { position = Position(32858, 32795, 11), storage = false, toPosition = Position(32889, 32772, 9) },
	[2] = { position = Position(32857, 32766, 10), fromPos = Position(32856, 32740, 11), toPos = Position(32868, 32752, 11), storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.DiamondTimer, exit = Position(32857, 32768, 10), toPosition = Position(32881, 32789, 11), bossName = "The Diamond Blossom", bossPos = Position(32881, 32792, 11) },
	[3] = { position = Position(32817, 32777, 11), fromPos = Position(32875, 32786, 11), toPos = Position(32887, 32798, 11), storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.DarkTimer, exit = Position(32817, 32779, 11), toPosition = Position(32862, 32743, 11), bossName = "The Lily of Night", bossPos = Position(32862, 32746, 11) },
	[4] = { position = Position(32854, 32737, 10), fromPos = Position(32856, 32768, 11), toPos = Position(32868, 32780, 11), storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.BlazingTimer, exit = Position(32854, 32739, 10), toPosition = Position(32862, 32771, 11), bossName = "The Blazing Rose", bossPos = Position(32862, 32774, 11) },
}

local exites = {
	[1] = { position = Position(32862, 32741, 11), toPosition = Position(32817, 32779, 11) },
	[2] = { position = Position(32862, 32769, 11), toPosition = Position(32854, 32739, 10) },
	[3] = { position = Position(32881, 32787, 11), toPosition = Position(32857, 32768, 10) },
	[4] = { position = Position(32887, 32772, 9), toPosition = Position(32858, 32797, 11) },
	[5] = { position = Position(32880, 32828, 11), toPosition = Position(32810, 32765, 10) },
}

local defaultMessage = "You have ten minutes to kill and loot this monster, else you will lose that chance and will be kicked out."

local function resetRoom(position)
	local spec = Game.getSpectators(position, false, false, 5, 5, 5, 5)
	for _, c in pairs(spec) do
		if c and c:isPlayer() then
			return false
		end
	end
	for _, c in pairs(spec) do
		if c then
			c:remove()
		end
	end
	return true
end

local function startBattle(pid, position, b_name, middle)
	local player = Player(pid)
	if player then
		player:teleportTo(position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say(defaultMessage, TALKTYPE_MONSTER_SAY)
		local monster = Game.createMonster(b_name, middle)
	end
end

local purplePosition = Position(32808, 32765, 10)
local quest = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline
local toPosition_l = Position(32880, 32826, 11)
local hiddenMap = Position(32881, 32819, 11)

local movements_asura_elemental_portals = MoveEvent()

function movements_asura_elemental_portals.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	local player = Player(creature:getId())
	if item.actionid == 4915 then
		if position == purplePosition then
			if player:getStorageValue(quest) >= 5 then
				player:teleportTo(toPosition_l)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this portal yet.")
				player:teleportTo(fromPosition, true)
			end
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		-- for bosses!!
		for _, k in pairs(entrances) do
			if position == k.position then
				if k.storage then
					if resetRoom(k.bossPos) then
						if player:getStorageValue(k.storage) < os.time() then
							player:setStorageValue(k.storage, os.time() + 20 * 60 * 60)
							startBattle(player:getId(), k.toPosition, k.bossName, k.bossPos)
							addEvent(function(cid)
								local p = Player(cid)
								if p then
									if p:getPosition():isInRange(k.fromPos, k.toPos) then
										p:teleportTo(k.exit)
									end
								end
							end, 10 * 1000 * 60, player:getId())
						else
							player:sendCancelMessage("You are still exhausted from your last battle.")
							player:teleportTo(fromPosition, true)
						end
					else
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait. Someone is challenging " .. k.bossName .. " now.")
						player:teleportTo(fromPosition, true)
					end
				else
					player:teleportTo(k.toPosition)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	elseif item.actionid == 4914 then
		if position == hiddenMap then
			if player:getStorageValue(quest) == 5 then
				player:addItem(28908, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have discovered an old writing desk that contains an ancient map.")
				player:setStorageValue(quest, 6)
			end
		end
		for _, k in pairs(exites) do
			if position == k.position then
				player:teleportTo(k.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end
	return true
end

movements_asura_elemental_portals:aid(4914, 4915)
movements_asura_elemental_portals:register()
