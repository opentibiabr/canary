local commands = TalkAction("!commands")

function commands.onSay(player, words, param)
	local allTalkActions = Game.getTalkActions()
	local playerGroupId = player:getGroup():getId()

	local text = "Available commands:\n"

	for _, talkaction in pairs(allTalkActions) do
		if talkaction:getGroupType() ~= 0 then
		print("group type ".. talkaction:getGroupType())
		print("talk name ".. talkaction:getName())
		if talkaction:getGroupType() <= playerGroupId then
			text = text .. talkaction:getName() .. "\n"
		end
	end
	end

	player:showTextDialog(639, text)
end

commands:register()
