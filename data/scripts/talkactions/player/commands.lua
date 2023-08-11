local commands = TalkAction("!commands")

function commands.onSay(player, words, param)
	local allTalkActions = Game.getTalkActions()
	local playerGroupId = player:getGroup():getId()

	local text = "Available commands:\n"

	for _, talkaction in pairs(allTalkActions) do
		if talkaction:getGroupType() ~= 0 then
			if talkaction:getGroupType() <= playerGroupId then
				text = text .. talkaction:getName() .. "\n"
			end
		end
	end

	player:showTextDialog(639, text)

	return true
end

commands:groupType("normal")
commands:register()
