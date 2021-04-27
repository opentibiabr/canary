-- Lua 5.1 doesn't have support for bitwise operations

function testFlag(set, flag)
    return set % (2*flag) >= flag
end

function setFlag(set, flag)
    if set % (2*flag) >= flag then
        return set
    end
    return set + flag
end

function clearFlag(set, flag)
    if set % (2*flag) >= flag then
        return set - flag
    end
    return set
end