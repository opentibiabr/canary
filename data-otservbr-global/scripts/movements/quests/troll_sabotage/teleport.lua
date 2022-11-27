local function boots(player, item, fromPosition, position)
	local bootsItem = player:getSlotItem(CONST_SLOT_FEET)
	if not bootsItem then
		player:teleportTo(position)
		player:say("You don't dare jump over the gap.", TALKTYPE_MONSTER_SAY)
		return true
	end
	if bootsItem and bootsItem.itemid == 3079 then
		if fromPosition == config[4] then
			if player:getStorageValue(Storage.Quest.U8_2.TrollSabotage.JumpTimer) < os.time() then
				player:teleportTo(position)
				player:say("You don't dare jump over the gap.", TALKTYPE_MONSTER_SAY)
				return true
			end
			player:teleportTo(Position(33231, 31759, 2))
			Position(33231, 31762, 2):sendMagicEffect(CONST_ME_POFF)
			Position(33231, 31761, 2):sendMagicEffect(CONST_ME_POFF)
			Position(33231, 31760, 2):sendMagicEffect(CONST_ME_POFF)
			return true
		else
			player:teleportTo(Position(33231, 31763, 2))
			Position(33231, 31762, 2):sendMagicEffect(CONST_ME_POFF)
			Position(33231, 31761, 2):sendMagicEffect(CONST_ME_POFF)
			Position(33231, 31760, 2):sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
end

local function helmet(player, item, fromPosition, position)
	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if not headItem then
		player:teleportTo(position)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if isInArray({5460, 11585, 13995}, headItem.itemid) then
		if fromPosition == config[1] or fromPosition == config[2] then
			player:teleportTo(Position(33247, 31771, 8))
			player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
			return true
		else
			player:teleportTo(Position(33228, 31771, 9))
			player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
			return true
		end
	end
end

config = {
[1] = Position(33234, 31748, 7),
[2] = Position(33234, 31749, 7),
[3] = Position(33241, 31772, 8),
[4] = Position(33231, 31762, 2),
[5] = Position(33231, 31760, 2),
}

local teleport = MoveEvent()

function teleport.onStepIn(player, item, fromPosition, position, target)
	if not player then
		return true
	end
	if fromPosition == Position(33231, 31765, 2) then
		player:setStorageValue(Storage.Quest.U8_2.TrollSabotage.JumpTimer, os.time() + 1)
	end
	for i = 1, #config do
		if fromPosition == config[i] and i < 4 then
			helmet(player, item, fromPosition, position)
			return true
		elseif fromPosition == config[i] and i > 3 then
			boots(player, item, fromPosition, position)
			return true
		end
	end
end

teleport:type("stepin")
teleport:aid(50365)
teleport:register()
