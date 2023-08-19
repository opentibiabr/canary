local test = TalkAction("/test")

function test.onSay(player, words, param)
	Spdlog.info("Testing talkaction")
	for i = 1, 300 do
		local msgTest = "Message number: " .. i
		Spdlog.info(msgTest)
		Webhook.sendMessage("Broadcast test", msgTest, WEBHOOK_COLOR_WARNING)
	end

	return true
end

test:groupType("god")
test:register()
