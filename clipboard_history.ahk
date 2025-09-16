#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; 클립보드 히스토리 설정
MaxHistoryItems := 20  ; 최대 히스토리 개수
ClipboardHistory := []  ; 히스토리 배열
HistoryFile := A_ScriptDir . "\clipboard_history.txt"  ; 히스토리 파일

; 스크립트 시작 시 히스토리 로드
LoadHistoryFromFile()

; Win+C: 복사하고 히스토리에 저장
^F24::
    ; 기본 복사 실행 (Ctrl+C)
    Send ^c
    Sleep 100  ; 복사 완료 대기
    
    ; 클립보드 내용을 히스토리에 추가
    AddToHistory(Clipboard)
    
    ; 상태 표시
    ShowTooltip("복사됨: " . GetPreview(Clipboard), 1500)
return

; Win+Z: 히스토리 선택 메뉴 표시
F24::
    ShowHistoryMenu()
return

; Ctrl+Delete: 삭제 메뉴 표시
;^Delete::
;    ShowDeleteMenu()
;return

; Shift+Delete: 최근 항목 바로 삭제
;+Delete::
;    DeleteLastUsedItem()
;return

; 히스토리에 새 항목 추가
AddToHistory(NewItem) {
    global ClipboardHistory, MaxHistoryItems
    
    ; 빈 내용이면 추가하지 않음
    if (StrLen(Trim(NewItem)) = 0)
        return
    
    ; 중복 제거: 이미 존재하면 해당 항목을 맨 앞으로 이동
    for index, item in ClipboardHistory {
        if (item = NewItem) {
            ClipboardHistory.RemoveAt(index)
            break
        }
    }
    
    ; 맨 앞에 새 항목 추가
    ClipboardHistory.InsertAt(1, NewItem)
    
    ; 최대 개수 초과 시 마지막 항목 제거
    if (ClipboardHistory.MaxIndex() > MaxHistoryItems) {
        ClipboardHistory.RemoveAt(MaxHistoryItems + 1)
    }
    
    ; 히스토리 파일에 저장
    SaveHistoryToFile()
}

; 히스토리 메뉴 표시
ShowHistoryMenu() {
    global ClipboardHistory
    
    ; 기존 메뉴 삭제
    Menu, ClipHistoryMenu, Add, Temp, DummyFunction
    Menu, ClipHistoryMenu, DeleteAll
    
    ; 히스토리가 비어있으면 메시지 표시
    if (ClipboardHistory.MaxIndex() = 0 || ClipboardHistory.MaxIndex() = "") {
        Menu, ClipHistoryMenu, Add, (히스토리 없음), DummyFunction
        Menu, ClipHistoryMenu, Disable, (히스토리 없음)
    } else {
        ; 히스토리 항목들을 메뉴에 추가
        for index, item in ClipboardHistory {
            preview := GetPreview(item)
            menuText := index . ". " . preview
            Menu, ClipHistoryMenu, Add, %menuText%, PasteFromHistory
        }
        
        ; 구분선과 관리 옵션 추가
        Menu, ClipHistoryMenu, Add,
        Menu, ClipHistoryMenu, Add, 개별 삭제 메뉴, ShowDeleteMenu
        Menu, ClipHistoryMenu, Add, 히스토리 지우기, ClearHistory
    }
    
    ; 메뉴 표시
    Menu, ClipHistoryMenu, Show
}

