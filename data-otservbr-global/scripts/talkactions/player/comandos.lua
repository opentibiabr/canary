local commands = TalkAction("!commands")
 
function commands.onSay(player, words, param)
    if player then
        local text = 'Comandos disponiveis: \n\n'
        text = text .. '!aol \n'
        text = text .. '!bless \n'
        text = text .. '!buyhouse \n'
        text = text .. '!leavehouse \n'
        text = text .. '!online \n'
        text = text .. '!sellhouse \n'
        text = text .. '!serverinfo \n'
        text = text .. '!tibiatimer \n\n'
        player:showTextDialog(1952, text)
    end
    return false
end
 
commands:register()