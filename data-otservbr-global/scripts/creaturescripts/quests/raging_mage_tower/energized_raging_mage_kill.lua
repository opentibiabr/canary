local energizedRagingMageKill = CreatureEvent("EnergizedRagingMageKill")
function energizedRagingMageKill.onKill(player, creature, damage, flags)
	if not creature or not creature:isMonster() then
		return true
	end

	if creature:getName():lower() ~= "energized raging mage" then
		return true
	end

	if getGlobalStorageValue(673003) < 2000 then
		return true
	end

	local monster = Game.createMonster("Raging Mage", creature:getPosition())
	monster:setReward(true)

	doCreatureSayWithRadius(player, "GNAAAAAHRRRG!! WHAT? WHAT DID YOU DO TO ME!! I... I feel the energies crawling away... from me... DIE!!!", TALKTYPE_ORANGE_1, 35, 71)
	setGlobalStorageValue(673003, 0)

	return true
end

energizedRagingMageKill:register()
