; source: https://stackoverflow.com/questions/65457542/change-volume-using-mouse-scroll-wheel-over-taskbar-with-multiple-monitors

SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;--------------------------------------------------------------------
; Change volume using mouse scroll wheel over taskbar
;--------------------------------------------------------------------

#if MouseIsOver("ahk_class Shell_TrayWnd")

WheelUp::
Send {Volume_Up}
return

WheelDown::
Send {Volume_Down}
return

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
