local talkaction = TalkAction("/z")

function talkaction.onSay(player, words, param)
	local effectId = tonumber(param)

	if not effectId then
		player:sendCancelMessage("You must enter a numeric effect ID.")
		return true
	end

	if effectId < 0 or effectId > 303 then
		player:sendCancelMessage("Effect ID must be between 0 and 303.")
		return true
	end

	player:getPosition():sendMagicEffect(effectId)
	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
