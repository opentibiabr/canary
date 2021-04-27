registerMonsterType = {}
setmetatable(registerMonsterType,
{
	__call =
	function(self, mtype, mask)
		for _,parse in pairs(self) do
			parse(mtype, mask)
		end
	end
})

MonsterType.register = function(self, mask)
	return registerMonsterType(self, mask)
end

registerMonsterType.name = function(mtype, mask)
	if mask.name then
		mtype:name(mask.name)
	end
end
registerMonsterType.description = function(mtype, mask)
	if mask.description then
		mtype:nameDescription(mask.description)
	end
end
registerMonsterType.experience = function(mtype, mask)
	if mask.experience then
		mtype:experience(mask.experience)
	end
end
registerMonsterType.raceId = function(mtype, mask)
	if mask.raceId then
		mtype:raceId(mask.raceId)
	end
end
registerMonsterType.Bestiary = function(mtype, mask)
	if mask.Bestiary then
		if mask.Bestiary.race then
			mtype:Bestiaryrace(mask.Bestiary.race)
		end
		if mask.Bestiary.class then
			mtype:Bestiaryclass(mask.Bestiary.class)
		end
		if mask.Bestiary.toKill then
			mtype:BestiarytoKill(mask.Bestiary.toKill)
		end
		if mask.Bestiary.FirstUnlock then
			mtype:BestiaryFirstUnlock(mask.Bestiary.FirstUnlock)
		end
		if mask.Bestiary.SecondUnlock then
			mtype:BestiarySecondUnlock(mask.Bestiary.SecondUnlock)
		end
		if mask.Bestiary.CharmsPoints then
			mtype:BestiaryCharmsPoints(mask.Bestiary.CharmsPoints)
		end
		if mask.Bestiary.Stars then
			mtype:BestiaryStars(mask.Bestiary.Stars)
		end
		if mask.Bestiary.Occurrence then
			mtype:BestiaryOccurrence(mask.Bestiary.Occurrence)
		end
		if mask.Bestiary.Locations then
			mtype:BestiaryLocations(mask.Bestiary.Locations)
		end
	end
end
registerMonsterType.skull = function(mtype, mask)
	if mask.skull then
		mtype:skull(mask.skull)
	end
end
registerMonsterType.outfit = function(mtype, mask)
	if mask.outfit then
		mtype:outfit(mask.outfit)
	end
end
registerMonsterType.maxHealth = function(mtype, mask)
	if mask.maxHealth then
		mtype:maxHealth(mask.maxHealth)
	end
end
registerMonsterType.health = function(mtype, mask)
	if mask.health then
		mtype:health(mask.health)
	end
end
registerMonsterType.maxSummons = function(mtype, mask)
	if mask.maxSummons then
		mtype:maxSummons(mask.maxSummons)
	end
end
registerMonsterType.race = function(mtype, mask)
	if mask.race then
		mtype:race(mask.race)
	end
end
registerMonsterType.manaCost = function(mtype, mask)
	if mask.manaCost then
		mtype:manaCost(mask.manaCost)
	end
end
registerMonsterType.speed = function(mtype, mask)
	if mask.speed then
		mtype:baseSpeed(mask.speed)
	end
end
registerMonsterType.corpse = function(mtype, mask)
	if mask.corpse then
		mtype:corpseId(mask.corpse)
	end
