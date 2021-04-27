local destination = {
	[4121] = {position = Position(32801, 31766, 9), storageValue = 1, needCrystal = true},
	[3220] = {position = Position(32627, 31864, 11), storageValue = 1, needCrystal = true},
	[3128] = {position = Position(33000, 31870, 13), storageValue = 1},
	[3129] = {position = Position(32795, 31762, 10), storageValue = 1},
	[3130] = {position = Position(32864, 31844, 11), storageValue = 1},
	[3131] = {position = Position(32803, 31746, 10), storageValue = 1},
	[3132] = {position = Position(32988, 31862, 9), storageValue = 27}, -- gnomebase alpha
	[3133] = {position = Position(32798, 31783, 10), storageValue = 27}, -- city
	[3134] = {position = Position(32959, 31953, 9), storageValue = 27}, -- golems
	[3135] = {position = Position(33001, 31915, 9), storageValue = 27}, -- back from golems
	[3136] = {position = Position(32904, 31894, 13), storageValue = 27}, -- vulcongras
	[3137] = {position = Position(32979, 31907, 9), storageValue = 27}, -- back from vulcongras
	[3215] = {position = Position(32329, 32172, 9), storageValue = 1, needCrystal = true},
	[3216] = {position = Position(32195, 31182, 8), storageValue = 1, needCrystal = true},
	[3217] = {position = Position(32402, 32816, 6), storageValue = 1, needCrystal = true},
	[3218] = {position = Position(33153, 31833, 10), storageValue = 1, needCrystal = true},
	[3219] = {position = Position(33186, 32385, 8), storageValue = 1, needCrystal = true},
	[3222] = {position = Position(32771, 31800, 10), storageValue = 11, needCrystal = false},
	[3221] = {position = Position(32790, 31795, 10), storageValue = 11, needCrystal = false}
}

local gnomebaseTeleport = MoveEvent()

function gnomebaseTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleportCrystal = destination[item.actionid]
	if not teleportCrystal then
		return
	end

	if player:getStorageValue(Storage.BigfootBurden.QuestLine) < 1 then
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have no idea on how to use this device. Xelvar in Kazordoon might tell you more about it.')
		return false
	end

	if player:getStorageValue(Storage.BigfootBurden.QuestLine) < teleportCrystal.storageValue then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your rank among the Gnomes is too low.")
		return false
	end

	if not teleportCrystal.needCrystal or player:removeItem(18457, 1) then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(teleportCrystal.position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need a teleport crystal in order to use this device.')
	end
	return true
end

gnomebaseTeleport:type("stepin")

for index, value in pairs(destination) do
	gnomebaseTeleport:aid(index)
end

gnomebaseTeleport:register()
