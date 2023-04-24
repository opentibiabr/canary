function EventCallback.onDropLoot(monster, corpse)
	Spdlog.info("CorpseID: ".. corpse:getId())
end

function EventCallback.onDropLoot(monster, corpse)
	Spdlog.info("MonsterName: ".. monster:getName())
end

function EventCallback.onEvent(monster, corpse)
	-- Invalid event
end

local test = TalkAction("/test")

function test.onSay(player, words, param)
end

test:separator(" ")
test:register()
