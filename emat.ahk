; ===================================================================================================
; EMAT AutoHotkey Script - 애플리케이션 전환 및 자동화 스크립트
; ===================================================================================================

; 중복 실행 방지
#SingleInstance Force
#SingleInstance Off

SendMode Input
SetTitleMatchMode, 2
SetKeyDelay, -1, -1
SetBatchLines, -1

; 창 크기 조절 프리셋
g_WindowSizeStandard := []
g_WindowSizeStandard.Push([1920, 1080])
g_WindowSizeStandard.Push([-1, -1])  ; 전체 화면
g_WindowSizeDock := []
g_WindowSizeDock.Push([1000, 1200])
g_WindowSizeDock.Push(["dockLeft", 1600])  ; 좌측 1600px 도킹
g_WindowSizeDock.Push(["dockRight", 975])  ; 우측 975px 도킹
g_WindowSizeStandardIndex := 0
g_WindowSizeDockIndex := 0

; ===================================================================================================
; TERATERM AUTOMATION
; ===================================================================================================
#IfWinActive ahk_exe ttermpro.exe
!1::
	SendInputE("setprop persist.hibernated 0{Enter}")
	SendInputE("busybox mkswap /dev/block/mmcblk2p10{Enter}")
return
!3:: SendInputE("cat /reserved1/model-release{Enter}")
!4::
	SendInputE("cd sdcard{Enter}")
	SendInputE("logcat -c{Enter}")
	SendInputE("logcat -v time | grep EMS_TPEG > ems_log{Enter}")
return
!0::
	SendInputE("touch /tmp/system_started{Enter}")
	SendInputE("killall C300SystemService{Enter}")
return
#IfWinActive
; ===================================================================================================
; WINDOWS TERMINAL AUTOMATION
; ===================================================================================================
; #IfWinActive ahk_exe WindowsTerminal.exe
#If (WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe wezterm-gui.exe"))

; F13:: 
;     ShowAdbMenu()

^NumpadDot:: SendInputE("adb disconnect{Enter}")
^Numpad0::
    SendInputE("adb devices -l{Enter}")
    return
^Numpad1:: SendInputE("adb connect 192.168.3.")
^Numpad2:: SendInputE("adb connect 192.168.3.20{Enter}")
^Numpad3:: SendInputE("adb connect 192.168.3.141{Enter}")

^Numpad5:: SendInputE("grep -a AndroidRuntime main.log{Enter}")
^Numpad4:: SendInputE("grep -a VERSION main.log{Enter}")
^Numpad6:: SendInputE("adb shell cat /sdcard/EMLog/main/main.log | cgrep")
;^Numpad7:: sendInput python e:\GitHub\Python\Y461\update_release.py{Enter}
^Numpad9::
	IfWinActive, wglim
		SendInputE("python /mnt/e/GitHub/Python/U100LogManager.py{Enter}")
	else
		SendInputE("python E:\GitHub\Python\U100LogManager.py{Enter}")
return

AppsKey & Numpad1:: SendInputE("cd /sdcard/EMLog/main{Enter}")
AppsKey & Numpad2:: SendInputE("cd /system/app{Enter}")
AppsKey & Numpad3:: SendInputE("cd /system/app{Enter}")

!Numpad3::
	IfWinActive, wglim
        SendInputE("cd /mnt/e/GitHub{Enter}")
	else
	{
		SendInputE("E:{Enter}")
		SendInputE("cd \GitHub{Enter}")
	}
return
!Numpad4::
	IfWinActive, wglim
        SendInputE("cd /mnt/e/U100/App/Output{Enter}")
	else
	{
		SendInputE("E: ")
		SendInputE("cd \U100\App\Output{Enter}")
	}
return
!Numpad5::
	IfWinActive, wglim
    {
        SendInputE("cd /mnt/d/log{Enter}")
    }
	else
	{
		SendInputE("D:{Enter}")
		SendInputE("cd \Log{Enter}")
	}
return
!Numpad6::
	Time := 0
	Loop D:\Log\*, 2
	{
		If ( A_LoopFileTimeModified >= Time )
		{
			Time := A_LoopFileTimeModified, Folder := SubStr(A_LoopFileLongPath,8)
		}
	}
	IfWinActive, wglim
        IfExist, D:\Log\%Folder%\sdcard\EMLog
        {
            cmd := "cd """ . Folder . "/sdcard/EMLog/main""{Enter}"
            SendInputE(cmd)
            
        }
		else
			SendInputE("cd " . Folder . "/sdcard/WTLog/main{Enter}")
	else
        IfExist, D:\Log\%Folder%\sdcard\EMLog
        {
            cmd := "cd """ . Folder . "\sdcard\EMLog\main""{Enter}"
            SendInputE(cmd)
        }
		else
			SendInputE("cd " . Folder . "\sdcard\WTLog\main{Enter}")
return

; --------------------------------------------------
; 마우스 휠로 less 스크롤 (Up → PageUp, Down → PageDown)
; --------------------------------------------------
^WheelUp::
    Loop 15
        Send {Up}
return

^WheelDown::
    Loop 15
        Send {Down}
return

+WheelUp::
    Loop 3
        Send {Up}
return

+WheelDown::
    Loop 3
        Send {Down}
return


!Numpad7:: GoRecentlyFolder()
#IfWinActive 

