function test_NpcTopic_EmptyConstructor()
    local expectedTopic = {
        current = 0,
        previous = nil
    }

    local topic = NpcTopic:new()

    lu.assertTopic(topic, expectedTopic)
    lu.assertIsTrue(getmetatable(topic) == NpcTopic)
end

function test_NpcTopic_ConstructorWithParameters()
    local expectedTopic = {
        current = 1321,
        previous = 999999
    }

    local topic = NpcTopic:new(expectedTopic)

    lu.assertTopic(topic, expectedTopic)
    lu.assertIsTrue(getmetatable(topic) == NpcTopic)
end