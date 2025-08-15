function Creature:onTargetCombat(target)
	if not self then
		return true
	end

	if (target:isMonster() and self:isPlayer() and target:getMaster() == self) or (self:isMonster() and target:isPlayer() and self:getMaster() == target) then
		return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
	end

	if not IsRetroPVP() or PARTY_PROTECTION ~= 0 then
		if self:isPlayer() and target:isPlayer() then
			local party = self:getParty()
			if party then
				local targetParty = target:getParty()
				if targetParty and targetParty == party then
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
				end
			end
		end
	end

	if not IsRetroPVP() or ADVANCED_SECURE_MODE ~= 0 then
		if self:isPlayer() and target:isPlayer() then
			if self:hasSecureMode() then
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
			end
		end
	end

	self:addEventStamina(target)
	return true
end

function Creature:onChangeOutfit(outfit)
	if self:isPlayer() then
		local familiarLookType = self:getFamiliarLooktype()
		if familiarLookType ~= 0 then
			for _, summon in pairs(self:getSummons()) do
				if summon:getType():familiar() then
					if summon:getOutfit().lookType ~= familiarLookType then
						summon:setOutfit({ lookType = familiarLookType })
					end
					break
				end
			end
		end
	end
	return true
end

function Creature:onDrainHealth(attacker, typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	if not self then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	if not attacker then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
end