; ---------------------------------------------------------------------------------------------------
; Launcher_Mail
; ---------------------------------------------------------------------------------------------------
; Launch_Mail: 마우스 BackKey를 Launch_Mail 키로 할당
; 개발 툴이나 파일 관리자에서 Launch Mail 키로 Ctrl+F4 보내기
#IfWinActive ahk_exe studio64.exe
Launch_Mail::Send, ^{F4}
F21::WinActivate, ahk_exe cursor.exe
#IfWinActive ahk_exe cursor.exe
Launch_Mail::Send, ^{F4}
F21::WinActivate, ahk_exe studio64.exe
#IfWinActive ahk_exe code.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe dopus.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe Notepad.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe Merge.exe
Launch_Mail::Send, ^{F4}
; 웹 브라우저에서는 Ctrl+W로 탭 닫기
#IfWinActive ahk_exe whale.exe
Launch_Mail::Send, ^w
#IfWinActive ahk_exe msedge.exe
Launch_Mail::Send, ^w
#IfWinActive ahk_exe chrome.exe
Launch_Mail::Send, ^w
#IfWinActive ahk_exe notepad++.exe
Launch_Mail::Send, ^w
#IfWinActive ahk_exe comet.exe
Launch_Mail::Send, ^w
#IfWinActive ahk_exe WindowsTerminal.exe
Launch_Mail::Send, ^+w
; 핫키 컨텍스트 초기화
#IfWinActive

Launch_Mail:: Send, !{F4}
; ===================================================================================================
; GLOBAL HOTKEYS & FOLDER SHORTCUTS
; ===================================================================================================
;SC11D:: return
AppsKey & D::OpenOrSetDialog("D:\Download")
AppsKey & L::OpenOrSetDialog("D:\Log")
AppsKey & U::OpenOrSetDialog("C:\Users\roadr")
AppsKey & O::OpenOrSetDialog("E:\U100\App\Output")
AppsKey & G::OpenOrSetDialog("E:\GitHub")
AppsKey & P::OpenOrSetDialog("E:\GitHub\Python")
AppsKey & T::OpenOrSetDialog("R:\Temp")
AppsKey & K::OpenOrSetDialog("C:\Users\roadr\Documents\카카오톡 받은 파일")
AppsKey & R::OpenOrSetDialog("R:\OneDrive")

^Volume_Mute:: return

AppsKey::
;        Menu, MyFolderMenu, DeleteAll
	Menu, MyFolderMenu, Add, D:\Download, MenuHandler
	Menu, MyFolderMenu, Add, D:\Log, MenuHandler
	Menu, MyFolderMenu, Add, R:\Temp, MenuHandler
	Menu, MyFolderMenu, Add, E:\U100\App\Output, MenuHandler
	Menu, MyFolderMenu, Add, R:\OneDrive, MenuHandler
	Menu, MyFolderMenu, Add, E:\GitHub, MenuHandler
	Menu, MyFolderMenu, Add, E:\GitHub\Python, MenuHandler
	Menu, MyFolderMenu, Add, C:\Users\roadr, MenuHandler
	Menu, MyFolderMenu, Add, C:\Users\roadr\Documents\카카오톡 받은 파일, MenuHandler
	Menu, MyFolderMenu, Add, (닫힘), DummyHandler
	Menu, MyFolderMenu, Show
return

MenuHandler:
    global isMenuVisible
    selectedPath := A_ThisMenuItem
    if (selectedPath != "") {
        OpenOrSetDialog(selectedPath)
    }
    isMenuVisible := false
return

AppsKey & Numpad1:: SendInputE("M73507255")
AppsKey & Numpad2:: SendInputE("20280324")
AppsKey & Numpad3:: SendInputE("3564158595054006")

; ===================================================================================================
; APPLICATION TOGGLING (WIN + NUMPAD)
; ===================================================================================================
#Numpad0:: TOGGLE_EXE("WindowsTerminal.exe", "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.22.11141.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe")
;	TOGGLE_TITLE("명령 프롬프트")
;	TOGGLE_TITLE("wglim@wglim-pc")
;return
#Numpad1:: GoAndroidStudio(0)
#Numpad2:: GoAndroidStudio(1)
#Numpad3:: TOGGLE_EXE("Code.exe", "C:\Users\roadr\AppData\Local\Programs\Microsoft VS Code\Code.exe")
#Numpad4:: TOGGLE_EXE("notepad++.exe", "C:\Program Files\Notepad++\notepad++.exe")
#Numpad5:: TOGGLE_EXE("pycharm64.exe", "C:\Program Files\JetBrains\PyCharm Community Edition 2022.3.2\bin\pycharm64.exe")
#Numpad6:: TOGGLE_EXE("SourceTree.exe", "C:\Users\roadr\AppData\Local\SourceTree\SourceTree.exe")
#Numpad7:: TOGGLE_EXE("idea64.exe", "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2022.3.3\bin\idea64.exe")
 ;#Numpad7::	TOGGLE_TITLE("YouTube Music")
 
#Numpad8::
    hwnd := WinExist("ahk_exe code.exe")
    if (hwnd) {
        WinGetTitle, title, ahk_id %hwnd%
        if (InStr(title, "emat.ahk")) {
            if WinActive("ahk_id " hwnd)
                WinMinimize, ahk_id %hwnd%
            else
                WinActivate, ahk_id %hwnd%
        } else {
            Run, "C:\Users\roadr\AppData\Local\Programs\Microsoft VS Code\Code.exe" E:\GitHub\AHK\emat.ahk
        }
    } else {
        Run, "C:\Users\roadr\AppData\Local\Programs\Microsoft VS Code\Code.exe" E:\GitHub\AHK\emat.ahk
    }
return
#Numpad9:: TOGGLE_EXE("Merge.exe", "C:\Program Files\Araxis\Araxis Merge\Merge.exe")

^#Numpad0:: TOGGLE_EXE("ONENOTE.EXE", "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE")
^#Numpad1:: TOGGLE_EXE("EXCEL.EXE", "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE")
^#Numpad2:: TOGGLE_EXE("WINWORD.EXE", "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE")
^#Numpad3:: TOGGLE_EXE("POWERPNT.EXE", "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE")
^#Numpad4:: TOGGLE_EXE("OUTLOOK.EXE", "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE")
^#Numpad5:: TOGGLE_EXE("Notepad.exe", "C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2508.38.0_x64__8wekyb3d8bbwe\Notepad\Notepad.exe")

