local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local targetPlayer = Player(variant:getString()) or player
	local guest = targetPlayer:getTile():getHouse()
	local owner = player:getTile():getHouse()

	-- Owner kick yourself from house
	if targetPlayer == player then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(owner:getExitPosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if not owner:canEditAccessList(GUEST_LIST, player) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not owner or not guest or not guest:kickPlayer(player, targetPlayer) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	return true
end

spell:name("House Kick")
spell:words("alana sio")
spell:hasParams(true)
spell:hasPlayerNameParam(true)
spell:isAggressive(false)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_KICK_GUEST)
spell:register()
