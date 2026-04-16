#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; ==== Clipboard History Settings ====
MaxHistoryItems := 20  ; 슬롯별 최대 히스토리 개수
SlotCount := 3
CurrentSlot := 1
ClipboardHistories := []
HistoryFiles := []
LegacyHistoryFile := A_ScriptDir . "\clipboard_history.txt"

; 스크립트 시작 시 슬롯 초기화 및 히스토리 로드
InitializeHistorySlots()
LoadAllHistoryFromFiles()

; Ctrl+F24: 복사하고 현재 슬롯 히스토리에 저장
^F24::
    ; 기본 복사 실행 (Ctrl+C)
    Send ^c
    Sleep 100  ; 복사 완료 대기
    
    ; 클립보드 내용을 히스토리에 추가
    AddToHistory(Clipboard)
    
    ; 상태 표시
    ShowTooltip(GetSlotLabel() . " 복사됨: " . GetPreview(Clipboard), 1500)
return

; F24: 현재 슬롯 히스토리 선택 메뉴 표시
F24::
    ShowHistoryMenu()
return

; Alt+F24: 활성 슬롯 순환 전환
!F24::
    CycleClipboardSlot()
return

; Ctrl+Delete: 삭제 메뉴 표시
;^Delete::
;    ShowDeleteMenu()
;return

; Shift+Delete: 최근 항목 바로 삭제
;+Delete::
;    DeleteLastUsedItem()
;return

; ==== Slot Initialization ====
InitializeHistorySlots() {
    global ClipboardHistories, HistoryFiles, SlotCount
    
    ClipboardHistories := []
    HistoryFiles := []
    
    Loop, %SlotCount%
    {
        slot := A_Index
        ClipboardHistories[slot] := []
        HistoryFiles[slot] := A_ScriptDir . "\clipboard_history_" . slot . ".txt"
    }
}

LoadAllHistoryFromFiles() {
    global SlotCount
    
    Loop, %SlotCount%
        LoadHistoryFromFile(A_Index)
}

GetSlotHistory(slot := "") {
    global ClipboardHistories, CurrentSlot
    
    if (slot = "")
        slot := CurrentSlot
    
    if !IsObject(ClipboardHistories[slot])
        ClipboardHistories[slot] := []
    
    return ClipboardHistories[slot]
}

GetSlotLabel(slot := "") {
    global CurrentSlot
    
    if (slot = "")
        slot := CurrentSlot
    
    return "슬롯 " . slot
}

IsHistoryEmpty(history) {
    return (history.MaxIndex() = "" || history.MaxIndex() = 0)
}

CycleClipboardSlot() {
    global CurrentSlot, SlotCount
    
    CurrentSlot += 1
    if (CurrentSlot > SlotCount)
        CurrentSlot := 1
    
    ShowTooltip("클립보드 " . GetSlotLabel() . " 활성화", 1200)
}

; ==== History Actions ====
; 현재 슬롯 히스토리에 새 항목 추가
AddToHistory(NewItem) {
    global CurrentSlot, MaxHistoryItems
    history := GetSlotHistory()
    
    ; 빈 내용이면 추가하지 않음
    if (StrLen(Trim(NewItem)) = 0)
        return
    
    ; 중복 제거: 이미 존재하면 해당 항목을 맨 앞으로 이동
    for index, item in history {
        if (item = NewItem) {
            history.RemoveAt(index)
            break
        }
    }
    
    ; 맨 앞에 새 항목 추가
    history.InsertAt(1, NewItem)
    
    ; 최대 개수 초과 시 마지막 항목 제거
    if (history.MaxIndex() > MaxHistoryItems) {
        history.RemoveAt(MaxHistoryItems + 1)
    }
    
    ; 현재 슬롯 히스토리 파일에 저장
    SaveHistoryToFile(CurrentSlot)
}