^Numpad8::
	Reload
return

#NumpadAdd::Send {Media_Next}
#NumpadSub:: WinActivate, ahk_exe SMemo.exe
#NumpadDiv:: Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
#NumpadMult:: Run, E:\GitHub\AHK\keyboard_hook.ahk
^Numpad9:: sendRaw find / ! \( -path /proc -prune \) -name "*.rc" -exec grep -Hni XXX '{}' \;

FUCNTION_HOTKEY_MAPPINGS()
{
}

; ===================================================================================================
; CLAUNCH & CLCL KEY MAPPINGS
; ===================================================================================================
#IfWinActive ahk_exe Claunch.exe
F19::Send, 1
F20::Send, 2
F21::Send, 3
F22::Send, ^{Space}
F23::Send, {Esc}
F24::Send, ^{Enter}
#IfWinActive

; ^!F17:: TOGGLE_EXE("pycharm64.exe", "C:\Program Files\JetBrains\PyCharm Community Edition 2022.3.2\bin\pycharm64.exe")
; ^!F18:: TOGGLE_EXE("Code.exe", "C:\Users\roadr\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ^!F20:: TOGGLE_CYCLE("studio64.exe", "studio64.exe")

; F22:: Send, ○


^!F20::   Run, python E:\GitHub\Python\GotoSource.py, ,Hide

; ===================================================================================================
; WINDOW SIZE MANAGEMENT
; ===================================================================================================

^!F21:: CycleDockWindowSize()
^!F22:: CycleStandardWindowSize()
^!F23:: Send, #+{Left}
^!F24:: Send, #+{Right}

; 활성 창 이동 (Ctrl+Win+화살표: 10픽셀씩)
^#Up:: MoveActiveWindow(0, -10)
^#Down:: MoveActiveWindow(0, 10)
^#Left:: MoveActiveWindow(-10, 0)
^#Right:: MoveActiveWindow(10, 0) 

F13:: TOGGLE_CYCLE("kakaotalk.exe", "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe")
F14:: TOGGLE_CYCLE("notepad3.exe", "notepad3.exe")

; F19:: Send, !c ; clcl 호출

; F20:: Send, ○{Enter}
; F22:: TOGGLE_EXE("fm.exe")
; F22:: TOGGLE_EXE("Palworld-Win64-Shipping.exe")
; F18:: Send, ^!{Numpad7} ; clcl Template Coding 호출


F16:: TOGGLE_EXE("WindowsTerminal.exe", "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.22.11141.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe")
F17:: TOGGLE_EXE("dopus.exe")
F18:: GoAndroidStudio(2)
F19:: GoAndroidStudio(1)
F20:: GoAndroidStudio(0)
F23:: Send, ^#!c ; Claunch 호출
;F24 Clipboard History 호출

+F15:: Send, {Media_Next}
+F24:: 
    Send, relic add PAPER_PHROG{Enter}
    Send, relic add MOLTEN_EGG{Enter}
    Send, relic add FROZEN_EGG{Enter}
    Send, relic add TOXIC_EGG{Enter}
    Send, relic add UNCEASING_TOP{Enter}
    Send, relic add THE_COURIER{Enter}
    Send, relic add ICE_CREAM{Enter}
    Send, relic add VEXING_PUZZLEBOX{Enter}
    Send, relic add MINIATURE_TENT{Enter}
    Send, relic add STURDY_CLAMP{Enter}
    Send, relic add DRAGON_FRUIT{Enter}
    Send, relic add CHEMICAL_X{Enter}
    Send, relic add STRIKE_DUMMY{Enter}
    Send, relic add MINIATURE_CANNON{Enter}
return


; ===================================================================================================
; BROWSER & AI TOOLS (CTRL+ALT+WIN+F Keys)
; ===================================================================================================
^!#F1:: TOGGLE_TITLE("이쁜부인")
^!#F2:: 
^!#F6:: TOGGLE_EXE("Code.exe", "C:\Users\roadr\AppData\Local\Programs\Microsoft VS Code\Code.exe")

^!#F7:: TOGGLE_EXE("dopus.exe")
^!#F8:: TOGGLE_EXE("Whale.exe", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\네이버 웨일.lnk")
; ^!#F9:: TOGGLE_EXE("comet.exe", "C:\Users\roadr\AppData\Local\Perplexity\Comet\Application\comet.exe")
; ^!#F9:: TOGGLE_EXE(
^!#F10:: GoAndroidStudio(2)
^!#F11:: GoAndroidStudio(1)
^!#F12:: GoAndroidStudio(0)
;^!#F7:: TOGGLE_EXE("Perplexity.exe", "C:\Users\roadr\AppData\Local\Programs\Perplexity\Perplexity.exe")
;^!#F8:: TOGGLE_EXE("ChatGPT.exe", "C:\Users\roadr\AppData\Local\Microsoft\WindowsApps\chatgpt.exe")
;^!#F9:: TOGGLE_TITLE("Google Gemini", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts\9501e18d7c2ab92e\원규 - Chrome.lnk")
;^!#F10:: TOGGLE_EXE("msedge.exe")
;^!#F11:: TOGGLE_TITLE("Chrome", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Chrome.lnk")
;^!#F12:: TOGGLE_TITLE("Whale", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\네이버 웨일.lnk")

;^!#F1:: TOGGLE_TITLE("Google AI Studio", "C:\Users\roadr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\네이버 웨일 앱\Google AI Studio.lnk")
;^!#F2:: TOGGLE_EXE("Joplin.EXE", "C:\Program Files\Joplin\Joplin.exe")

ShowAdbMenu()
{
	Menu, AdbMenu, Add, __dummy__, DummyHandler
	Menu, AdbMenu, DeleteAll
	Menu, AdbMenu, Add, &1 adb devices, AdbMenuHandler
	Menu, AdbMenu, Add, &2 adb disconnect, AdbMenuHandler
	Menu, AdbMenu, Add, &3 adb connect 192.168.3.3, AdbMenuHandler
	Menu, AdbMenu, Add, &4 adb connect 192.168.3.20, AdbMenuHandler
	Menu, AdbMenu, Add, &5 adb connect 192.168.3.141, AdbMenuHandler
    Menu, AdbMenu, Add, &6 adb connect 192.168.3., AdbMenuHandler
	Menu, AdbMenu, Add, (닫힘), DummyHandler
	Menu, AdbMenu, Show
}

AdbMenuHandler:
    selected := A_ThisMenuItem
	cmd := ""
	if (selected = "&1 adb devices" || selected = "adb devices")
		cmd := "adb devices -l{Enter}"
	else if (selected = "&2 adb disconnect" || selected = "adb disconnect")
		cmd := "adb disconnect{Enter}"
	else if (selected = "&3 adb connect 192.168.3.3" || selected = "adb connect 192.168.3.3")
		cmd := "adb connect 192.168.3.3{Enter}"
	else if (selected = "&4 adb connect 192.168.3.20" || selected = "adb connect 192.168.3.20")
		cmd := "adb connect 192.168.3.20{Enter}"
	else if (selected = "&5 adb connect 192.168.3.141" || selected = "adb connect 192.168.3.141")
		cmd := "adb connect 192.168.3.141{Enter}"
	else if (selected = "&6 adb connect 192.168.3." || selected = "adb connect 192.168.3.")
		cmd := "adb connect 192.168.3."
	else
	{
        return
	}

    SendInputE(cmd)
return

Macro_ClusterAppUpload()
{
	SendInputE("adb shell{Enter}")
	SendInputE("su{Enter}")
	SendInputE("ssh root@192.168.1.1{Enter}")
	Sleep, 1000
	SendInputE("yes{Enter}")
	SendInputE("slay vt_avm{Enter}")
	SendInputE("cd /data/vt_avm_file{Enter}")
	SendInputE("chmod 777 MvFile.sh{Enter}")
	SendInputE("./MvFile.sh{Enter}")
	SendInputE("/usr/bin/vt_avm &{Enter}")
}

Macro_GPU_busy()
{
	Send, adb shell{Enter}
	Send, su{Enter}
	Send, ssh root@192.168.1.1{Enter}
	Sleep, 1000
	Send, yes{Enter}
	Send, echo gpu_set_log_level 4 >/dev/kgsl-control{Enter}
	Sleep, 1000
	Send, echo gpubusystats 400 >/dev/kgsl-control{Enter}
	Sleep, 1000
	Send, slog2info -b KGSL -w | grep measurement | grep 'percentage busy' | awk '{{}print ($NF){}}\'{Enter}
;	Send, slog2info -b KGSL -w | grep measurement | grep "percentage busy" | awk '{print ($NF)}'{Enter}
}

; ^!#F6::
; ;        Menu, MyFolderMenu, DeleteAll
; 	Menu, MyFolderMenu2, Add, GPU 부하 측정, MenuHandler2
; 	Menu, MyFolderMenu2, Add, Cluster App Upload, MenuHandler2
; 	Menu, MyFolderMenu2, Add, (닫힘), DummyHandler
; 	Menu, MyFolderMenu2, Show
; return

MenuHandler2:
    global isMenuVisible2
    selectedMacro := A_ThisMenuItem
    if (selectedMacro = "GPU 부하 측정")
    {
        Macro_GPU_busy()
    }
    else if (selectedMacro = "Cluster App Upload")
    {
        Macro_ClusterAppUpload()
    }
    isMenuVisible2 := false
return

FUNCTION_KEY_MAPPINGS() {
}

; ===================================================================================================
; FUNCTION KEY MAPPINGS & UTILITIES
; ===================================================================================================

#F2::
	Run, "C:\Program Files\Notepad3\Notepad3.exe"
return
; Notepad++에서 Ctrl+마우스 우클릭시 AndroidStudio 소스로 이동
^RButton::
  IfWinActive ahk_class Notepad++
  {
	  sendInput {Home}{ShiftDown}{End}{ShiftUp}^c
	  Sleep, 100
	  Run, python E:\GitHub\Python\GotoSource.py, ,Hide
	  ;~ Sleep, 1000
;	  WinActivate, ahk_exe studio64.exe
		;~ GoAndroidStudio()
	}
return
OpenOrSetDialog(path) {

    ; 2. 현재 창이 Windows 탐색기일 경우 → 경로 변경
    WinGetClass, activeClass, A
    if (activeClass = "CabinetWClass") {
        ClipSaved := ClipboardAll
        Clipboard := path
        Send, !d       ; Alt + D → 주소창
        Sleep, 100
        Send, ^a
        Sleep, 50
        Send, ^v{Enter}
        Sleep, 100
        Clipboard := ClipSaved
        ClipSaved := ""
        return
    }

    if WinActive("ahk_exe WindowsTerminal.exe")
    {
		IfWinActive, wglim
		{
			ClipSaved := ClipboardAll
			linuxPath := ConvertToLinuxPath(path)
			Clipboard := "cd " . linuxPath
			SendInput, ^v{Enter}
			Sleep, 100
			Clipboard := ClipSaved
			ClipSaved := ""
		}
		else
		{
		    ClipSaved := ClipboardAll
			drive := SubStr(path, 1, 2)      ; 예: D:
			subPath := SubStr(path, 3)       ; 예: \Download 또는 \Users\Me...
			Clipboard := drive . " & cd " . subPath
			SendInput, ^v{Enter}
			Sleep, 100
			Clipboard := ClipSaved
			ClipSaved := ""
		}
		return
    }

        ; 1. 파일 열기 대화상자 (#32770 + Edit1) 확인
    WinGet, winList, List, ahk_class #32770
    Loop, %winList%
    {
        this_id := winList%A_Index%
		; 창의 실행 파일(exe) 이름 확인
		WinGet, exeName, ProcessName, ahk_id %this_id%
		if (exeName = "YES24eBook.exe")
			continue  ; 이 창은 무시하고 다음 창으로 넘어감
        ControlGet, exist, Hwnd,, Edit1, ahk_id %this_id%
        if (exist) {
            ControlSetText, Edit1, %path%, ahk_id %this_id%
            ControlSend, Edit1, {Enter}, ahk_id %this_id%
            return
        }
    }
    
    ; 3. 기본 동작 (DOpus로 열림)
    Run, "%path%"
    ; Run, "C:\Program Files\GPSoftware\Directory Opus\dopus.exe" "%path%"
}

TOGGLE_TITLE(titlePattern, filePath := "")
{
    ; 현재 활성 창이 해당 타이틀인지 확인
    if WinActive(titlePattern)
    {
        WinMinimize, %titlePattern%
        return
    }

    ; 창 존재 여부 확인
    if WinExist(titlePattern)
    {
        ; 창이 존재하면 활성화
        WinActivate, %titlePattern%
    }
    else
    {
        ; 창이 없으면 실행
        if (filePath != "")
            Run, %filePath%
    }
}

TOGGLE_EXE(procName, filePath := "") {
    fullName := "ahk_exe " . procName

    ; 1) 현재 프로세스 창이 활성 상태 → 최소화
    if WinActive(fullName) {
        WinMinimize, %fullName%
        return
    }

    ; 2) 실행 중인지 PID 확인
    WinGet, processID, PID, %fullName%

    ; 3) 실행 중이 아니라면 → 실행
    if (!processID) {
        if (filePath != "") {
            Run, %filePath%
        }
        return
    }

    ; 4) 실행중이지만 비활성 → 활성화
    WinActivate, %fullName%
}

