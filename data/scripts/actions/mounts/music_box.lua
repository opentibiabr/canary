local config = {
	['dragonling'] = {mountId = 31, tameMessage = 'The wild dragonling will accompany you as a friend from now on.', sound = 'FI?', ACHIEV = "Dragon Mimicry"},
	['draptor'] = {mountId = 6, tameMessage = 'You have tamed the wild draptor.', sound = 'Screeeeeeeeech', ACHIEV = "Scales and Tail"},
	['enraged white deer'] = {mountId = 18, tameMessage = 'You have tamed the deer.', sound = 'bell', ACHIEV = "Friend of Elves"},
	['ironblight'] = {mountId = 29, tameMessage = 'You tamed the ironblight.', sound = 'Plinngggg', ACHIEV = "Magnetised"},
	['magma crawler'] = {mountId = 30, tameMessage = 'The magma crawler will accompany you as a friend from now on.', sound = 'ZzzZzzZzzzZz', ACHIEV = "Way to Hell"},
	['midnight panther'] = {mountId = 5, tameMessage = 'You have tamed the wild panther.', sound = 'Purrrrrrr', ACHIEV = "Starless Night"},
	['wailing widow'] = {mountId = 1, mountName = 'widow queen', tameMessage = 'You have tamed the wailing widow.', sound = 'Sssssssss', ACHIEV = "Spin-Off"},
	['wild horse'] = {mountId = 17, mountName = 'war horse', tameMessage = 'The horse eats the sugar oat and accepts you as its new master.', sound = '*snort*', ACHIEV = "Lucky Horseshoe"},
	['panda'] = {mountId = 19, tameMessage = 'You have tamed the panda.', sound = 'Rrrrr...', ACHIEV = "Chequered Teddy"}
}

local musicBox = Action()

function musicBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if not target:isCreature()
		or not target:isMonster()
		or target:getMaster() then
		return false
	end

	local targetName = target:getName():lower()
	local monsterConfig = config[targetName]
	if not monsterConfig then
		return true
	end

	if player:hasMount(monsterConfig.mountId) then
		player:say('You already tamed a ' .. (monsterConfig.mountName or targetName) .. '.', TALKTYPE_MONSTER_SAY)
		return true
	end

	player:addAchievement('Natural Born Cowboy')
	player:addAchievement(monsterConfig.ACHIEV)
	player:addMount(monsterConfig.mountId)
	player:say(monsterConfig.tameMessage, TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_SOUND_RED)
	target:say(monsterConfig.sound, TALKTYPE_MONSTER_SAY)
	target:remove()
	item:remove()
	return true
end

musicBox:id(18511)
musicBox:register()
