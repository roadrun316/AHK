#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Ŭ������ �����丮 ����
MaxHistoryItems := 20  ; �ִ� �����丮 ����
ClipboardHistory := []  ; �����丮 �迭
HistoryFile := A_ScriptDir . "\clipboard_history.txt"  ; �����丮 ����

; ��ũ��Ʈ ���� �� �����丮 �ε�
LoadHistoryFromFile()

; Win+C: �����ϰ� �����丮�� ����
^F24::
    ; �⺻ ���� ���� (Ctrl+C)
    Send ^c
    Sleep 100  ; ���� �Ϸ� ���
    
    ; Ŭ������ ������ �����丮�� �߰�
    AddToHistory(Clipboard)
    
    ; ���� ǥ��
    ShowTooltip("�����: " . GetPreview(Clipboard), 1500)
return

; Win+Z: �����丮 ���� �޴� ǥ��
F24::
    ShowHistoryMenu()
return

; �����丮�� �� �׸� �߰�
AddToHistory(NewItem) {
    global ClipboardHistory, MaxHistoryItems
    
    ; �� �����̸� �߰����� ����
    if (StrLen(Trim(NewItem)) = 0)
        return
    
    ; �ߺ� ����: �̹� �����ϸ� �ش� �׸��� �� ������ �̵�
    for index, item in ClipboardHistory {
        if (item = NewItem) {
            ClipboardHistory.RemoveAt(index)
            break
        }
    }
    
    ; �� �տ� �� �׸� �߰�
    ClipboardHistory.InsertAt(1, NewItem)
    
    ; �ִ� ���� �ʰ� �� ������ �׸� ����
    if (ClipboardHistory.MaxIndex() > MaxHistoryItems) {
        ClipboardHistory.RemoveAt(MaxHistoryItems + 1)
    }
    
    ; �����丮 ���Ͽ� ����
    SaveHistoryToFile()
}

; �����丮 �޴� ǥ��
ShowHistoryMenu() {
    global ClipboardHistory
    
    ; ���� �޴� ����
    Menu, ClipHistoryMenu, Add, Temp, DummyFunction
    Menu, ClipHistoryMenu, DeleteAll
    
    ; �����丮�� ��������� �޽��� ǥ��
    if (ClipboardHistory.MaxIndex() = 0 || ClipboardHistory.MaxIndex() = "") {
        Menu, ClipHistoryMenu, Add, (�����丮 ����), DummyFunction
        Menu, ClipHistoryMenu, Disable, (�����丮 ����)
    } else {
        ; �����丮 �׸���� �޴��� �߰�
        for index, item in ClipboardHistory {
            preview := GetPreview(item)
            menuText := index . ". " . preview
            Menu, ClipHistoryMenu, Add, %menuText%, PasteFromHistory
        }
        
        ; ���м��� ���� �ɼ� �߰�
        Menu, ClipHistoryMenu, Add,
        Menu, ClipHistoryMenu, Add, �����丮 �����, ClearHistory
    }
    
    ; �޴� ǥ��
    Menu, ClipHistoryMenu, Show
}

; �����丮���� ������ �׸� �ٿ��ֱ�
PasteFromHistory() {
    global ClipboardHistory
    
    ; �޴� �ؽ�Ʈ���� �ε��� ���� (1. preview -> 1)
    RegExMatch(A_ThisMenuItem, "^(\d+)\.", match)
    index := match1
    
    if (index > 0 && index <= ClipboardHistory.MaxIndex()) {
        ; Ŭ�����忡 ������ �׸� ����
        Clipboard := ClipboardHistory[index]
        Sleep 50
        
        ; �ٿ��ֱ� ����
        Send ^v
        
        ; ������ �׸��� �� ������ �̵� (�ֱ� ���� ����)
        selectedItem := ClipboardHistory[index]
        ClipboardHistory.RemoveAt(index)
        ClipboardHistory.InsertAt(1, selectedItem)
        SaveHistoryToFile()
        
        ; ���� ǥ��
        ShowTooltip("�ٿ��ֱ�: " . GetPreview(selectedItem), 1000)
    }
}

; �����丮 �����
ClearHistory() {
    global ClipboardHistory
    
    MsgBox, 4, Ȯ��, Ŭ������ �����丮�� ��� ����ðڽ��ϱ�?
    IfMsgBox Yes
    {
        ClipboardHistory := []
        SaveHistoryToFile()
        ShowTooltip("�����丮�� ���������ϴ�", 1000)
    }
}

; �ؽ�Ʈ �̸����� ���� (�� �ٷ� ���, �ִ� 60��)
GetPreview(text) {
    ; �ٹٲ� �����ϰ� ���� ����
    preview := RegExReplace(text, "\r?\n", " ")
    preview := RegExReplace(preview, "\s+", " ")
    preview := Trim(preview)
    
    ; ���� ����
    if (StrLen(preview) > 60) {
        preview := SubStr(preview, 1, 57) . "..."
    }
    
    ; �� ���� ó��
    if (StrLen(preview) = 0) {
        preview := "(�� ����)"
    }
    
    return preview
}

; ���� ǥ��
ShowTooltip(message, duration := 1000) {
    ToolTip, %message%
    SetTimer, RemoveTooltip, -%duration%
}

RemoveTooltip:
    ToolTip
return

; �����丮�� ���Ͽ� ����
SaveHistoryToFile() {
    global ClipboardHistory, HistoryFile
    
    FileDelete, %HistoryFile%
    
    for index, item in ClipboardHistory {
        ; Ư�� ���� ó���� ���� ������ ���
        encodedItem := StrReplace(item, "|", "��")  ; | ���ڸ� ���� ���ڷ� ��ü
        encodedItem := StrReplace(encodedItem, "`n", "��n��")  ; �ٹٲ� ó��
        encodedItem := StrReplace(encodedItem, "`r", "��r��")  ; ĳ���� ���� ó��
        
        FileAppend, %encodedItem%`n, %HistoryFile%
    }
}

; ���Ͽ��� �����丮 �ε�
LoadHistoryFromFile() {
    global ClipboardHistory, HistoryFile
    
    if !FileExist(HistoryFile)
        return
    
    ClipboardHistory := []
    
    Loop, Read, %HistoryFile%
    {
        if (A_LoopReadLine != "") {
            ; ���ڵ��� ���� ����
            decodedItem := StrReplace(A_LoopReadLine, "��r��", "`r")
            decodedItem := StrReplace(decodedItem, "��n��", "`n")
            decodedItem := StrReplace(decodedItem, "��", "|")
            
            ClipboardHistory.Push(decodedItem)
        }
    }
}

; ���� �Լ� (�޴� ���� ����)
DummyFunction() {
    return
}

; ��ũ��Ʈ ���� �� �����丮 ����
OnExit("SaveOnExit")

SaveOnExit() {
    SaveHistoryToFile()
}

; �ʱ� �ε� �Ϸ� �˸�
ShowTooltip("Ŭ������ �����丮 Ȱ��ȭ��`nWin+C: ���� �� ����`nWin+Z: �����丮 �޴�", 2000)