GoAndroidStudio(opt)
{
    WinGet, id, List, ahk_class SunAwtFrame ahk_exe studio64.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, title, ahk_id %this_id%
        ; opt=1: Logcat 포함 창
        ; opt=2: Firebender 포함 창
        ; opt=0: 나머지 창 (Logcat, Firebender 제외)
        if (opt = 1 && !InStr(title, "Logcat"))
            continue
        if (opt = 2 && !InStr(title, "Firebender"))
            continue
        if (opt = 0 && (InStr(title, "Logcat") || InStr(title, "Firebender") || InStr(title, "Chat") || InStr(title, "Running Devices")))
            continue
        ; 토글 동작
        if WinActive("ahk_id " . this_id)
            WinMinimize, ahk_id %this_id%
        else
            WinActivate, ahk_id %this_id%
        return
    }
    return
}
GoWhale(opt)
{
    WinGet, id, List, ahk_exe whale.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, title, ahk_id %this_id%
        if (InStr(title, "YouTube Music") || InStr(title, "Google AI Studio") || !InStr(title, "Whale"))
            continue
;        Sleep, 100
;        if WinActive("ahk_id " . this_id)
;            WinMinimize, ahk_id %this_id%
;        else
        {
            WinActivate, ahk_id %this_id%
            Sleep, 100
            Send, ^%opt% ; opt가 1이면 Ctrl+1
            Sleep, 100
        }
        return
    }
    return
}
GoChrome(opt)
{
	if !WinExist("ahk_exe chrome.exe")
	{
		Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
		return
	}
    WinGet, id, List, ahk_exe chrome.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, title, ahk_id %this_id%
;        if (InStr(title, "YouTube Music") || InStr(title, "Google AI Studio") || !InStr(title, "Whale"))
;            continue
;        Sleep, 100
;        if WinActive("ahk_id " . this_id)
;            WinMinimize, ahk_id %this_id%
;        else
        {
            WinActivate, ahk_id %this_id%
            Sleep, 100
            Send, ^%opt% ; opt가 1이면 Ctrl+1
            Sleep, 100
        }
        return
    }
    return
}
GoEdge(opt)
{
    WinGet, id, List, ahk_exe msedge.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, title, ahk_id %this_id%
        {
            WinActivate, ahk_id %this_id%
            Sleep, 100
            Send, ^%opt% ; opt가 1이면 Ctrl+1
            Sleep, 100
        }
        return
    }
    return
}
GoTab(TargetTitle)
{
;  DetectHiddenWindows, On ; 숨겨진 창도 감지하도록 설정
;   Chrome
  TabCount := 0
  Loop, % WinExist("Chrome")
  {
    ControlGetText, TabText, Chrome_RenderWidgetHostHWND%A_Index%, Chrome
    MsgBox, %TabText%
    If (InStr(TabText, TargetTitle))
    {
      ControlFocus, Chrome_RenderWidgetHostHWND%A_Index%, Chrome
      WinActivate, Chrome
      break ; 원하는 탭을 찾았으면 루프 종료
    }
  }
  ; Edge
;  If TabCount = 0 ; Chrome에서 못찾았으면 Edge에서 찾기
;  {
;    Loop, % WinExist("ahk_exe msedge.exe")
;    {
;      ControlGetText, TabText, Chrome_RenderWidgetHostHWND%A_Index%, ahk_exe msedge.exe
;		MsgBox, TabText
;      If (InStr(TabText, TargetTitle))
;      {
;        ControlFocus, Chrome_RenderWidgetHostHWND%A_Index%, ahk_exe msedge.exe
;        WinActivate, ahk_class msedge
;        break ; 원하는 탭을 찾았으면 루프 종료
;      }
;    }
;  }
;  DetectHiddenWindows, Off ; 숨겨진 창 감지 설정 해제
  if TabCount = 0
    MsgBox, 48, 찾기 실패, "%TargetTitle%"을(를) 포함하는 탭을 찾을 수 없습니다.
  return
}

