local commands = TalkAction("!commands")

function commands.onSay(player, words, param)
	local allTalkActions = Game.getTalkActions()
	local playerGroupId = player:getGroup():getId()

	local text = "Available commands:\n"

	for _, talkaction in pairs(allTalkActions) do
		print("group type ".. talkaction:getGroupType())
		print("talk name ".. talkaction:getWords())
		if talkaction:getGroupType() <= playerGroupId then
			text = text .. talkaction:getWords() .. "\n"
		end
	end

	player:showTextDialog(639, text)
end

commands:register()
