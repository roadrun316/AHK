SetTitleMatchMode, 2

; ---------------------------------------------------------------------------------------------------
; TeraTerm
; ---------------------------------------------------------------------------------------------------
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
; ---------------------------------------------------------------------------------------------------
; Windows Terminal
; ---------------------------------------------------------------------------------------------------
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
	    IfExist, D:\Log\%Folder%\sdcard\EMLog  ; EMLog ������ �ִ��� Ȯ��
			sendInput cd %Folder%/sdcard/EMLog/main{Enter}
        else
			sendInput cd %Folder%/sdcard/WTLog/main{Enter}
	else
		IfExist, D:\Log\%Folder%\sdcard\EMLog  ; EMLog ������ �ִ��� Ȯ��
			sendInput cd %Folder%\sdcard\EMLog\main{Enter}
		else
			sendInput cd %Folder%\sdcard\WTLog\main{Enter}
return
; --- �ڵ� ---
;!Numpad7:: RecentlyFolder() ; ����Ű F1 (���ϴ� Ű�� ���� ����)
;!Numpad7:: ShowRecentLogFolders()
!Numpad7:: GoRecentlyFolder()
#IfWinActive 
; ---------------------------------------------------------------------------------------------------
; Launcher_Mail
; ---------------------------------------------------------------------------------------------------
; Launch_Mail: ���콺 BackKey�� Launch_Mail Ű�� �Ҵ�
; ���� ���̳� ���� �����ڿ��� Launch Mail Ű�� Ctrl+F4 ������
#IfWinActive ahk_exe studio64.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe cursor.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe code.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe dopus.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe Notepad.exe
Launch_Mail::Send, ^{F4}
#IfWinActive ahk_exe Merge.exe
Launch_Mail::Send, ^{F4}
; �� ������������ Ctrl+W�� �� �ݱ�
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
; ��Ű ���ؽ�Ʈ �ʱ�ȭ
#IfWinActive

Launch_Mail:: Send, !{F4}
; ---------------------------------------------------------------------------------------------------
; Global
; ---------------------------------------------------------------------------------------------------
;SC11D:: return
AppsKey & D::OpenOrSetDialog("D:\Download")
AppsKey & L::OpenOrSetDialog("D:\Log")
AppsKey & U::OpenOrSetDialog("C:\Users\roadr")
AppsKey & O::OpenOrSetDialog("E:\U100\App\Output")
AppsKey & G::OpenOrSetDialog("E:\GitHub")
AppsKey & P::OpenOrSetDialog("E:\GitHub\Python")
AppsKey & T::OpenOrSetDialog("R:\Temp")
AppsKey & K::OpenOrSetDialog("C:\Users\roadr\Documents\īī���� ���� ����")
AppsKey & R::OpenOrSetDialog("R:\OneDrive")

^Volume_Mute:: MsgBox, Mute

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
	Menu, MyFolderMenu, Add, C:\Users\roadr\Documents\īī���� ���� ����, MenuHandler
	Menu, MyFolderMenu, Add, (����), DummyHandler
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