; ===================================================================================================
; GLOBAL VARIABLES & UTILITY FUNCTIONS
; ===================================================================================================
global LogFolder := "D:\Log"  ; 로그 폴더 경로
global MaxFolders := 5  ; 메뉴에 표시할 최대 폴더 개수
global MenuTitle := "최근 로그 폴더 선택"  ; 메뉴 제목
global FolderPaths
GetRecentFolders(FolderPath, MaxCount)
{
	FolderPath := "D:\Log"
  if !FileExist(FolderPath)
  {
	MsgBox, Log 폴더가 없음
    return ""
  }
  FileList := ""
  Loop, Files, %FolderPath%\*, D
  {
    FileList .= A_LoopFileLongPath . "|" . A_LoopFileTimeModified . "`n"
  }
  ; 최신순 정렬
  Sort, FileList, R D|
  OutputList := ""
  Loop, Parse, FileList, `n
  {
    if (A_Index > MaxCount)
      break
    StringSplit, FileInfo, A_LoopField, |
    FilePath := FileInfo1
    OutputList .= FilePath . "`n"
  }
  MsgBox, %OutputList%
  return OutputList
}
ShowRecentLogFolders(logDir := "D:\Log", maxCount := 30)
{
    ; 메뉴 초기화
    Menu, RecentFolders, Add, __dummy__, DummyHandler
    Menu, RecentFolders, DeleteAll
    ; 폴더 가져오기
    count := 0
    Loop, %logDir%\*, 2  ; 2 = Directory only
    {
        if (count >= maxCount)
            break
        fullPath := A_LoopFileFullPath
        displayName := SubStr(fullPath, StrLen(logDir) + 2)
        Menu, RecentFolders, Add, %displayName%, OpenRecentFolder
        count++
    }
    ; 메뉴 띄우기
    global __RecentFolderRoot := logDir
    Menu, RecentFolders, Show
    return
}
OpenRecentFolder:
	GoToFolder()
