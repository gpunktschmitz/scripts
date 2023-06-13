SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;--------------------------------------------------------------------
; Change virtual desktops using mouse scroll wheel over taskbar
;--------------------------------------------------------------------

#if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")

WheelUp::
Send #^{Left}
return

WheelDown::
Send #^{Right}
return

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
