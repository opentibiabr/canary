picIf = {}

local function removeCombatProtection(cid)
	local player = Player(cid)
	if not player then
		return true
	end

	local time = 0
	if player:isMage() then
		time = 10
	elseif player:isPaladin() then
		time = 20
	else
		time = 30
	end

	player:setStorageValue(Storage.combatProtectionStorage, 2)
	addEvent(function(cid)
		local player = Player(cid)
		if not player then
			return
		end

		player:setStorageValue(Storage.combatProtectionStorage, 0)
		player:remove()
	end, time * 1000, cid)
end

local ec = EventCallback

function ec.onTargetCombat(creature, target)
	if not creature then
		return true
	end

	if not picIf[target.uid] then
		if target:isMonster() then
			target:registerEvent("RewardSystemSlogan")
			picIf[target.uid] = {}
		end
	end

	if target:isPlayer() then
		if creature:isMonster() then
			local protectionStorage = target:getStorageValue(Storage.combatProtectionStorage)

			if target:getIp() == 0 then -- If player is disconnected, monster shall ignore to attack the player
				if target:isPzLocked() then return true end
				if protectionStorage <= 0 then
					addEvent(removeCombatProtection, 30 * 1000, target.uid)
					target:setStorageValue(Storage.combatProtectionStorage, 1)
				elseif protectionStorage == 1 then
					creature:searchTarget()
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
				end

				return true
			end

			if protectionStorage >= os.time() then
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
			end
		end
	end

	if ((target:isMonster() and creature:isPlayer() and target:getMaster() == creature)
	or (creature:isMonster() and target:isPlayer() and creature:getMaster() == target)) then
		return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
	end

	if PARTY_PROTECTION ~= 0 then
		if creature:isPlayer() and target:isPlayer() then
			local party = creature:getParty()
			if party then
				local targetParty = target:getParty()
				if targetParty and targetParty == party then
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
				end
			end
		end
	end

	if ADVANCED_SECURE_MODE ~= 0 then
		if creature:isPlayer() and target:isPlayer() then
			if creature:hasSecureMode() then
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
			end
		end
	end

	creature:addEventStamina(target)
	return true
end

ec:register(--[[0]])
