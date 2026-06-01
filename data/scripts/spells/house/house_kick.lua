local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local targetPlayer = Player(variant:getString()) or player
	local targetTile = targetPlayer:getTile()
	if not targetTile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local guestHouse = targetTile:getHouse()
	local ownerHouse = player:getTile():getHouse()

	if targetPlayer == player then
		if not ownerHouse then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(ownerHouse:getExitPosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if not ownerHouse or not ownerHouse:canEditAccessList(GUEST_LIST, player) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not guestHouse or not guestHouse:kickPlayer(player, targetPlayer) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	return true
end

spell:name("House Kick")
spell:words("alana sio")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "knight;true", "elite knight;true", "paladin;true", "royal paladin;true", "sorcerer;true", "master sorcerer;true", "monk;true", "exalted monk;true")
spell:level(8)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:hasParams(true)
spell:hasPlayerNameParam(true)
spell:isAggressive(false)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_KICK_GUEST)
spell:register()
