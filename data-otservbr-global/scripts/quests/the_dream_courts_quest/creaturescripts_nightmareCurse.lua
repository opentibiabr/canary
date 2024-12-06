local spectreTime = 15 * 1000
local phantasmTime = 10 * 1000
local spectre = createConditionObject(CONDITION_OUTFIT)
setConditionParam(spectre, CONDITION_PARAM_TICKS, spectreTime)
addOutfitCondition(spectre, { lookType = 235 })
local phantasm = createConditionObject(CONDITION_OUTFIT)
setConditionParam(phantasm, CONDITION_PARAM_TICKS, phantasmTime)
addOutfitCondition(phantasm, { lookType = 241 })

local function resetArea()
	local spectators = Game.getSpectators(Position(32206, 32045, 15), false, true, 14, 14, 14, 14)

	for _, p in pairs(spectators) do
		local player = Player(p:getId())
		if player then
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse, 0)
		end
	end
end

local creaturescripts_nightmareCurse = CreatureEvent("nightmareCurse")

function creaturescripts_nightmareCurse.onThink(creature, interval)
	if not creature:isPlayer() then
		return true
	end

	local player = Player(creature)
	local stage = player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse)

	if stage == 1 and not player:getCondition(CONDITION_OUTFIT, spectre) then
		doAddCondition(player, spectre)

		addEvent(function(cid)
			local p = Player(cid)

			if p then
				p:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse, 2)
			end
		end, spectreTime, player:getId())
	elseif stage == 2 and not player:getCondition(CONDITION_OUTFIT, phantasm) then
		doAddCondition(player, phantasm)

		addEvent(function(cid)
			local p = Player(cid)

			if p and p:getCondition(CONDITION_OUTFIT, phantasm) then
				resetArea()
				Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.LastBossCurse, 0)
				p:teleportTo(Position(32213, 32083, 15))
				p:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse, -1)
				p:unregisterEvent("nightmareCurse")
			end
		end, phantasmTime, player:getId())
	elseif (stage == 1 or stage == 2) and (player:getCondition(CONDITION_OUTFIT, spectre) or player:getCondition(CONDITION_OUTFIT, phantasm)) then
		addEvent(function(cid)
			local p = Player(cid)

			if p then
				p:getPosition():sendMagicEffect(CONST_ME_SLEEP)
			end
		end, 1 * 1000, player:getId())
	end

	return true
end

creaturescripts_nightmareCurse:register()