end
registerMonsterType.flags = function(mtype, mask)
	if mask.flags then
		if mask.flags.attackable ~= nil then
			mtype:isAttackable(mask.flags.attackable)
		end
		if mask.flags.convinceable ~= nil then
			mtype:isConvinceable(mask.flags.convinceable)
		end
		if mask.flags.summonable ~= nil then
			mtype:isSummonable(mask.flags.summonable)
		end
		if mask.flags.illusionable ~= nil then
			mtype:isIllusionable(mask.flags.illusionable)
		end
		if mask.flags.hostile ~= nil then
			mtype:isHostile(mask.flags.hostile)
		end
		if mask.flags.healthHidden ~= nil then
			mtype:isHealthHidden(mask.flags.healthHidden)
		end
		if mask.flags.pushable ~= nil then
			mtype:isPushable(mask.flags.pushable)
		end
		if mask.flags.canPushItems ~= nil then
			mtype:canPushItems(mask.flags.canPushItems)
		end
		if mask.flags.rewardBoss then
			mtype:isRewardBoss(mask.flags.rewardBoss)
		end
		if mask.flags.pet then
			mtype:isPet(mask.flags.pet)
		end
		if mask.flags.respawntype or mask.flags.respawnType then
			Spdlog.warn(string.format("[registerMonsterType.flags] - Monster: %s. Deprecated flag 'respawnType', use instead table 'respawnType = { period = RespawnPeriod_t, underground = boolean}'",
				mtype:name()))
		end
		if mask.flags.canPushCreatures ~= nil then
			mtype:canPushCreatures(mask.flags.canPushCreatures)
		end
		if mask.flags.targetDistance then
			mtype:targetDistance(math.max(1, mask.flags.targetDistance))
		end
		if mask.flags.runHealth then
			mtype:runHealth(mask.flags.runHealth)
		end
		if mask.flags.staticAttackChance then
			mtype:staticAttackChance(mask.flags.staticAttackChance)
		end
		if mask.flags.canWalkOnEnergy ~= nil then
			mtype:canWalkOnEnergy(mask.flags.canWalkOnEnergy)
		end
		if mask.flags.canWalkOnFire ~= nil then
			mtype:canWalkOnFire(mask.flags.canWalkOnFire)
		end
		if mask.flags.canWalkOnPoison ~= nil then
			mtype:canWalkOnPoison(mask.flags.canWalkOnPoison)
		end
		if mask.flags.isBlockable ~= nil then
			mtype:isBlockable(mask.flags.isBlockable)
		end
	end
end
registerMonsterType.light = function(mtype, mask)
	if mask.light then
		if mask.light.color then
			local color = mask.light.color
		end
		if mask.light.level then
			mtype:light(color, mask.light.level)
		end
	end
end
registerMonsterType.changeTarget = function(mtype, mask)
	if mask.changeTarget then
		if mask.changeTarget.chance then
			mtype:changeTargetChance(mask.changeTarget.chance)
		end
		if mask.changeTarget.interval then
			mtype:changeTargetSpeed(mask.changeTarget.interval)
		end
	end
end
registerMonsterType.strategiesTarget = function(mtype, mask)
	if mask.strategiesTarget then
		if mask.strategiesTarget.nearest then
			mtype:strategiesTargetNearest(mask.strategiesTarget.nearest)
		end
		if mask.strategiesTarget.health then
			mtype:strategiesTargetHealth(mask.strategiesTarget.health)
		end
		if mask.strategiesTarget.damage then
			mtype:strategiesTargetDamage(mask.strategiesTarget.damage)
		end
		if mask.strategiesTarget.random then
			mtype:strategiesTargetRandom(mask.strategiesTarget.random)
		end
	end
end
registerMonsterType.respawnType = function(mtype, mask)
	if mask.respawnType then
		if mask.respawnType.period then
			mtype:respawnTypePeriod(mask.respawnType.period)
		end
		if mask.respawnType.underground then
			mtype:respawnTypeIsUnderground(mask.respawnType.underground)
		end
	end
end
registerMonsterType.voices = function(mtype, mask)
	if type(mask.voices) == "table" then
		local interval, chance
		if mask.voices.interval then
			interval = mask.voices.interval
		end
		if mask.voices.chance then
			chance = mask.voices.chance
		end
		for k, v in pairs(mask.voices) do
			if type(v) == "table" then
				mtype:addVoice(v.text, interval, chance, v.yell)
			end
		end
	end
end
registerMonsterType.summons = function(mtype, mask)
	if type(mask.summons) == "table" then
		for k, v in pairs(mask.summons) do
			mtype:addSummon(v.name, v.interval, v.chance)
		end
	end
end
registerMonsterType.events = function(mtype, mask)
	if type(mask.events) == "table" then
		for k, v in pairs(mask.events) do
			mtype:registerEvent(v)
		end
	end
