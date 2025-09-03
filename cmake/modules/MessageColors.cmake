if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset
        "${Esc}[m"
    )
    set(ColorBold
        "${Esc}[1m"
    )
    set(ColorRed
        "${Esc}[31m"
    )
    set(ColorYellow
        "${Esc}[33m"
    )
    set(ColorGreen
        "${Esc}[32m"
    )

    set(MsgErr
        "${ColorRed}${ColorBold}"
    )
    set(MsgWar
        "${ColorYellow}${ColorBold}"
    )
    set(MsgOk
        "${ColorGreen}${ColorBold}"
    )
    set(MsgClr
        "${ColorReset}"
    )
endif()
