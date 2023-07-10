local setting = {
	["Monday"] = Position(31254, 32604, 9), --Minos
	["Tuesday"] = Position(33459, 31715, 9), --Catacombs
	["Wednesday"]  = Position(31061, 32605, 9), --Golem
	["Thursday"] = Position(33459, 31715, 9), --Catacombs
	["Friday"]  = Position(33459, 31715, 9), --Catacombs
	["Saturday"] = Position(31254, 32604, 9), --Minos
	["Sunday"] = Position(33459, 31715, 9) --Catacombs
}

local votingOramond = MoveEvent()

function votingOramond.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[os.date("%A")]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
	end
	return true
end

votingOramond:type("stepin")
votingOramond:aid(42628)
votingOramond:register()