; 삭제 전용 메뉴 표시
ShowDeleteMenu() {
    global ClipboardHistory
    
    ; 기존 메뉴 삭제
    Menu, ClipDeleteMenu, Add, Temp, DummyFunction
    Menu, ClipDeleteMenu, DeleteAll
    
    ; 히스토리가 비어있으면 메시지 표시
    if (ClipboardHistory.MaxIndex() = 0 || ClipboardHistory.MaxIndex() = "") {
        Menu, ClipDeleteMenu, Add, (삭제할 항목 없음), DummyFunction
        Menu, ClipDeleteMenu, Disable, (삭제할 항목 없음)
    } else {
        ; 삭제할 항목들을 메뉴에 추가
        for index, item in ClipboardHistory {
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
    global ClipboardHistory
    
    ; 메뉴 텍스트에서 인덱스 추출 (1. preview -> 1)
    RegExMatch(A_ThisMenuItem, "^(\d+)\.", match)
    index := match1
    
    if (index > 0 && index <= ClipboardHistory.MaxIndex()) {
        ; 클립보드에 선택한 항목 설정
        Clipboard := ClipboardHistory[index]
        Sleep 50
        
        ; 붙여넣기 실행
        Send ^v
        
        ; 선택한 항목을 맨 앞으로 이동 (최근 사용순 정렬)
;        selectedItem := ClipboardHistory[index]
;        ClipboardHistory.RemoveAt(index)
;        ClipboardHistory.InsertAt(1, selectedItem)
;        SaveHistoryToFile()
        
        ; 상태 표시
        ShowTooltip("붙여넣기: " . GetPreview(selectedItem), 1000)
    }
}

; 개별 히스토리 항목 삭제
DeleteHistoryItem() {
    global ClipboardHistory
    
    ; 메뉴 텍스트에서 인덱스 추출 (삭제: 1. preview -> 1)
    RegExMatch(A_ThisMenuItem, "삭제: (\d+)\.", match)
    index := match1
    
    if (index > 0 && index <= ClipboardHistory.MaxIndex()) {
        ; 삭제할 항목의 미리보기
        itemPreview := GetPreview(ClipboardHistory[index])
        
        ; 확인 메시지
        MsgBox, 4, 확인, 다음 항목을 삭제하시겠습니까?`n`n"%itemPreview%"
        IfMsgBox Yes
        {
            ; 항목 삭제
            ClipboardHistory.RemoveAt(index)
            SaveHistoryToFile()
            ShowTooltip("항목이 삭제되었습니다", 1000)
        }
    }
}

; 최근 사용한 항목 삭제 (첫 번째 항목)
DeleteLastUsedItem() {
    global ClipboardHistory
    
    if (ClipboardHistory.MaxIndex() > 0) {
        ; 첫 번째 항목의 미리보기
        itemPreview := GetPreview(ClipboardHistory[1])
        
        ; 확인 메시지
        MsgBox, 4, 확인, 최근 사용 항목을 삭제하시겠습니까?`n`n"%itemPreview%"
        IfMsgBox Yes
        {
            ; 첫 번째 항목 삭제
            ClipboardHistory.RemoveAt(1)
            SaveHistoryToFile()
            ShowTooltip("최근 사용 항목이 삭제되었습니다", 1000)
        }
    } else {
        ShowTooltip("삭제할 히스토리 항목이 없습니다", 1000)
    }
}

; 히스토리 지우기
ClearHistory() {
    global ClipboardHistory
    
    MsgBox, 4, 확인, 클립보드 히스토리를 모두 지우시겠습니까?
    IfMsgBox Yes
    {
        ClipboardHistory := []
        SaveHistoryToFile()
        ShowTooltip("히스토리가 지워졌습니다", 1000)
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

; 히스토리를 파일에 저장
SaveHistoryToFile() {
    global ClipboardHistory, HistoryFile
    
    FileDelete, %HistoryFile%
    
    for index, item in ClipboardHistory {
        ; 특수 문자 처리를 위해 구분자 사용
        encodedItem := StrReplace(item, "|", "｜")  ; | 문자를 전각 문자로 대체
        encodedItem := StrReplace(encodedItem, "`n", "｜n｜")  ; 줄바꿈 처리
        encodedItem := StrReplace(encodedItem, "`r", "｜r｜")  ; 캐리지 리턴 처리
        
        FileAppend, %encodedItem%`n, %HistoryFile%
    }
}

; 파일에서 히스토리 로드
LoadHistoryFromFile() {
    global ClipboardHistory, HistoryFile
    
    if !FileExist(HistoryFile)
        return
    
    ClipboardHistory := []
    
    Loop, Read, %HistoryFile%
    {
        if (A_LoopReadLine != "") {
            ; 인코딩된 내용 복원
            decodedItem := StrReplace(A_LoopReadLine, "｜r｜", "`r")
            decodedItem := StrReplace(decodedItem, "｜n｜", "`n")
            decodedItem := StrReplace(decodedItem, "｜", "|")
            
            ClipboardHistory.Push(decodedItem)
        }
    }
}

; 더미 함수 (메뉴 오류 방지)
DummyFunction() {
    return
}

; 스크립트 종료 시 히스토리 저장
OnExit("SaveOnExit")

SaveOnExit() {
    SaveHistoryToFile()
}

; 초기 로드 완료 알림
ShowTooltip("클립보드 히스토리 활성화됨`nWin+C: 복사 및 저장`nWin+Z: 히스토리 메뉴`nCtrl+Delete: 삭제 메뉴`nShift+Delete: 최근 항목 삭제", 3500)