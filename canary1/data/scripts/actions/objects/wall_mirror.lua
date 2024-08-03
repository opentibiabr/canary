local setting = {
	"You could win a beauty contest today!",
	"You rarely looked better.",
	"Well, you can't look good every day.",
	"You should think about a makeover.",
	"Is that the indication of a potbelly looming under your clothes?",
	"You look irresistible.",
	"You look tired.",
	"You look awesome!",
	"You nearly don't recognize yourself.",
	"You look fabulous.",
	"Surprise, surprise, you don't see yourself.",
}

local wallMirror = Action()

function wallMirror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("delay-wall-mirror") then
		player:say("Don't be so vain about your appearance.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:say(setting[math.random(1, #setting)], TALKTYPE_MONSTER_SAY)
	player:setExhaustion("delay-wall-mirror", 20 * 60 * 60)
	return true
end

wallMirror:id(2603, 2604, 2630, 2631, 2633, 2634, 2636, 2637)
wallMirror:register()
