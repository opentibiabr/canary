local storageGet = TalkAction("/getkv")

function storageGet.onSay(player, words, param)
	local value = kv.get(param)
	if value then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. param .. "]: " .. PrettyString(value))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Key " .. param .. " not found.")
	end
end

storageGet:separator(" ")
storageGet:groupType("god")
storageGet:register()

local talkaction = TalkAction("/setkv")

local function splitFirst(str, delimiter)
	local start, finish = string.find(str, delimiter)
	if start == nil then
		return str, nil
	end
	local firstPart = string.sub(str, 1, start - 1)
	local secondPart = string.sub(str, finish + 1)
	return firstPart, secondPart
end

function talkaction.onSay(player, words, param)
	local key, value = splitFirst(param, " ")
	value = load("return " .. value)()
	kv.set(key, value)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. key .. "] = " .. PrettyString(value))
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
