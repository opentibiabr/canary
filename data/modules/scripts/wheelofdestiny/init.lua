function onRecvbyte(player, msg, byte)
    if not(WheelOfDestinySystem.config.enabled) then
        return
    end

    WheelOfDestinySystem.parsePacket(player, msg, byte)
end