;    selected := A_ThisMenuItem
;    selectedPath := __RecentFolderRoot . "\" . selected
;    Run, %selectedPath%
return
DummyHandler:
return
DummyFunction() {
  return
}
GoToFolder() {
  ;~ LinuxPath := ConvertToLinuxPath(A_ThisMenuItem)
	IfExist, D:\Log\%A_ThisMenuItem%\sdcard\EMLog  ; EMLog 폴더가 있는지 확인
		SendInputE("cd " . A_ThisMenuItem . "/sdcard/EMLog/main{Enter}")
	Else
		SendInputE("cd " . A_ThisMenuItem . "/sdcard/WTLog/main{Enter}")
  return
}
ConvertToLinuxPath(winPath) {
  drive := SubStr(winPath, 1, 1)  ; 드라이브 문자 추출
  drive := Format("{:L}", drive)  ; 소문자로 변환
  rest := SubStr(winPath, 3)  ; 드라이브 문자 이후 경로
  StringReplace, rest, rest, \, /, All  ; 백슬래시를 슬래시로 변경
  return "/mnt/" . drive . rest
}
GoRecentlyFolder()
{
    ; Python 실행하여 최근 폴더 목록 가져오기
    RunWait, %ComSpec% /c python "E:\GitHub\Python\GotoRecentlyFolder.py", , Hide
    ; 출력된 폴더 목록 읽기E:\GitHub\Python\GotoRecentlyFolder.pynE:\GitHub\Python\GotoRecentlyFolder.pyE:\GitHub\Python\GotoRecentlyFolder.py
    FileRead, folderList, %A_Temp%\folders.txt
    StringSplit, lines, folderList, :
    ; 메뉴 새로 만들기 (이전 메뉴 지우지 않고 새로 덮기)
    Menu, RecentFolders, Add, [최근 폴더 선택], dummyHandler
    Menu, RecentFolders, Disable, [최근 폴더 선택]
;     기존 항목이 있다면 제거
;    Loop
;    {
;        Menu, RecentFolders, Delete, %A_Index%
;        if ErrorLevel
;            break
;    }
    ; 최근 폴더 항목 추가
    Loop, %lines0%
    {
        item := lines%A_Index%
        if (item != "")
            Menu, RecentFolders, Add, %item%, OpenFolder
    }
    Menu, RecentFolders, Show
	return
}
OpenFolder:
	SelectedPath := Trim(A_ThisMenuItem)
	IfWinActive, wglim
	{
		SendInputE("cd /mnt/d/log/" . SelectedPath . "/sdcard/EMLog/main{Enter}")
	}
	else
	{
		SendInputE("cd " . SelectedPath . "\sdcard\EMLog\main")
	}
return

;IME관련 함수(검색해서 찾은것)
Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, wParam,lParam, ,ahk_id %DefaultIMEWnd%
    if (DetectSave <> A_DetectHiddenWindows)
    {
        DetectHiddenWindows,%DetectSave%
        return ErrorLevel
    }
}
ImmGetDefaultIMEWnd(hWnd)
{
    return DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hWnd, Uint)
}
IME_CHECK(WinTitle)
{
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}

; 입력 전에 현재 IME가 한글(1)이면 영문(0)으로 전환
EnsureEnglishInput(WinTitle := "A")
{
    ; imeStatus := IME_CHECK(WinTitle)
    ; if (imeStatus != 0)
    ; {
    ;     Send, {vk15sc138}  ; 한/영 전환키
    ;     Sleep, 50
    ; }
}

SendE(str, WinTitle := "A")
{
    EnsureEnglishInput(WinTitle)
    Send, %str%
}

