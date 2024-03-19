local effects = {
	{ position = Position(32365, 32236, 7), text = "DP", effect = 57 },
	{ position = Position(32353, 32223, 7), text = "ARENA PVP", effect = 57 },
	{ position = Position(32373, 32236, 7), text = "NPC", effect = 57 },
	{ position = Position(32342, 32220, 7), text = "NPC", effect = 57 },
	{ position = Position(1116, 1092, 7), text = "ENTER", effect = 57 },
	{ position = Position(1114, 1096, 7), text = "EXIT", effect = 57 },
	{ position = Position(32343, 32219, 7), text = "TREINERS", effect = 57 },
}

local animatedText = GlobalEvent("AnimatedText")
function animatedText.onThink(interval)
	for i = 1, #effects do
		local settings = effects[i]
		local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
		if #spectators > 0 then
			if settings.text then
				for i = 1, #spectators do
					spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
				end
			end
			if settings.effect then
				settings.position:sendMagicEffect(settings.effect)
			end
		end
	end
	return true
end

animatedText:interval(4450)
animatedText:register()

local animatedEffects = GlobalEvent("animatedEffects")
function animatedEffects.onThink(interval)
	for i = 1, #effects do
		local settings = effects[i]
		local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
		if #spectators > 0 then
			if settings.effect then
				settings.position:sendMagicEffect(settings.effect)
			end
		end
	end
	return true
end

animatedEffects:interval(1100)
animatedEffects:register()
