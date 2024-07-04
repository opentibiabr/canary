local largeSeashell = Action()

function largeSeashell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("delay-large-seashell") then
		player:say("You have already opened a shell today.", TALKTYPE_MONSTER_SAY, false, player, item:getPosition())
		return true
	end

	local chance = math.random(100)
	local message = "Nothing is inside."

	if chance <= 16 then
		doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -200, -200, CONST_ME_NONE)
		message = "Ouch! You squeezed your fingers."
	elseif chance > 16 and chance <= 64 then
		Game.createItem(math.random(281, 282), 1, player:getPosition())
		message = "You found a beautiful pearl."
		player:addAchievementProgress("Shell Seeker", 100)
	end

	player:setExhaustion("delay-large-seashell", 20 * 60 * 60)
	player:say(message, TALKTYPE_MONSTER_SAY, false, player, item:getPosition())
	item:transform(198)
	item:decay()
	item:getPosition():sendMagicEffect(CONST_ME_BUBBLES)
	return true
end

largeSeashell:id(197)
largeSeashell:register()
