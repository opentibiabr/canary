function EventCallback.onDropLoot(monster, corpse)
	return corpse
end

function EventCallback.onDropLoot(monster, corpse)
	return corpse
end

function EventCallback.onGainExperience(player, target, exp, rawExp)
	return exp
end

function EventCallback.onSpawn(monster, position)
	return monster
end

local test = TalkAction("/test")

function test.onSay(player, words, param)
end

test:separator(" ")
test:register()
