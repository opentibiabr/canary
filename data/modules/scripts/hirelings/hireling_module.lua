HirelingModule = {}

HirelingModule.Credits = {
	Developer = 'Leonardo "Leu" Pereira (jlcvp)',
	Version = "1.0",
	Date = "30/04/2020 ",
}

HirelingModule.S_Packets = { SendOutfitWindow = 0xC8 }

HirelingModule.C_Packets = { RequestChangeOutfit = 0xD2, ConfirmOutfitChange = 0xD3 }

local function getOutfit(msg)
	local outfitType = 0
	outfitType = msg:getByte()

	local outfit = {}
	outfit.lookType = msg:getU16()
	outfit.lookHead = msg:getByte()
	outfit.lookBody = msg:getByte()
	outfit.lookLegs = msg:getByte()
	outfit.lookFeet = msg:getByte()
	outfit.lookAddons = msg:getByte()

	if outfitType == 0 then
		outfit.lookMount = msg:getU16()
	else
		outfit.lookMount = 0x00
		msg:getU32() -- hireling id
	end
	return outfit
end

local function parseChangeOutfit(player, msg)
	local hireling = player:getHirelingChangingOutfit()
	local outfit
	if not hireling then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		getOutfit(msg)
	else
		outfit = getOutfit(msg)
		hireling:changeOutfit(outfit)
	end
end

function onRecvbyte(player, msg, byte)
	if byte == HirelingModule.C_Packets.RequestChangeOutfit then
		local targetType = msg:getByte()
		if targetType == 0 then
			player:sendOutfitWindow()
			return
		end

		local hirelingCid = msg:getU32()
		local hireling = getHirelingByCid(hirelingCid)
		if not hireling or not hireling:canTalkTo(player) then
			player:sendOutfitWindow()
			return
		end
		if hireling:getOwnerId() ~= player:getGuid() then
			player:sendCancelMessage(RETURNVALUE_NOTOWNHIRELING)
			return
		end

		HIRELING_OUTFIT_CHANGING[player:getGuid()] = hireling:getId()
		player:sendHirelingOutfitWindow(hireling)
	elseif byte == HirelingModule.C_Packets.ConfirmOutfitChange then
		if not player:isChangingHirelingOutfit() then
			return
		end
		parseChangeOutfit(player, msg)
	end
end
