local CHANCES = 25
local EMPTY_POT = 306
local SEED_POT = 316
local PLANTS = {
	LizardTongue = { stages = { { 331, 332 }, { 339, 340 } }, done = 14033, withered = 325 },
	DryadsHeart = { stages = { { 333, 334 }, { 341, 342 } }, done = 14034, withered = 326 },
	MidnightBloom = { stages = { { 335, 336 }, { 343, 344 } }, done = 14036, withered = 327 },
	EmberQueen = { stages = { { 337, 338 }, { 345, 346 } }, done = 14035, withered = 328 },
	FingerSnapper = { stages = { { 9069, 9070 }, { 9077, 9078 } }, done = 14038, withered = 9071 },
	FairyDancer = { stages = { { 9073, 9074 }, { 9075, 9076 } }, done = 14037, withered = 9072 },
}
local STAGE1_POOL = {}
for name, plant in pairs(PLANTS) do
	table.insert(STAGE1_POOL, { name = name, id = plant.stages[1][1] })
end

local ITEM_ACTION = {}
ITEM_ACTION[321] = { type = "no_water" }
ITEM_ACTION[324] = { type = "drying1" }
ITEM_ACTION[329] = { type = "drying2" }
ITEM_ACTION[330] = { type = "wilting" }

for name, plant in pairs(PLANTS) do
	for i, stage in ipairs(plant.stages) do
		local growing = stage[1]
		local needsWater = stage[2]
		local nextGrow = (i < #plant.stages) and plant.stages[i + 1][1] or plant.done
		ITEM_ACTION[growing] = { type = "no_water" }
		ITEM_ACTION[needsWater] = { type = "advance", nextGrow = nextGrow, nextFail = growing }
	end
	ITEM_ACTION[plant.done] = { type = "done" }
	ITEM_ACTION[plant.withered] = { type = "recover", recoverTo = plant.stages[1][1] }
end

ITEM_ACTION[14030] = { type = "no_water" }
ITEM_ACTION[14031] = { type = "winterblossom_grow", nextGrow = 14029, nextFail = 14030 }
ITEM_ACTION[14032] = { type = "recover", recoverTo = 14030 }
ITEM_ACTION[14029] = { type = "done" }

local wateringCan = Action()

function wateringCan.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetId = target.itemid
	local action = ITEM_ACTION[targetId]
	local roll = math.random(100)
	local advanced = roll <= CHANCES

	if targetId == EMPTY_POT then
		player:say("You should plant some seeds first.", TALKTYPE_MONSTER_SAY)
		return true
	elseif targetId == SEED_POT then
		if advanced then
			local randomPlant = STAGE1_POOL[math.random(#STAGE1_POOL)]
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(randomPlant.id)
		else
			player:say("Your plant doesn't need water.", TALKTYPE_MONSTER_SAY)
			target:transform(321)
		end
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		return true
	elseif action == nil then
		return true
	elseif action.type == "done" or action.type == "no_water" then
		player:say("Your plant doesn't need water.", TALKTYPE_MONSTER_SAY)
		return true
	elseif action.type == "recover" then
		player:say("You finally remembered to water your plant and it recovered.", TALKTYPE_MONSTER_SAY)
		target:transform(action.recoverTo)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		return true
	elseif action.type == "drying1" then
		if advanced then
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(329)
		else
			player:say("You watered your plant.", TALKTYPE_MONSTER_SAY)
			target:transform(SEED_POT)
		end
		target:decay()
	elseif action.type == "drying2" then
		if advanced then
			local randomPlant = STAGE1_POOL[math.random(#STAGE1_POOL)]
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(randomPlant.id)
		else
			player:say("You watered your plant.", TALKTYPE_MONSTER_SAY)
			target:transform(321)
		end
		target:decay()
	elseif action.type == "wilting" then
		if advanced then
			local randomPlant = STAGE1_POOL[math.random(#STAGE1_POOL)]
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(randomPlant.id)
		else
			player:say("You watered your plant.", TALKTYPE_MONSTER_SAY)
			target:transform(SEED_POT)
		end
		target:decay()
	elseif action.type == "winterblossom_grow" then
		if advanced then
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(action.nextGrow)
			player:addAchievementProgress("Green Thumb", 100)
		else
			player:say("You watered your plant.", TALKTYPE_MONSTER_SAY)
			target:transform(action.nextFail)
		end
		target:decay()
	elseif action.type == "advance" then
		if advanced then
			player:say("Your plant has grown to the next stage!", TALKTYPE_MONSTER_SAY)
			target:transform(action.nextGrow)

			for name, plant in pairs(PLANTS) do
				if action.nextGrow == plant.done then
					player:addAchievementProgress("Green Thumb", 100)
					break
				end
			end
		else
			player:say("You watered your plant.", TALKTYPE_MONSTER_SAY)
			target:transform(action.nextFail)
		end
		target:decay()
	end
	toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	return true
end

wateringCan:id(650)
wateringCan:register()
