local autoBroadcast = GlobalEvent("AutoBroadcast")
function autoBroadcast.onThink(interval, lastExecution)
    local messages = {
    "[VIP]: Consider buying VIP and help our server to succeed.",
    "[WEBSITE]: https://enaraot.com",
	"[STAFF]: Find a list of valid GM/CM/GOD/Tutors in our website!"
}

    Game.broadcastMessage(messages[math.random(#messages)], MESSAGE_EVENT_ADVANCE)
    return true
end

autoBroadcast:interval(720000) --5 minutes
autoBroadcast:register()