; ---------------------------------------------------------------------------------------------------
#Numpad0:: TOGGLE_EXE("WindowsTerminal.exe", "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.22.11141.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe")
;	TOGGLE_TITLE("��� ������Ʈ")
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
    hwnd := WinExist("emat.ahk")
    if (hwnd) {
        if WinActive("ahk_id " hwnd)
            WinMinimize, ahk_id %hwnd%
        else
            WinActivate, ahk_id %hwnd%
    } else {
        Run, "C:\Program Files\Notepad3\Notepad3.exe" R:\OneDrive\Environment\���� ��ġ ����\emat.ahk
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
  ;~ Sleep 100
  ;~ ; Ŭ������ ���� ���� ����
  ;~ Send %Clipboard%
  ;~ Send {Enter}Send 
return

^Numpad8::
	Reload
return

#NumpadAdd::Send {Media_Next}
#NumpadSub:: WinActivate, ahk_exe SMemo.exeSend 
#NumpadDiv:: Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
#NumpadMult:: Run, E:\GitHub\AHK\keyboard_hook.ahk
^Numpad9:: sendRaw find / ! \( -path /proc -prune \) -name "*.rc" -exec grep -Hni XXX '{}' \;SendSend 


; ---------------------------------------------------------------------------------------------------
; Clauch ����� ����Ű ó��
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


F15:: Send, ��

F19:: Send, !c ; clcl ȣ��
F21:: TOGGLE_EXE("dopus.exe")
F22:: TOGGLE_TITLE("�̻ۺ���")
F23:: Send, ^#!c ; Claunch ȣ��
F18:: Send, ^!{Numpad7} ; clcl Template Coding ȣ��

; ---------------------------------------------------------------------------------------------------
^!#F7:: TOGGLE_EXE("Perplexity.exe", "C:\Users\roadr\AppData\Local\Programs\Perplexity\Perplexity.exe")
^!#F8:: TOGGLE_EXE("ChatGPT.exe", "C:\Users\roadr\AppData\Local\Microsoft\WindowsApps\chatgpt.exe")
^!#F9:: TOGGLE_TITLE("Google Gemini", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts\9501e18d7c2ab92e\���� - Chrome.lnk")
^!#F10:: TOGGLE_EXE("msedge.exe")
^!#F11:: TOGGLE_TITLE("Chrome", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Chrome.lnk")
^!#F12:: TOGGLE_TITLE("Whale", "C:\Users\roadr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\���̹� ����.lnk")

^!#F1:: TOGGLE_TITLE("Google AI Studio", "C:\Users\roadr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\���̹� ���� ��\Google AI Studio.lnk")
^!#F2:: TOGGLE_EXE("Joplin.EXE", "C:\Program Files\Joplin\Joplin.exe")

Macro_ClusterAppUpload()
{
	Send, adb shell{Enter}
	Send, su{Enter}
	Send, ssh root@192.168.1.1{Enter}
	Sleep 1000
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
	Sleep 1000
	Send, yes{Enter}
	Send, echo gpu_set_log_level 4 >/dev/kgsl-control{Enter}
	Sleep 1000
	Send, echo gpubusystats 400 >/dev/kgsl-control{Enter}
	Sleep 1000
	Send, slog2info -b KGSL -w | grep measurement | grep 'percentage busy' | awk '{{}print ($NF){}}\'{Enter}
;	Send, slog2info -b KGSL -w | grep measurement | grep "percentage busy" | awk '{print ($NF)}'{Enter}
}

^!#F6::
;        Menu, MyFolderMenu, DeleteAll
	Menu, MyFolderMenu2, Add, GPU ���� ����, MenuHandler2
	Menu, MyFolderMenu2, Add, Cluster App Upload, MenuHandler2
	Menu, MyFolderMenu2, Add, (����), DummyHandler
	Menu, MyFolderMenu2, Show
return

MenuHandler2:
    global isMenuVisible2
    selectedMacro := A_ThisMenuItem
    if (selectedMacro = "GPU ���� ����")
    {
        Macro_GPU_busy()
    }
    else if (selectedMacro = "Cluster App Upload")
    {
        Macro_ClusterAppUpload()
    }
    isMenuVisible2 := false
return


; -------------------------------------------------------------------Send --------------------------------
#F2::
	Run, "C:\Program Files\Notepad3\Notepad3.exe"
return
; Notepad++���� Ctrl+���콺 ��Ŭ���� AndroidStudio �ҽ��� �̵�
^RButton::
  IfWinActive ahk_class Notepad++
  {
	  sendInput {Home}{ShiftDown}{End}{ShiftUp}^c
	  Sleep 100
	  Run, python E:\GitHub\Python\GotoSource.py, ,Hide
	  ;~ Sleep 1000
;	  WinActivate, ahk_exe studio64.exe
		;~ GoAndroidStudio()
	}
return
;OpenOrSetDialog(path) {
;     ���� ����â(class: #32770) �˻�
;    WinGet, winList, List, ahk_class #32770
;    Loop, %winList%
;    {
;        this_id := winList%A_Index%
;        ControlGet, exist, Hwnd,, Edit1, ahk_id %this_id%
;        if (exist) {
;             Edit1�� �����ϴ� ��� = ���� ����â ����
;            ControlSetText, Edit1, %path%, ahk_id %this_id%
;            ControlSend, Edit1, {Enter}, ahk_id %this_id%
;            return
;        }
;    }
;     ������ Ž���� ����
;    Run, %path%
;}
OpenOrSetDialog(path) {
    ; 1. ���� ���� ��ȭ���� (#32770 + Edit1) Ȯ��
    WinGet, winList, List, ahk_class #32770
    Loop, %winList%
    {
        this_id := winList%A_Index%
		; â�� ���� ����(exe) �̸� Ȯ��
		WinGet, exeName, ProcessName, ahk_id %this_id%
		if (exeName = "YES24eBook.exe")
			continue  ; �� â�� �����ϰ� ���� â���� �Ѿ
        ControlGet, exist, Hwnd,, Edit1, ahk_id %this_id%
        if (exist) {
            ControlSetText, Edit1, %path%, ahk_id %this_id%
            ControlSend, Edit1, {Enter}, ahk_id %this_id%
            return
        }
    }
    ; 2. ���� â�� Windows Ž������ ��� �� ��� ����
    WinGetClass, activeClass, A
    if (activeClass = "CabinetWClass") {
        Send, !d       ; Alt + D �� �ּ�â
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
			drive := SubStr(path, 1, 2)      ; ��: D:
			subPath := SubStr(path, 3)       ; ��: \Download �Ǵ� \Users\Me...
			SendInput, %drive% & cd %subPath%{Enter}
		}
		return
    }
    ; 3. �⺻ ���� (DOpus�� ����)
    Run, %path%
}
TOGGLE_TITLE(procName, filePath="") {
    if WinActive("" . procName)
        WinMinimize, %procName%
    else {
    WinGet, processID, PID, %procName%
        if (!processID) {
            ; ���μ����� ���� ���� �ƴϸ� ����
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
            ; ���μ����� ���� ���� �ƴϸ� ����
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
        ; opt=0: U100�� ����
        ; opt=1: U100, Logcat ����
        if (opt = 0 && (!InStr(title, "U100") || InStr(title, "Logcat")))
            continue
        if (opt = 1 && !InStr(title, "Logcat"))
            continue
        ; ��� ����
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
            Send, ^%opt% ; opt�� 1�̸� Ctrl+1
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
            Send, ^%opt% ; opt�� 1�̸� Ctrl+1
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
            Send, ^%opt% ; opt�� 1�̸� Ctrl+1
            Sleep, 100
        }
        return
    }
    return
}
GoTab(TargetTitle)
{
;  DetectHiddenWindows, On ; ������ â�� �����ϵ��� ����
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
      break ; ���ϴ� ���� ã������ ���� ����
    }
  }
  ; Edge
;  If TabCount = 0 ; Chrome���� ��ã������ Edge���� ã��
;  {
;    Loop, % WinExist("ahk_exe msedge.exe")
;    {
;      ControlGetText, TabText, Chrome_RenderWidgetHostHWND%A_Index%, ahk_exe msedge.exe
;		MsgBox, TabText
;      If (InStr(TabText, TargetTitle))
;      {
;        ControlFocus, Chrome_RenderWidgetHostHWND%A_Index%, ahk_exe msedge.exe
;        WinActivate, ahk_class msedge
;        break ; ���ϴ� ���� ã������ ���� ����
;      }
;    }
;  }
;  DetectHiddenWindows, Off ; ������ â ���� ���� ����
  if TabCount = 0
    MsgBox, 48, ã�� ����, "%TargetTitle%"��(��) �����ϴ� ���� ã�� �� �����ϴ�.
  return
}
; --- ���� ---
global LogFolder := "D:\Log"  ; �α� ���� ���
global MaxFolders := 5  ; �޴��� ǥ���� �ִ� ���� ����
global MenuTitle := "�ֱ� �α� ���� ����"  ; �޴� ����
global FolderPaths
GetRecentFolders(FolderPath, MaxCount)
{
	FolderPath := "D:\Log"
  if !FileExist(FolderPath)
  {
	MsgBox, Log ������ ����
    return ""
  }
  FileList := ""
  Loop, Files, %FolderPath%\*, D
  {
    FileList .= A_LoopFileLongPath . "|" . A_LoopFileTimeModified . "`n"
  }
  ; �ֽż� ����
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
    ; �޴� �ʱ�ȭ
    Menu, RecentFolders, Add, __dummy__, DummyHandler
    Menu, RecentFolders, DeleteAll
    ; ���� ��������
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
    ; �޴� ����
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
	IfExist, D:\Log\%A_ThisMenuItem%\sdcard\EMLog  ; EMLog ������ �ִ��� Ȯ��
		sendInput cd %A_ThisMenuItem%/sdcard/EMLog/main{Enter}
	Else
		sendInput cd %A_ThisMenuItem%/sdcard/WTLog/main{Enter}
  return
}
ConvertToLinuxPath(winPath) {
  drive := SubStr(winPath, 1, 1)  ; ����̺� ���� ����
  drive := Format("{:L}", drive)  ; �ҹ��ڷ� ��ȯ
  rest := SubStr(winPath, 3)  ; ����̺� ���� ���� ���
  StringReplace, rest, rest, \, /, All  ; �齽���ø� �����÷� ����
  return "/mnt/" . drive . rest
}
GoRecentlyFolder()
{
    ; Python �����Ͽ� �ֱ� ���� ��� ��������
    RunWait, %ComSpec% /c python "E:\GitHub\Python\GotoRecentlyFolder.py", , Hide
    ; ��µ� ���� ��� �б�E:\GitHub\Python\GotoRecentlyFolder.pynE:\GitHub\Python\GotoRecentlyFolder.pyE:\GitHub\Python\GotoRecentlyFolder.py
    FileRead, folderList, %A_Temp%\folders.txt
    StringSplit, lines, folderList, :
    ; �޴� ���� ����� (���� �޴� ������ �ʰ� ���� ����)
    Menu, RecentFolders, Add, [�ֱ� ���� ����], dummyHandler
    Menu, RecentFolders, Disable, [�ֱ� ���� ����]
;     ���� �׸��� �ִٸ� ����
;    Loop
;    {
;        Menu, RecentFolders, Delete, %A_Index%
;        if ErrorLevel
;            break
;    }
    ; �ֱ� ���� �׸� �߰�
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
;#Numpad0::
;	GroupAdd, AndroidStudioGroup, ahk_exe studio64.exe
;	If WinActive("ahk_exe studio64.exe")
;		GroupActivate, AndroidStudioGroup
;	else
;		WinActivate ahk_exe studio64.exe
	;GoAndroidStudio()
;	return
;#Numpad2::
;	if WinActivate, Logcat - U100
;	{
;		msgbox, "Hello"
;		WinHide, Logcat - U100
;	}
;	else
;		WinActivate, Logcat - U100
;	return
;#Numpad4::
;  WinActivate, ahk_exe notepad++.exe
;  return
;#Numpad5::
	 ;Autohotkey script to auto-connect to SSH using Teraterm
	 ;����
;	ip := "192.168.3.105"  ; IP �ּҸ� �Է��ϼ���
;	username := "root"  ; SSH ����� �̸�
;	password := "root"  ; SSH ��й�ȣ
;	teraterm_path := "C:\Program Files (x86)\teraterm\ttermpro.exe"  ; Teraterm ���
	 ;Teraterm ���� �� ����
;	Run, %teraterm_path% /ssh %ip%, , , pid
;	WinWait, ahk_pid %pid%
	 ;â�� Ȱ��ȭ�� ������ ���
;	WinActivate, ahk_pid %pid%
;	 �α��� ���� �Է�
;	Sleep, 1000  ; Teraterm�� ������ �ε�ǵ��� ��� ���
;	Send, %username%{Enter}
;	Sleep, 500  ; �ణ�� ��� �ð� �߰�
;	Send, %password%{Enter}
;~ AppsKey & Numpad1::
	;~ ;sendInput ls -r logcat.0* logcat | xargs grep
	;~ sendInput cat sdcard/WTLog/main/main.log.01 sdcard/WTLog/main/main.log | grep -E "logcatlog|EMLauncher:|EMAudioService:|MicomService:|DataService:|ScreenService:|ActivityManager:|SystemService:" | ~/Build_Desktop/LogColor
	;~ return
:*:date..::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateDate,%A_Now%, yyyy�� M�� d��  ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDateDate%
return
:*:time..::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime, %A_Now%, yyyy�� M�� d�� h:mm ; It will look like 9/1/2005 3:53 PM
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
;:*:hi..::
;	msgbox "�ȳ�"
;     ���� Ŭ������ ������ ���
;    ClipboardBackup := ClipboardAll
;    Clipboard := ""  ; Ŭ�����带 ����� �غ�
;    ClipWait, 0.5  ; Ŭ�����尡 ����� ������ ��� ���
;     �ؽ�Ʈ�� Ŭ�����忡 �����ϰ� �ٿ��ֱ�
;    Clipboard := "Hello.`n�̸˼���Ʈ �ӿ����Դϴ�.`n"
;    ClipWait, 0.5  ; Ŭ�����忡 ������ ������ ������ ��� ���
;     �ٿ��ֱ� (Ctrl+V)
;    Send, ^v
;    Sleep, 50  ; �ٿ��ֱ� �� ��� ���
;     ���� Ŭ������ ���� ����
;    Clipboard := ClipboardBackup
;    ClipboardBackup := ""  ; �ӽ� Ŭ������ ���� �����
;return
:*:hi..::�ȳ��ϼ���`n�̸˼���Ʈ �ӿ����Դϴ�.`n
::(1)::��
::(2)::��
::(3)::��
::(4)::��
::(5)::��
::(6)::��
::(7)::��
::(8)::��
::(9)::��
::(10)::��

;!3::
;	switch (IsTeraTerm())
;	{
;		case 1:
;		sendInput cd /usr/bin/C300{Enter}
;		case 2:
;		sendInput C300Log_All.bat messages
;	}
;return
;!4::
;	switch (IsTeraTerm())
;	{
;		case 1:
;		sendInput cat /reserved1/model-release{Enter}
;		case 2:
;		sendInput C300Log_Normal_carplay.bat messages
;	}
;return
;!5::
;	sendInput cd sdcard{Enter}
;	sendInput logcat -c{Enter}
;	sendInput logcat -v time | grep EMS_TPEG > ems_log{Enter}
;return
;!0::
;	switch (IsTeraTerm())
;	{
;		case 1:
;			sendInput touch /tmp/system_started{Enter}
;			sendInput killall C300SystemService{Enter}
;			return
;		case 2:
;		{
;		sendInput ssh-keygen -R 192.168.10.95 {Enter}
;		sendInput ssh-keygen -R 192.168.10.96 {Enter}
;		}
;	}
;return
;!Numpad0::
;	sendInput ls -t *.tar.gz | head -1 | xargs tar xfz{Enter}
;return
;!Numpad1::
;	switch (IsTeraTerm())
;	{
;		case 2:
;			sendInput adb shell cat /sdcard/WTLog/main/main.log | grep
;			return
;		case 1:
;			sendInput tail -F /var/log/messages | grep
;			return
;	}
;return
;!Numpad2::
;switch (IsTeraTerm())
;	{
;		case 2:
;			sendInput adb shell cat /sdcard/WTLog/main/main.log.01 /sdcard/WTLog/main/main.log | grep
;			return
;		case 1:
;			sendInput cat /var/log/messages | grep
;			return
;	}
;return
;!Numpad3::
;	sendInput cat logdata_full.u100 | grep -E "logcatlog|EMLOG|EMLauncher:|EMAudioService:|MicomService:|DataService:|ScreenService:|SystemService:" | ~/Build_Desktop/LogColor
;return
;!Numpad4::
;	sendInput adb logcat -G 64M
;return
;!Numpad7::
;	sendInput adb shell cat /sdcard/WTLog/main/main.log.01 /sdcard/WTLog/main/main.log | grep -a -E "EMLOG|logcatlog|EMLauncher:|EMAudioService:|MicomService:|DataService:|ScreenService:|SystemService:" | ~/Build_Desktop/LogColor
;return
;^Numpad0::
;	sendInput adb connect 192.168.3.3
;return
;^Numpad1::
;  sendInput adb shell killall com.ematsoft.dataservice{Enter}
;	sendInput adb shell am start-foreground-service com.ematsoft.dataservice/.EMDataService{Enter}
;return
;^Numpad2::
;  sendInput adb shell killall com.ematsoft.screenservice{Enter}
;	sendInput adb shell am start-foreground-service com.ematsoft.screenservice/.EMScreenService{Enter}
;return
;^Numpad3::
;  sendInput adb shell killall com.ematsoft.micomservice{Enter}
;	sendInput adb shell am start-foreground-service com.ematsoft.micomservice/.EMMicomService{Enter}
;return
;^Numpad4::
;  sendInput adb shell killall com.ematsoft.systemservice{Enter}
;	sendInput adb shell am start-foreground-service com.ematsoft.systemservice/.EMSystemService{Enter}
;return
;^Numpad5::
;  sendInput adb shell killall com.ematsoft.audioservice{Enter}
;	sendInput adb shell am start-foreground-service com.ematsoft.audioservice/.EMAudioService{Enter}
;return
;^Numpad6::
;  sendInput adb shell killall com.ematsoft.clusterservice{Enter}
;  sendInput adb shell am start-foreground-service com.ematsoft.clusterservice/.EMClusterService{Enter}
;	Run "C:\Program Files (x86)\teraterm\ttermpro.exe" /C=37 /SPEED=114200
;return
;^Numpad4::
;	FormatTime, TimeString
;	send %TimeString%.
;return
;~ #Numpad7::
    ;~ send scp wglim@192.168.3.225:/home/wglim/batch/wificon.sh /reserved1/{Enter}
    ;~ sleep 1000
	;~ sendInput yes{Enter}
    ;~ sleep 1000
	;~ sendInput emat{Enter}
;~ return
;~ ;
;^Numpad8::
;    send scp wglim@192.168.3.225:/home/wglim/batch/wificon.sh /reserved1/{Enter}
;	sleep 500
;	sendInput emat{Enter}
;	sleep 500
;	sendInput scp wglim@192.168.3.225:/home/wglim/build/Y450SA_32bit/LogColor/LogColor /usr/bin/C300/{Enter}
;	sleep 500
;	sendInput emat{Enter}
;	sleep 500
;	sendInput scp wglim@192.168.3.225:/home/wglim/batch/s_run.sh /lib/systemd/scripts/{Enter}
;	sleep 500
;	sendInput emat{Enter}
;return
;
;~ #Numpad9::
	;~ send scp wglim@192.168.3.195:/home/wglim/batch/wificon.sh /reserved1/{Enter}
	;~ sleep 500
	;~ sendInput emat{Enter}
	;~ sleep 500
	;~ sendInput scp wglim@192.168.3.195:/home/wglim/build/Y450AVN_64bit/LogColor/LogColor /usr/bin/C300/{Enter}
	;~ sleep 500
	;~ sendInput emat{Enter}
	;~ sleep 500
	;~ sendInput scp wglim@192.168.3.195:/home/wglim/batch/s_run.sh /lib/systemd/scripts/{Enter}
	;~ sleep 500
	;~ sendInput emat{Enter}
	;~ sleep 500
	;~ sendInput scp wglim@192.168.3.195:/home/wglim/batch/*.service /lib/systemd/system/{Enter}
	;~ sleep 500
	;~ sendInput emat{Enter}
;~ return
