#SingleInstance,Force
; 체크박스 이미지 파일 경로
CheckBoxImage := "checkbox.png"

; 핫키 설정 (예: F1 키를 눌러 실행)
F1::
    ; 탐지 시작 좌표 초기화
    SearchX := 0
    SearchY := 0
    ; 이미지 크기 설정 (체크박스 이미지 크기를 정확히 입력)
    ImageWidth := 20 ; 체크박스 이미지 너비
    ImageHeight := 20 ; 체크박스 이미지 높이

    Loop {
        ; 화면에서 체크박스 이미지 검색
        ImageSearch, FoundX, FoundY, SearchX, SearchY, A_ScreenWidth, A_ScreenHeight, %CheckBoxImage%

        ; 체크박스를 찾지 못하면 루프 종료
        if (ErrorLevel = 1) {
;            MsgBox, 모든 체크박스 클릭 완료!
            break
        }

        ; 중앙 좌표 계산
        CenterX := FoundX + (ImageWidth // 2)
        CenterY := FoundY + (ImageHeight // 2)

        ; 중앙으로 마우스 이동 후 클릭
        MouseMove, CenterX, CenterY
        Click

        ; 다음 검색 시작 위치 업데이트
        SearchX := FoundX + ImageWidth
        SearchY := FoundY
    }
return