SendInputE(str, WinTitle := "A")
{
    EnsureEnglishInput(WinTitle)
    SendInput, %str%
}

SendRawE(str, WinTitle := "A")
{
    EnsureEnglishInput(WinTitle)
    SendRaw, %str%
}

; option : 0(send), 1(sendinput), 2(sendraw)
; lang : 0(영어로 입력), 1(한글로 입력)
; str : 입력할 단어
F_Send_ToEnK(option, lang, str)
{
    imeStatus := IME_CHECK("A")
    if (lang = 0 && imeStatus != 0)
    {
        Send, {vk15sc138}
        Sleep, 50
    }
    else if (lang = 1 && imeStatus = 0)
    {
        Send, {vk15sc138}
        Sleep, 50
    }

    if (option = 0)
        Send, %str%
    else if (option = 1)
        SendInput, %str%
    else if (option = 2)
        SendRaw, %str%
}


; ===================================================================================================
; HOTSTRINGS & TEXT EXPANSION
; ===================================================================================================
:*:date..::
FormatTime, CurrentDateDate,%A_Now%, yyyy년 M월 d일  ; It will look like 9/1/2005 3:53 PM
SendInputE(CurrentDateDate)
return
:*:time..::
FormatTime, CurrentDateTime, %A_Now%, yyyy년 M월 d일 h:mm ; It will look like 9/1/2005 3:53 PM
SendInputE(CurrentDateTime)
return
:*:em..::adb shell am broadcast -a action.ematsoft.test --es emdata --es value
:*:ps..::ps -A | grep emat
:*:pm..::pm list package -f | grep emat
:*:run..::grep -a AndroidRuntime
:*:ver..::dumpsys package com.ematsoft. | grep version
:*:log..::EMLOG.i("onChange: " + EMData.findValue(key) + ", " + s);
:*:..con::cat logcat.050 logcat.049 logcat.048 logcat.047 logcat.046 logcat.045 logcat.044 logcat.043 logcat.042 logcat.041 logcat.040 logcat.039 logcat.038 logcat.037 logcat.036 logcat.035 logcat.034 logcat.033 logcat.032 logcat.031 logcat.030 logcat.029 logcat.028 logcat.027 logcat.026 logcat.025 logcat.024 logcat.023 logcat.022 logcat.021 logcat.020 logcat.019 logcat.018 logcat.017 logcat.016 logcat.015 logcat.014 logcat.013 logcat.012 logcat.011 logcat.010 logcat.009 logcat.008 logcat.007 logcat.006 logcat.005 logcat.004 logcat.003 logcat.002 logcat.001 logcat >
:*:..emtext::com.ematsoft.controllib.control.EMTextView{Enter}android:layout_marginLeft="px"{Enter}android:layout_marginTop="px"{Enter}android:layout_width="px"{Enter}android:layout_height="px"{Enter}style="@style/text_regular"{Enter}android:gravity="center"{Enter}android:textSize="px"{Enter}android:textColor="@color/text_color_normal_ff70"{Enter}android:text=""{Enter}/>
:*:hi..::안녕하세요`n이맷소프트 임원규입니다.`n
:*:ㅇ..::안녕하세요`n이맷소프트 임원규입니다.`n
:*:(1))::①
:*:(2))::②
:*:(3))::③
:*:(4))::④
:*:(5))::⑤
:*:(6))::⑥
:*:(7))::⑦
:*:(8))::⑧
:*:(9))::⑨
:*:(10))::⑩

; ===================================================================================================
; CLIPBOARD UTILITIES
; ===================================================================================================
; 클립보드 내용을 일반 텍스트로 붙여넣기 (서식 제거)
^+V::
    ClipSaved := ClipboardAll
    Clipboard := Clipboard  ; 클립보드 내용을 다시 설정하여 서식 제거
    Send, ^v
    Sleep, 50
    Clipboard := ClipSaved
    ClipSaved := ""
return

; ===================================================================================================
; WINDOW SIZE HELPERS
; ===================================================================================================
CycleStandardWindowSize()
{
    global g_WindowSizeStandard, g_WindowSizeStandardIndex

    if (!IsObject(g_WindowSizeStandard) || g_WindowSizeStandard.Length() = 0)
        return

    g_WindowSizeStandardIndex++
    if (g_WindowSizeStandardIndex > g_WindowSizeStandard.Length())
        g_WindowSizeStandardIndex := 1

    preset := g_WindowSizeStandard[g_WindowSizeStandardIndex]
    if (!IsObject(preset) || preset.Length() < 2)
        return

    width := preset[1]
    height := preset[2]
    ResizeActiveWindow(width, height)
}

CycleDockWindowSize()
{
    global g_WindowSizeDock, g_WindowSizeDockIndex

    if (!IsObject(g_WindowSizeDock) || g_WindowSizeDock.Length() = 0)
        return

    g_WindowSizeDockIndex++
    if (g_WindowSizeDockIndex > g_WindowSizeDock.Length())
        g_WindowSizeDockIndex := 1

    preset := g_WindowSizeDock[g_WindowSizeDockIndex]
    if (!IsObject(preset) || preset.Length() < 2)
        return

    placement := preset[1]
    target := preset[2]
    if (placement = "dockLeft")
    {
        ResizeActiveWindowDockLeft(target)
        return
    }
    else if (placement = "dockRight")
    {
        ResizeActiveWindowDockRight(target)
        return
    }
    else if placement is number
    {
        width := placement
        height := (preset.Length() >= 2) ? target : placement
        ResizeActiveWindow(width, height)
        return
    }

    ; 알 수 없는 형식은 우측 도킹으로 처리
    ResizeActiveWindowDockRight(target)
}