end
registerMonsterType.loot = function(mtype, mask)
	if type(mask.loot) == "table" then
		local lootError = false
		for _, loot in pairs(mask.loot) do
			local parent = Loot()
			if loot.name then
				if not parent:setIdFromName(loot.name) then
					lootError = true
				end
			else
				if not isInteger(loot.id) or loot.id < 1 then
					lootError = true
				end
				parent:setId(loot.id)
			end
			if loot.subType or loot.charges then
				parent:setSubType(loot.subType or loot.charges)
			else
    			local lType = ItemType(loot.name and loot.name or loot.id)
				if lType and lType:getCharges() > 1 then
        			parent:setSubType(lType:getCharges())
				end
			end
			if loot.chance then
				parent:setChance(loot.chance)
			end
			if loot.minCount then
				parent:setMinCount(loot.minCount)
			end
			if loot.maxCount then
				parent:setMaxCount(loot.maxCount)
			end
			if loot.aid or loot.actionId then
				parent:setActionId(loot.aid or loot.actionId)
			end
			if loot.text or loot.description then
				parent:setText(loot.text or loot.description)
			end
			if loot.name then
				parent:setNameItem(loot.name)
			end
			if loot.article then
				parent:setArticle(loot.article)
			end
			if loot.attack then
				parent:setAttack(loot.attack)
			end
			if loot.defense then
				parent:setDefense(loot.defense)
			end
			if loot.extraDefense or loot.extraDef then
				parent:setExtraDefense(loot.extraDefense or loot.extraDef)
			end
			if loot.armor then
				parent:setArmor(loot.armor)
			end
			if loot.shootRange or loot.range then
				parent:setShootRange(loot.shootRange or loot.range)
			end
			if loot.unique then
				parent:setUnique(loot.unique)
			end
			if loot.child then
				for _, children in pairs(loot.child) do
					local child = Loot()
					if children.name then
						if not child:setIdFromName(children.name) then
							lootError = true
						end
					else
						if not isInteger(children.id) or children.id < 1 then
							lootError = true
						end
						child:setId(children.id)
					end
					if children.subType or children.charges then
						child:setSubType(children.subType or children.charges)
					else
    					local cType = ItemType(children.name and children.name or children.id)
						if cType and cType:getCharges() > 1 then
        					child:setSubType(cType:getCharges())
						end
					end
					if children.chance then
						child:setChance(children.chance)
					end
					if children.minCount then
						child:setMinCount(children.minCount)
					end
					if children.maxCount then
						child:setMaxCount(children.maxCount)
					end
					if children.aid or children.actionId then
						child:setActionId(children.aid or children.actionId)
					end
					if children.text or children.description then
						child:setText(children.text or children.description)
					end
					if loot.name then
						child:setNameItem(loot.name)
					end
					if children.article then
						child:setArticle(children.article)
					end
					if children.attack then
						child:setAttack(children.attack)
					end
					if children.defense then
						child:setDefense(children.defense)
					end
					if children.extraDefense or children.extraDef then
						child:setExtraDefense(children.extraDefense or children.extraDef)
					end
					if children.armor then
						child:setArmor(children.armor)
					end
					if children.shootRange or children.range then
						child:setShootRange(children.shootRange or children.range)
					end
					if children.unique then
						child:setUnique(children.unique)
					end
					parent:addChildLoot(child)
				end
			end
			mtype:addLoot(parent)
		end
		if lootError then
			Spdlog.warn("[registerMonsterType.loot] - Monster: ".. mtype:name() .. " loot could not correctly be load")
		end
	end
end
registerMonsterType.elements = function(mtype, mask)
	if type(mask.elements) == "table" then
		for _, element in pairs(mask.elements) do
			if element.type and element.percent then
				mtype:addElement(element.type, element.percent)
			end
		end
	end
end
registerMonsterType.reflects = function(mtype, mask)
	if type(mask.reflects) == "table" then
		for _, reflect in pairs(mask.reflects) do
			if reflect.type and reflect.percent then
				mtype:addReflect(reflect.type, reflect.percent)
			end
		end
	end
end
registerMonsterType.heals = function(mtype, mask)
	if type(mask.heals) == "table" then
		for _, heal in pairs(mask.heals) do
			if heal.type and heal.percent then
				mtype:addHealing(heal.type, heal.percent)
			end
		end
	end
end
registerMonsterType.immunities = function(mtype, mask)
	if type(mask.immunities) == "table" then
		for _, immunity in pairs(mask.immunities) do
			if immunity.type and immunity.combat then
				mtype:combatImmunities(immunity.type)
			end
			if immunity.type and immunity.condition then
				mtype:conditionImmunities(immunity.type)
			end
		end
	end
end
registerMonsterType.attacks = function(mtype, mask)
	if type(mask.attacks) == "table" then
		for _, attack in pairs(mask.attacks) do
			mtype:addAttack(readSpell(attack))
		end
	end
end

