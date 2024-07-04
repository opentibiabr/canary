local walkedPositions = {}
local lastResetTime = os.time()
local checkTime = false

local function resetWalkedPositions(checkLastResetTime)
	if lastResetTime > os.time() and checkLastResetTime then
		return true
	end

	walkedPositions = {}
	Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn, 0)
	lastResetTime = os.time() + (1 * 60)
end

local pipePositions = {
	Position(33612, 32568, 13),
	Position(33612, 32567, 13),
	Position(33612, 32566, 13),
	Position(33612, 32565, 13),
	Position(33612, 32564, 13),
	Position(33612, 32563, 13),
	Position(33612, 32562, 13),
	Position(33612, 32561, 13),
	Position(33612, 32560, 13),
	Position(33612, 32559, 13),
	Position(33612, 32558, 13),
	Position(33612, 32557, 13),
	Position(33612, 32556, 13),
	Position(33622, 32556, 13),
	Position(33622, 32557, 13),
	Position(33622, 32558, 13),
	Position(33622, 32559, 13),
	Position(33622, 32560, 13),
	Position(33622, 32561, 13),
	Position(33622, 32562, 13),
	Position(33622, 32563, 13),
	Position(33622, 32564, 13),
	Position(33622, 32565, 13),
	Position(33622, 32566, 13),
	Position(33622, 32567, 13),
	Position(33622, 32568, 13),
}

local function sendEnergyEffect()
	for _, position in ipairs(pipePositions) do
		position:sendMagicEffect(CONST_ME_PURPLEENERGY)
		position:sendSingleSoundEffect(SOUND_EFFECT_TYPE_SPELL_GREAT_ENERGY_BEAM)
	end

	return true
end

local facelessBaneStepPositions = MoveEvent()

function facelessBaneStepPositions.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.ResetSteps) == 1 then
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.ResetSteps, 0)
		lastResetTime = os.time()
		resetWalkedPositions(true)
	end

	if not checkTime then
		checkTime = addEvent(resetWalkedPositions, 15 * 1000, false)
	end

	if Game.getStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn) < 1 then
		if #walkedPositions > 0 then
			for _, walkedPos in ipairs(walkedPositions) do
				if walkedPos == position then
					return true
				end
			end
		end

		position:sendSingleSoundEffect(SOUND_EFFECT_TYPE_SPELL_BUZZ)
		position:sendMagicEffect(CONST_ME_YELLOWENERGY)
		table.insert(walkedPositions, position)

		if #walkedPositions == 13 then
			Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn, 1)
			addEvent(resetWalkedPositions, 60 * 1000, true)
			sendEnergyEffect()
			checkTime = nil
		end
	end
	return true
end

local facelessBaneSteps = {
	Position(33615, 32567, 13),
	Position(33613, 32567, 13),
	Position(33611, 32563, 13),
	Position(33610, 32561, 13),
	Position(33611, 32558, 13),
	Position(33614, 32557, 13),
	Position(33617, 32558, 13),
	Position(33620, 32557, 13),
	Position(33623, 32558, 13),
	Position(33624, 32561, 13),
	Position(33623, 32563, 13),
	Position(33621, 32567, 13),
	Position(33619, 32567, 13),
}

for _, pos in ipairs(facelessBaneSteps) do
	facelessBaneStepPositions:position(pos)
end

facelessBaneStepPositions:register()
