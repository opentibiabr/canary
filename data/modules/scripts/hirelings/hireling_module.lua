HirelingModule = {}

HirelingModule.Credits = {
	Developer = 'Leonardo "Leu" Pereira (jlcvp)',
	Version = "1.0",
	Date = "30/04/2020 "
}

HirelingModule.S_Packets= { SendOutfitWindow = 0xC8 }

HirelingModule.C_Packets = { RequestChangeOutfit = 0xD2, ConfirmOutfitChange = 0xD3  }

local function getOutfit(msg, version)
	local outfitType = 0
	if(version >= 1220) then
		outfitType = msg:getByte()
	end

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
		msg:getU32() --discard this for some reason maybe it's the hireling id
	end
	return outfit
end

local function parseChangeOutfit(player,msg)
	local hireling = player:getHirelingChangingOutfit()
	local outfit
	local version = player:getClient().version
	if not hireling then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)

		-- deplete msg to avoid setting an hireling outfit to player
		getOutfit(msg,version)
	else
		outfit = getOutfit(msg, version)
		hireling:changeOutfit(outfit)
	end
end

function onRecvbyte(player, msg, byte)
	if (byte == HirelingModule.C_Packets.ConfirmOutfitChange) then
		if not player:isChangingHirelingOutfit() then
			return
		end
		parseChangeOutfit(player, msg)
	end
end