registerMonsterType.defenses = function(mtype, mask)
	if type(mask.defenses) == "table" then
		if mask.defenses.defense then
			mtype:defense(mask.defenses.defense)
		end
		if mask.defenses.armor then
			mtype:armor(mask.defenses.armor)
		end
		for _, defense in pairs(mask.defenses) do
			if type(defense) == "table" then
				mtype:addDefense(readSpell(defense))
			end
		end
	end
end

function readSpell(incomingLua)
	local spell = MonsterSpell()
	if incomingLua.name then
		if incomingLua.name == "melee" then
			spell:setType("melee")
			if incomingLua.attack and incomingLua.skill then
				spell:setAttackValue(incomingLua.attack, incomingLua.skill)
			end
			if incomingLua.minDamage and incomingLua.maxDamage then
				spell:setCombatValue(incomingLua.minDamage, incomingLua.maxDamage)
			end
			if incomingLua.interval then
				spell:setInterval(incomingLua.interval)
			end
			if incomingLua.effect then
				spell:setCombatEffect(incomingLua.effect)
			end
		else
			spell:setType(incomingLua.name)
			if incomingLua.type then
				if incomingLua.name == "combat" then
					spell:setCombatType(incomingLua.type)
				elseif incomingLua.name == "condition" then
					spell:setConditionType(incomingLua.type)
				else
					Spdlog.warn("[readSpell] - Monster ".. mtype:name() .. ": Loading spell ".. incomingLua.name .. ". Parameter type applies only for condition and combat.")
				end
			end
			if incomingLua.interval then
				spell:setInterval(incomingLua.interval)
			end
			if incomingLua.chance then
				spell:setChance(incomingLua.chance)
			end
			if incomingLua.range then
				spell:setRange(incomingLua.range)
			end
			if incomingLua.duration then
				spell:setConditionDuration(incomingLua.duration)
			end
			if incomingLua.speedChange then
				spell:setConditionSpeedChange(incomingLua.speedChange)
			end
			if incomingLua.target then
				spell:setNeedTarget(incomingLua.target)
			end
			if incomingLua.length then
				spell:setCombatLength(incomingLua.length)
			end
			if incomingLua.spread then
				spell:setCombatSpread(incomingLua.spread)
			end
			if incomingLua.radius then
				spell:setCombatRadius(incomingLua.radius)
			end
			if incomingLua.outfitMonster then
				spell:setOutfitMonster(incomingLua.outfitMonster)
			end
			if incomingLua.outfitItem then
				spell:setOutfitItem(incomingLua.outfitItem)
			end
			if incomingLua.minDamage and incomingLua.maxDamage then
				if incomingLua.name == "combat" or Spell(incomingLua.name) then
					spell:setCombatValue(incomingLua.minDamage, incomingLua.maxDamage)
				else
					local startDamage = 0
					if incomingLua.startDamage then
						startDamage = incomingLua.startDamage
					end
					spell:setConditionDamage(incomingLua.minDamage, incomingLua.maxDamage, startDamage)
				end
			end
			if incomingLua.effect then
				spell:setCombatEffect(incomingLua.effect)
			end
			if incomingLua.shootEffect then
				spell:setCombatShootEffect(incomingLua.shootEffect)
			end
		end

		-- This is for a complex spell, that has combat damage AND some condition
		-- For example scorpions, which attack and cause poison on attack
		if incomingLua.condition then
			if incomingLua.condition.type then
				spell:setConditionType(incomingLua.condition.type)
			end
			if incomingLua.condition.duration then
				spell:setConditionDuration(incomingLua.condition.duration)
			end
			if incomingLua.condition.interval then
				spell:setConditionTickInterval(incomingLua.condition.interval)
			end

			spell:setConditionDamage(incomingLua.condition.totalDamage, incomingLua.condition.totalDamage, 0)
		end
	elseif incomingLua.script then
		spell:setScriptName("monster/" .. incomingLua.script .. ".lua")
		if incomingLua.interval then
			spell:setInterval(incomingLua.interval)
		end
		if incomingLua.chance then
			spell:setChance(incomingLua.chance)
		end
		if incomingLua.minDamage and incomingLua.maxDamage then
			spell:setCombatValue(incomingLua.minDamage, incomingLua.maxDamage)
		end
		if incomingLua.target then
			spell:setNeedTarget(incomingLua.target)
		end
	end

	return spell
end