; 현재 슬롯 히스토리 메뉴 표시
ShowHistoryMenu() {
    history := GetSlotHistory()
    slotLabel := GetSlotLabel()
    
    ; 기존 메뉴 삭제
    Menu, ClipHistoryMenu, Add, Temp, DummyFunction
    Menu, ClipHistoryMenu, DeleteAll
    
    ; 히스토리가 비어있으면 메시지 표시
    if (IsHistoryEmpty(history)) {
        emptyText := slotLabel . " (히스토리 없음)"
        Menu, ClipHistoryMenu, Add, %emptyText%, DummyFunction
        Menu, ClipHistoryMenu, Disable, %emptyText%
    } else {
        ; 히스토리 항목들을 메뉴에 추가
        for index, item in history {
            preview := GetPreview(item)
            menuText := index . ". " . preview
            Menu, ClipHistoryMenu, Add, %menuText%, PasteFromHistory
        }
        
        ; 구분선과 관리 옵션 추가
        deleteMenuText := slotLabel . " 개별 삭제 메뉴"
        clearMenuText := slotLabel . " 히스토리 지우기"
        Menu, ClipHistoryMenu, Add,
        Menu, ClipHistoryMenu, Add, %deleteMenuText%, ShowDeleteMenu
        Menu, ClipHistoryMenu, Add, %clearMenuText%, ClearHistory
    }
    
    ; 메뉴 표시
    Menu, ClipHistoryMenu, Show
}

; 현재 슬롯 삭제 전용 메뉴 표시
ShowDeleteMenu() {
    history := GetSlotHistory()
    slotLabel := GetSlotLabel()
    
    ; 기존 메뉴 삭제
    Menu, ClipDeleteMenu, Add, Temp, DummyFunction
    Menu, ClipDeleteMenu, DeleteAll
    
    ; 히스토리가 비어있으면 메시지 표시
    if (IsHistoryEmpty(history)) {
        emptyText := slotLabel . " (삭제할 항목 없음)"
        Menu, ClipDeleteMenu, Add, %emptyText%, DummyFunction
        Menu, ClipDeleteMenu, Disable, %emptyText%
    } else {
        ; 삭제할 항목들을 메뉴에 추가
        for index, item in history {
            preview := GetPreview(item)
            deleteText := "삭제: " . index . ". " . preview
            Menu, ClipDeleteMenu, Add, %deleteText%, DeleteHistoryItem
        }
        
        ; 구분선과 취소 옵션
        Menu, ClipDeleteMenu, Add,
        Menu, ClipDeleteMenu, Add, 취소, DummyFunction
    }
    
    ; 메뉴 표시
    Menu, ClipDeleteMenu, Show
}

; 히스토리에서 선택한 항목 붙여넣기
PasteFromHistory() {
    history := GetSlotHistory()
    
    ; 메뉴 텍스트에서 인덱스 추출 (1. preview -> 1)
    RegExMatch(A_ThisMenuItem, "^(\d+)\.", match)
    index := match1
    
    if (index > 0 && index <= history.MaxIndex()) {
        ; 클립보드에 선택한 항목 설정
        selectedItem := history[index]
        Clipboard := selectedItem
        Sleep 50
        
        ; 붙여넣기 실행
        Send ^v
        
        ; 선택한 항목을 맨 앞으로 이동 (최근 사용순 정렬)
;        history.RemoveAt(index)
;        history.InsertAt(1, selectedItem)
;        SaveHistoryToFile(CurrentSlot)
        
        ; 상태 표시
        ShowTooltip(GetSlotLabel() . " 붙여넣기: " . GetPreview(selectedItem), 1000)
    }
}

