local leaveHouse = TalkAction("!leavehouse")

local function checkHouseAccess(hireling)
	--check if owner still have access to the house
	if hireling.active == 0 then return false end

	local house = hireling:getPosition():getTile():getHouse()
	local player = Player(hireling:getOwnerId())
	if not player then
		player = Game.getOfflinePlayer(hireling:getOwnerId())
	end

	if house:getOwnerGuid() == hireling:getOwnerId() then return true end

	-- player is not invited anymore, return to lamp
	Spdlog.info("Returning Hireling:" .. hireling:getName() .. " to owner Inbox")
	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	local lamp = inbox:addItem(HIRELING_LAMP_ID, 1)
	lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
	lamp:setSpecialAttribute(HIRELING_ATTRIBUTE, hireling:getId()) --save hirelingId on item
	player:save()
	hireling.active = 0
	hireling.cid = -1
	hireling:setPosition({x=0,y=0,z=0})

end


local function spawnNPCs()
	Spdlog.info("Spawning Hirelings")
	local hireling
	for i=1,#HIRELINGS do
		hireling = HIRELINGS[i]

		if checkHouseAccess(hireling) then
			hireling:spawn()
		end
	end
end

function leaveHouse.onSay(player, words, param)
	local position = player:getPosition()
	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendCancelMessage("You are not inside a house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendCancelMessage("You are not the owner of this house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	house:setOwnerGuid(0)
	player:sendTextMessage(MESSAGE_LOOK, "You have successfully left your house.")
	position:sendMagicEffect(CONST_ME_POFF)
	return false
end

leaveHouse:separator(" ")
leaveHouse:register()
