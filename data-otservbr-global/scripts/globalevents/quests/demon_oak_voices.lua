local questArea = {
	Position(32706, 32345, 7),
	Position(32725, 32357, 7)
}

local sounds = {
	'Release me and you will be rewarded greatefully!',
	'What is this? Demon Legs lying here? Someone might have lost them!',
	'I\'m trapped, come here and free me fast!!',
	'I can bring your beloved back from the dead, just release me!',
	'What a nice shiny golden armor. Come to me and you can have it!',
	'Find a way in here and release me! Pleeeease hurry!',
	'You can have my demon set, if you help me get out of here!'
}

local demonOakVoices = GlobalEvent("demon oak voices")
function demonOakVoices.onThink(interval, lastExecution)
	local spectators, spectator = Game.getSpectators(DEMON_OAK_POSITION, false, true, 0, 15, 0, 15)
	local sound = sounds[math.random(#sounds)]
	for i = 1, #spectators do
		spectator = spectators[i]
		if isInRange(spectator:getPosition(), questArea[1], questArea[2]) then
			return true
		end
		spectator:say(sound, TALKTYPE_MONSTER_YELL, false, 0, DEMON_OAK_POSITION)
	end
	return true
end


demonOakVoices:interval(15000)
demonOakVoices:register()
