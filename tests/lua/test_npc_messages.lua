function test_NpcMessages_EmptyConstructor()
    local expectedMessages = {
        reply = "",
        confirmation = "",
        cancellation = "",
        cannotExecute = "",
    }

    local messages = NpcMessages:new()

    lu.assertMessages(messages, expectedMessages)
    lu.assertIsTrue(getmetatable(messages) == NpcMessages)
end

function test_NpcMessages_ConstructorWithParameters()
    local expectedMessages = {
        reply = "Fuck you man!",
        confirmation = "Hmm, you were wise in confirm!",
        cancellation = "You Bastard..",
        cannotExecute = "You're joking, ehn?",
    }

    local messages = NpcMessages:new(expectedMessages)

    lu.assertMessages(messages, expectedMessages)
    lu.assertIsTrue(getmetatable(messages) == NpcMessages)
end