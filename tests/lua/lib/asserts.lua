function lu.assertMessages(actual, expected)
    lu.assertEquals(actual.reply, expected.reply)
    lu.assertEquals(actual.confirmation, expected.confirmation)
    lu.assertEquals(actual.cancellation, expected.cancellation)
    lu.assertEquals(actual.cannotExecute, expected.cannotExecute)
end

function lu.assertTopic(actual, expected)
    lu.assertEquals(actual.current, expected.current)
    lu.assertEquals(actual.previous, expected.previous)
end