; 개별 히스토리 항목 삭제
DeleteHistoryItem() {
    global CurrentSlot
    history := GetSlotHistory()
    slotLabel := GetSlotLabel()
    
    ; 메뉴 텍스트에서 인덱스 추출 (삭제: 1. preview -> 1)
    RegExMatch(A_ThisMenuItem, "^삭제: (\d+)\.", match)
    index := match1
    
    if (index > 0 && index <= history.MaxIndex()) {
        ; 삭제할 항목의 미리보기
        itemPreview := GetPreview(history[index])
        confirmMessage := slotLabel . "에서 다음 항목을 삭제하시겠습니까?`n`n""" . itemPreview . """"
        
        ; 확인 메시지
        MsgBox, 4, 확인, %confirmMessage%
        IfMsgBox Yes
        {
            ; 항목 삭제
            history.RemoveAt(index)
            SaveHistoryToFile(CurrentSlot)
            ShowTooltip(slotLabel . " 항목이 삭제되었습니다", 1000)
        }
    }
}

; 최근 사용한 항목 삭제 (첫 번째 항목)
DeleteLastUsedItem() {
    global CurrentSlot
    history := GetSlotHistory()
    slotLabel := GetSlotLabel()
    
    if !IsHistoryEmpty(history) {
        ; 첫 번째 항목의 미리보기
        itemPreview := GetPreview(history[1])
        confirmMessage := slotLabel . "의 최근 사용 항목을 삭제하시겠습니까?`n`n""" . itemPreview . """"
        
        ; 확인 메시지
        MsgBox, 4, 확인, %confirmMessage%
        IfMsgBox Yes
        {
            ; 첫 번째 항목 삭제
            history.RemoveAt(1)
            SaveHistoryToFile(CurrentSlot)
            ShowTooltip(slotLabel . " 최근 사용 항목이 삭제되었습니다", 1000)
        }
    } else {
        ShowTooltip(slotLabel . " 삭제할 히스토리 항목이 없습니다", 1000)
    }
}

; 현재 슬롯 히스토리 지우기
ClearHistory() {
    global ClipboardHistories, CurrentSlot
    slotLabel := GetSlotLabel()
    confirmMessage := slotLabel . " 히스토리를 모두 지우시겠습니까?"
    
    MsgBox, 4, 확인, %confirmMessage%
    IfMsgBox Yes
    {
        ClipboardHistories[CurrentSlot] := []
        SaveHistoryToFile(CurrentSlot)
        ShowTooltip(slotLabel . " 히스토리가 지워졌습니다", 1000)
    }
}

; 텍스트 미리보기 생성 (한 줄로 축약, 최대 60자)
GetPreview(text) {
    ; 줄바꿈 제거하고 공백 정리
    preview := RegExReplace(text, "\r?\n", " ")
    preview := RegExReplace(preview, "\s+", " ")
    preview := Trim(preview)
    
    ; 길이 제한
    if (StrLen(preview) > 60) {
        preview := SubStr(preview, 1, 57) . "..."
    }
    
    ; 빈 내용 처리
    if (StrLen(preview) = 0) {
        preview := "(빈 내용)"
    }
    
    return preview
}

; 툴팁 표시
ShowTooltip(message, duration := 1000) {
    ToolTip, %message%
    SetTimer, RemoveTooltip, -%duration%
}

RemoveTooltip:
    ToolTip
return

; ==== File Persistence ====
; 특정 슬롯 히스토리를 파일에 저장
SaveHistoryToFile(slot) {
    global HistoryFiles
    history := GetSlotHistory(slot)
    historyFile := HistoryFiles[slot]
    
    FileDelete, %historyFile%
    
    if (IsHistoryEmpty(history)) {
        FileAppend,, %historyFile%
        return
    }
    
    for index, item in history {
        ; 특수 문자 처리를 위해 구분자 사용
        encodedItem := StrReplace(item, "|", "｜")  ; | 문자를 전각 문자로 대체
        encodedItem := StrReplace(encodedItem, "`n", "｜n｜")  ; 줄바꿈 처리
        encodedItem := StrReplace(encodedItem, "`r", "｜r｜")  ; 캐리지 리턴 처리
        
        FileAppend, %encodedItem%`n, %historyFile%
    }
}

; 특정 슬롯 히스토리를 파일에서 로드
LoadHistoryFromFile(slot) {
    global ClipboardHistories, HistoryFiles, LegacyHistoryFile
    historyFile := HistoryFiles[slot]
    
    ClipboardHistories[slot] := []
    
    if !FileExist(historyFile) {
        if (slot = 1 && FileExist(LegacyHistoryFile))
            historyFile := LegacyHistoryFile
        else
            return
    }
    
    Loop, Read, %historyFile%
    {
        if (A_LoopReadLine != "") {
            ; 인코딩된 내용 복원
            decodedItem := StrReplace(A_LoopReadLine, "｜r｜", "`r")
            decodedItem := StrReplace(decodedItem, "｜n｜", "`n")
            decodedItem := StrReplace(decodedItem, "｜", "|")
            
            ClipboardHistories[slot].Push(decodedItem)
        }
    }
}

; 더미 함수 (메뉴 오류 방지)
DummyFunction() {
    return
}

; 스크립트 종료 시 히스토리 저장
OnExit("SaveOnExit")

SaveOnExit(exitReason := "", exitCode := 0) {
    global SlotCount
    
    Loop, %SlotCount%
        SaveHistoryToFile(A_Index)
}

; 초기 로드 완료 알림
ShowTooltip("클립보드 히스토리 활성화됨`nCtrl+F24: 복사 및 저장`nF24: 현재 슬롯 메뉴`nAlt+F24: 슬롯 전환", 3500)


