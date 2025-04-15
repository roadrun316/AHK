#SingleInstance, Force

; Numpad1: dopus.exe 토글 (활성화 ↔ 최소화)
#Numpad1::
    if WinActive("ahk_exe dopus.exe")
        WinMinimize, ahk_exe dopus.exe
    else
        WinActivate, ahk_exe dopus.exe
return

; Numpad2: dopus.exe 무조건 최소화
#Numpad2::
    WinMinimize, ahk_exe dopus.exe
return

; Numpad3: YouTube Music 토글 (활성화 ↔ 숨김)
#Numpad3::
    if WinActive("YouTube Music")
        WinMinimize, YouTube Music
    else
        WinActivate, YouTube Music
return
