-- NOTE: Using this script might cause unwanted changes.
-- This script forces a reload in the entire server, this means
-- that everything that is stored in memory might stop to work
-- properly and/or completely.
--
-- This script should be used in test environments only.

local reload = TalkAction("/reload")

function reload.onSay(player, words, param)
	return player:reloadTalkaction(words, param)
end

reload:separator(" ")
reload:register()
