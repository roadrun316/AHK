; ===================================================================================================
; EMAT AutoHotkey Script - 애플리케이션 전환 및 자동화 스크립트
; ===================================================================================================

; 중복 실행 방지
#SingleInstance Force
#SingleInstance Off

SetTitleMatchMode, 2

; ===================================================================================================
; TERATERM AUTOMATION
; ===================================================================================================
#IfWinActive ahk_exe ttermpro.exe
!1::
	sendInput setprop persist.hibernated 0{Enter}
	sendInput busybox mkswap /dev/block/mmcblk2p10{Enter}
return
!3:: sendInput cat /reserved1/model-release{Enter}
!4::
	sendInput cd sdcard{Enter}
	sendInput logcat -c{Enter}
	sendInput logcat -v time | grep EMS_TPEG > ems_log{Enter}
return
!0::
	sendInput touch /tmp/system_started{Enter}
	sendInput killall C300SystemService{Enter}
return
#IfWinActive
; ===================================================================================================
; WINDOWS TERMINAL AUTOMATION
; ===================================================================================================
#IfWinActive ahk_exe WindowsTerminal.exe
^NumpadDot:: sendInput adb disconnect
^Numpad0:: sendInput adb connect 192.168.3.3
^Numpad1:: sendInput adb shell cat /sdcard/EMLog/main/main.log | cgrep
^Numpad3:: sendInput grep -a AndroidRuntime main.log{Enter}
^Numpad4:: sendInput grep -a VERSION main.log{Enter}
;^Numpad7:: sendInput python e:\GitHub\Python\Y461\update_release.py{Enter}
^Numpad9::
	IfWinActive, wglim
		sendInput python /mnt/e/GitHub/Python/U100LogManager.py{Enter}
	else
		sendInput python E:\GitHub\Python\U100LogManager.py{Enter}
return
!Numpad3::
	IfWinActive, wglim
		sendInput cd /mnt/e/GitHub{Enter}
	else
	{
		sendInput E:{Enter}
		sendInput cd \GitHub{Enter}
	}
return
!Numpad4::
	IfWinActive, wglim
		sendInput cd /mnt/e/U100/App/Output{Enter}
	else
	{
		sendInput E: 
		sendInput cd \U100\App\Output{Enter}
	}
