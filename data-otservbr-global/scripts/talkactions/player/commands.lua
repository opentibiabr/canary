local commands = TalkAction("!commands")

function commands.onSay(player, words, param)
	local talkActionsWords = Game.getTalkActionsWords()
	local filteredTalkActions = {}
	local group = player:getGroup()
	local isGroupGod = group and group:getId() >= GROUP_TYPE_GOD
	if isGroupGod then
		filteredTalkActions = talkActionsWords
	else
		for _, word in ipairs(talkActionsWords) do
			if string.sub(word, 1, 1) == "!" then
				table.insert(filteredTalkActions, word)
			end
		end
	end

	local text = "Available commands:\n"
	for _, talkaction in ipairs(filteredTalkActions) do
		text = text .. talkaction .. "\n"
	end

	player:showTextDialog(639, text)
end

commands:register()