ResizeActiveWindow(width, height)
{
    WinGet, hwnd, ID, A
    if (!hwnd)
        return

    WinGet, currentState, MinMax, ahk_id %hwnd%
    if (currentState != 0)
        WinRestore, ahk_id %hwnd%

    GetMonitorWorkArea(hwnd, workLeft, workTop, workRight, workBottom)
    if (workLeft = "")
    {
        workLeft := 0
        workTop := 0
        workRight := A_ScreenWidth
        workBottom := A_ScreenHeight
    }

    maxWidth := workRight - workLeft
    maxHeight := workBottom - workTop

    if (width = -1 && height = -1)
    {
        WinMaximize, ahk_id %hwnd%
        return
    }

    if (width > maxWidth)
        width := maxWidth
    if (height > maxHeight)
        height := maxHeight

    newX := workLeft + ((maxWidth - width) // 2)
    newY := workTop + ((maxHeight - height) // 2)
    WinMove, ahk_id %hwnd%, , %newX%, %newY%, %width%, %height%
}

ResizeActiveWindowDockRight(width)
{
    WinGet, hwnd, ID, A
    if (!hwnd)
        return

    WinGet, currentState, MinMax, ahk_id %hwnd%
    if (currentState != 0)
        WinRestore, ahk_id %hwnd%

    GetMonitorWorkArea(hwnd, workLeft, workTop, workRight, workBottom)
    if (workLeft = "")
    {
        workLeft := 0
        workTop := 0
        workRight := A_ScreenWidth
        workBottom := A_ScreenHeight
    }

    maxWidth := workRight - workLeft
    maxHeight := workBottom - workTop

    if (width <= 0 || width > maxWidth)
        width := maxWidth

    newX := workRight - width
    newY := workTop
    WinMove, ahk_id %hwnd%, , %newX%, %newY%, %width%, %maxHeight%
}

ResizeActiveWindowDockLeft(width)
{
    WinGet, hwnd, ID, A
    if (!hwnd)
        return

    WinGet, currentState, MinMax, ahk_id %hwnd%
    if (currentState != 0)
        WinRestore, ahk_id %hwnd%

    GetMonitorWorkArea(hwnd, workLeft, workTop, workRight, workBottom)
    if (workLeft = "")
    {
        workLeft := 0
        workTop := 0
        workRight := A_ScreenWidth
        workBottom := A_ScreenHeight
    }

    maxWidth := workRight - workLeft
    maxHeight := workBottom - workTop

    if (width <= 0 || width > maxWidth)
        width := maxWidth

    newX := workLeft
    newY := workTop
    WinMove, ahk_id %hwnd%, , %newX%, %newY%, %width%, %maxHeight%
}

GetMonitorWorkArea(hwnd, ByRef left, ByRef top, ByRef right, ByRef bottom)
{
    monitor := DllCall("MonitorFromWindow", "ptr", hwnd, "uint", 2, "ptr")
    if (!monitor)
        return

    VarSetCapacity(mi, 40, 0)
    NumPut(40, mi, 0, "UInt")

    if !DllCall("GetMonitorInfo", "ptr", monitor, "ptr", &mi)
        return

    left := NumGet(mi, 20, "Int")
    top := NumGet(mi, 24, "Int")
    right := NumGet(mi, 28, "Int")
    bottom := NumGet(mi, 32, "Int")
}

; 함수로 만들기
DebugLog(msg)
{
    FormatTime, time, , HH:mm:ss
    OutputDebug, [%time%] %msg%
}

TOGGLE_CYCLE(procName, filePath := "")
{
    static lastWinID := {}  ; 프로세스별 마지막 창 ID 저장

    ; 특정 프로세스의 모든 창 ID 수집
    windowList := []
    WinGet, idList, List, ahk_exe %procName%

    if (idList = 0)
    {
        if (filePath != "")
            Run, %filePath%
        return
    }

    ; 배열에 저장 (ID 기준으로 정렬하여 순서를 고정)
    Loop, %idList%
    {
        windowList.Push(idList%A_Index%)
    }

    ; 창 ID로 정렬 (순서 고정)
    ; 버블 정렬 사용
    Loop, % windowList.Length()
    {
        i := A_Index
        Loop, % windowList.Length() - i
        {
            j := A_Index
            if (windowList[j] > windowList[j + 1])
            {
                temp := windowList[j]
                windowList[j] := windowList[j + 1]
                windowList[j + 1] := temp
            }
        }
    }

    ; 마지막 활성화한 창 ID 찾기
    currentIndex := 0
    if (lastWinID.HasKey(procName))
    {
        lastID := lastWinID[procName]
        ; 마지막 창 ID가 현재 목록에 있는지 확인
        for index, winID in windowList
        {
            if (winID = lastID)
            {
                currentIndex := index
                break
            }
        }
    }

    ; 다음 인덱스 결정 (순환)
    if (currentIndex >= windowList.Length())
        nextIndex := 1
    else
        nextIndex := currentIndex + 1

    targetID := windowList[nextIndex]

    ; 마지막 창 ID 저장
    lastWinID[procName] := targetID

    ; 활성화
    WinGet, minMax, MinMax, ahk_id %targetID%
    if (minMax = -1)
        WinRestore, ahk_id %targetID%

    WinActivate, ahk_id %targetID%
    WinWaitActive, ahk_id %targetID%, , 1
}

MoveActiveWindow(deltaX, deltaY)
{
    WinGet, hwnd, ID, A
    if (!hwnd)
        return

    ; 최대화된 창은 이동하지 않음
    WinGet, currentState, MinMax, ahk_id %hwnd%
    if (currentState != 0)
        return

    ; 현재 창 위치 가져오기
    WinGetPos, winX, winY, winW, winH, ahk_id %hwnd%

    ; 새 위치 계산
    newX := winX + deltaX
    newY := winY + deltaY

    ; 창 이동
    WinMove, ahk_id %hwnd%, , %newX%, %newY%
}