return
!Numpad5::
	IfWinActive, wglim
		sendInput cd /mnt/d/log{Enter}
	else
	{
		sendInput D:{Enter}
		sendInput cd \Log{Enter}
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
			sendInput cd "%Folder%/sdcard/EMLog/main"{Enter}
		else
			sendInput cd %Folder%/sdcard/WTLog/main{Enter}
	else
		IfExist, D:\Log\%Folder%\sdcard\EMLog
			sendInput cd %Folder%\sdcard\EMLog\main{Enter}
		else
			sendInput cd %Folder%\sdcard\WTLog\main{Enter}
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

^Numpad7::
  Run, python E:\GitHub\Python\GotoSource.py, ,Hide
  ;~ WinActivate, ahk_exe studio64.exe
  ;~ WinWaitActive, ahk_exe studio64.exe, , 5
  ;~ Send {Ctrl}G
  ;~ Sleep, 100
  ;~ ; 클립보드 내용 직접 전송
  ;~ Send %Clipboard%
  ;~ Send {Enter}Send 
return

^Numpad8::
	Reload
return

#NumpadAdd::Send {Media_Next}
#NumpadSub:: WinActivate, ahk_exe SMemo.exe
#NumpadDiv:: Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
#NumpadMult:: Run, E:\GitHub\AHK\keyboard_hook.ahk
^Numpad9:: sendRaw find / ! \( -path /proc -prune \) -name "*.rc" -exec grep -Hni XXX '{}' \;


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

#IfWinActive ahk_exe CLCL.exe
F19:: Send, {Esc}
#IfWinActive


F22:: Send, ○
F14:: Send, #+{Left} 
F15:: Send, #+{Right} 

; F19:: Send, !c ; clcl 호출
F19:: TOGGLE_TITLE("이쁜부인")
F21:: TOGGLE_EXE("dopus.exe")
F23:: Send, ^#!c ; Claunch 호출
; F18:: Send, ^!{Numpad7} ; clcl Template Coding 호출


; ===================================================================================================
; BROWSER & AI TOOLS (CTRL+ALT+WIN+F Keys)
; ===================================================================================================
^!+#F19:: TOGGLE_EXE("dopus.exe")
^!+#F20:: TOGGLE_TITLE("Whale", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\네이버 웨일.lnk")
^!+#F22:: TOGGLE_TITLE("이쁜부인")
^!+#F23:: GoAndroidStudio(0)
^!+#F24:: GoAndroidStudio(1)
;^!#F7:: TOGGLE_EXE("Perplexity.exe", "C:\Users\roadr\AppData\Local\Programs\Perplexity\Perplexity.exe")
;^!#F8:: TOGGLE_EXE("ChatGPT.exe", "C:\Users\roadr\AppData\Local\Microsoft\WindowsApps\chatgpt.exe")
;^!#F9:: TOGGLE_TITLE("Google Gemini", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts\9501e18d7c2ab92e\원규 - Chrome.lnk")
;^!#F10:: TOGGLE_EXE("msedge.exe")
;^!#F11:: TOGGLE_TITLE("Chrome", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Chrome.lnk")
;^!#F12:: TOGGLE_TITLE("Whale", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\네이버 웨일.lnk")

;^!#F1:: TOGGLE_TITLE("Google AI Studio", "C:\Users\roadr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\네이버 웨일 앱\Google AI Studio.lnk")
;^!#F2:: TOGGLE_EXE("Joplin.EXE", "C:\Program Files\Joplin\Joplin.exe")

Macro_ClusterAppUpload()
{
	Send, adb shell{Enter}
	Send, su{Enter}
	Send, ssh root@192.168.1.1{Enter}
	Sleep, 1000
	Send, yes{Enter}
	Send, slay vt_avm{Enter}
	Send, cd /data/vt_avm_file{Enter}
	Send, chmod 777 MvFile.sh{Enter}
	Send, ./MvFile.sh{Enter}
	Send, /usr/bin/vt_avm &{Enter}
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

^!#F6::
;        Menu, MyFolderMenu, DeleteAll
	Menu, MyFolderMenu2, Add, GPU 부하 측정, MenuHandler2
	Menu, MyFolderMenu2, Add, Cluster App Upload, MenuHandler2
	Menu, MyFolderMenu2, Add, (닫힘), DummyHandler
	Menu, MyFolderMenu2, Show
return

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
    ; 2. 현재 창이 Windows 탐색기일 경우 → 경로 변경
    WinGetClass, activeClass, A
    if (activeClass = "CabinetWClass") {
        Send, !d       ; Alt + D → 주소창
        Sleep, 100
        Send, %path%{Enter}
        return
    }
    if WinActive("ahk_exe WindowsTerminal.exe") 
    {
		IfWinActive, wglim
		{
			linuxPath := ConvertToLinuxPath(path)
			SendInput, cd %linuxPath%{Enter}
		}
		else 
		{
			drive := SubStr(path, 1, 2)      ; 예: D:
			subPath := SubStr(path, 3)       ; 예: \Download 또는 \Users\Me...
			SendInput, %drive% & cd %subPath%{Enter}
		}
		return
    }
    ; 3. 기본 동작 (DOpus로 열림)
    Run, %path%
}
TOGGLE_TITLE(procName, filePath="") {
    if WinActive("" . procName)
        WinMinimize, %procName%
    else {
    WinGet, processID, PID, %procName%
        if (!processID) {
            ; 프로세스가 실행 중이 아니면 실행
            if (filePath != "") {
                Run, %filePath%
            } 
        } else {
            WinActivate, %procName%
        }
    }
}
TOGGLE_EXE(procName, filePath="") {
    if WinActive("ahk_exe " . procName)
        WinMinimize, ahk_exe %procName%
    else {
		WinGet, processID, ID, ahk_exe %procName%
        if (!processID) {
            ; 프로세스가 실행 중이 아니면 실행
            if (filePath != "") {
                Run, %filePath%
            } 
        } else {
            WinActivate, ahk_exe %procName%
        }
    }
}
GoAndroidStudio(opt)
{
    WinGet, id, List, ahk_class SunAwtFrame ahk_exe studio64.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, title, ahk_id %this_id%
        ; opt=0: U100만 포함
        ; opt=1: U100, Logcat 포함
        if (opt = 0 && (!InStr(title, "U100") || InStr(title, "Logcat")))
            continue
        if (opt = 1 && !InStr(title, "Logcat"))
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
		sendInput cd %A_ThisMenuItem%/sdcard/EMLog/main{Enter}
	Else
		sendInput cd %A_ThisMenuItem%/sdcard/WTLog/main{Enter}
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
		SendInput, cd /mnt/d/log/%SelectedPath%/sdcard/EMLog/main{Enter}
	}
	else
	{
		SendInput, cd %SelectedPath%\sdcard\EMLog\main
	}
return
; ===================================================================================================
; HOTSTRINGS & TEXT EXPANSION
; ===================================================================================================
:*:date..::
FormatTime, CurrentDateDate,%A_Now%, yyyy년 M월 d일  ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDateDate%
return
:*:time..::
FormatTime, CurrentDateTime, %A_Now%, yyyy년 M월 d일 h:mm ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDateTime%
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

