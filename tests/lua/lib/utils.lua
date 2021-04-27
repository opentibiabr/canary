function msgContains(message, keyword)
    local message, keyword = message:lower(), keyword:lower()
    if message == keyword then
        return true
    end

    return message:find(keyword) and not message:find('(%w+)' .. keyword)
end