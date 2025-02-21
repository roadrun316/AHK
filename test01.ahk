#SingleInstance, Force
CoordMode, Mouse, Client

global COMMENT = 테스트입니다
global VERSION
global MODEL_NAME := 1
global APK_NAME = EM_Launcher
global ManifestCount := 4
global APK_MODEL := ""

global FOLDER_PATH = "R:\U100_Release\"

FormatTime, VERSION, %A_Now%, 3.MM.dd.1
FormatTime, Today,, yyyy_MMdd   ; 오늘 날짜를 YYYY-MM-DD 형식으로 가져오기
FOLDER_PATH := "R:\U100_Release\" . Today  ; 폴더 경로 지정

if (!FileExist(FOLDER_PATH)) {    ; 폴더가 존재하지 않으면
	FileCreateDir, %FOLDER_PATH%  ; 폴더 생성
}

; DataService
AppsKey & Numpad1::
	MODEL_NAME := 31
	APK_NAME = EM_DataService
	COMMENT = SA부팅시 KGM 로고 크기 처리 오류 수정
	return

; ScreenService
AppsKey & Numpad2::
	MODEL_NAME := 28
	APK_NAME = EM_ScreenService
	COMMENT = Power off 버튼 눌림효과. Power off 진입 애니메이션 중 버튼 클릭 비활성화

	return

; MicomService
AppsKey & Numpad3::
	MODEL_NAME := 34
	APK_NAME = EM_MicomService
	COMMENT = 상단바 Timeout 기본값: 고정 -> 10초로 수정
	return

; SystemService
AppsKey & Numpad4::
	MODEL_NAME := 35
	APK_NAME = EM_SystemService
	COMMENT = 터널 진입 OSD 안뜨는 문제 수정
	return

; AudioService
AppsKey & Numpad5::
	MODEL_NAME := 0
	APK_NAME = EM_AudioService
	COMMENT = AudioPath 6인경우 Path 1로 처리 (AA No Ducking 모드인경우. 6으로 처리시 라디오 소리 들림)
	return

; ClusterService
AppsKey & Numpad6::
	MODEL_NAME := 5
	APK_NAME = EM_ClusterService
	COMMENT = ArrayList remove시 ConcurrentModificationException 오류 수정
	return

; WatcherService
AppsKey & Numpad7::
	MODEL_NAME := 32
	APK_NAME = EM_WatcherService
	COMMENT = Memory Check 수정 (DB에러 개선)
	return

; CCU
AppsKey & Numpad8::
	MODEL_NAME := 18
	APK_NAME = EM_CCU
	COMMENT = All menu 화면 "차량설정" 눌림표시 지속됨 (타앱 선택/해제 해도 유지) https://digen.atlassian.net/browse/KGMO100-187
	return

; Launcher
AppsKey & Numpad9::
	MODEL_NAME := 1
	APK_NAME = EM_Launcher
	COMMENT = All menu 화면 "차량설정" 눌림표시 지속됨 (타앱 선택/해제 해도 유지) https://digen.atlassian.net/browse/KGMO100-187
	return

AppsKey & Numpad0::
	APK_MODEL = _J120.APK
	InputParameter()
	return

AppsKey & NumpadDot::
	APK_MODEL = .APK
	InputParameter()
	return


^!q:: ; Ctrl + Alt + Q
    ExitApp
return

InputParameter()
{
	; PROJECT NAME
	;~ Click, Left, 600, 460
	; J120_HQX
	;~ Click, Left, 600, %y%
	;~ Click, Left, 600, 661
	;~ Click, Left, 600, 693
	;~ Sleep, 500
	; MODEL NAME
	ClickModelName()
	Sleep, 200
	; Launcher
	Send, {Down %MODEL_NAME%}
	Send, {Enter}

	ClickApkVersion()
	Clipboard := "V"
	SendInput ^v
	Send, %VERSION%

	if (APK_MODEL == "_J120.APK")
		ClickCheckBox()

	ClickFile()
	Sleep, 2000
	FilePath := "E:\U100\App\Output\" . APK_NAME . APK_MODEL
	;~ FilePath := "E:\U100_checkout\u100-app\App\Output\" . APK_NAME . APK_MODEL
	Clipboard := FilePath ; 클립보드에 파일 경로 복사

	SendInput ^v{Enter}

	Sleep, 500
	CopyAPK(APK_NAME . APK_MODEL)

	;~ Send, {End}

	;~ Sleep, 2000

	ClickMessage()
	Sleep, 500
	Clipboard = %COMMENT%
	SendInput ^v

	CaptureScreen(APK_NAME)

}

global SearchX := 0
global SearchY := 0

ClickCheckBox()
{
	ModelImage := "checkbox.png"
	ModelImage2 := "checkbox2.png"

    ; 탐지 시작 좌표 초기화
    ; 이미지 크기 설정 (체크박스 이미지 크기를 정확히 입력)
    ImageWidth := 22 ; 체크박스 이미지 너비
    ImageHeight := 22 ; 체크박스 이미지 높이

    Loop {
        ; 화면에서 체크박스 이미지 검색
        ;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage%
		ImageSearch, FoundX, FoundY, 340, 600, 500, 1000, %ModelImage%

        ; 체크박스를 찾지 못하면 루프 종료
        if (ErrorLevel = 1) {
;            MsgBox, 모든 체크박스 클릭 완료!
            break
        }

        ; 중앙 좌표 계산
        CenterX := FoundX + 10
        CenterY := FoundY + 10

        ; 중앙으로 마우스 이동 후 클릭
        MouseMove, FoundX, FoundY
        Click

        ; 다음 검색 시작 위치 업데이트
        SearchX := FoundX + ImageWidth
        SearchY := FoundY
    }

	;~ SearchX := 0
	;~ SearchY := 0

	;~ ; 화면에서 체크박스 이미지 검색
	;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage2%

	;~ ; 체크박스를 찾지 못하면 루프 종료
	;~ if (ErrorLevel = 1) {
		;~ return
	;~ }

	;~ ; 중앙 좌표 계산
	;~ CenterX := FoundX + 10
	;~ CenterY := FoundY + 10

	;~ ; 중앙으로 마우스 이동 후 클릭
	;~ MouseMove, FoundX, FoundY
	;~ Click

	;~ SearchX := FoundX
    ;~ SearchY := FoundY
}

ClickModelName()
{
	ModelImage := "modelname.png"
	;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage%
	ImageSearch, FoundX, FoundY, 340, 300, 800, 600, %ModelImage%

	if (ErrorLevel = 1) {
		MsgBox, 오류 발생 ModelName
		ExitApp
	}
	else if (ErrorLevel = 2) {
		MsgBox, 0, 오류, 명령을 완료하는 데 문제가 발생했습니다. 이미지 파일이 존재하고 접근 가능한지 확인하세요. ErrorLevel = 2
		ExitApp
	}

		; 중앙 좌표 계산
	CenterX := FoundX + 50
	CenterY := FoundY + 30

	; 중앙으로 마우스 이동 후 클릭
	MouseMove, CenterX, CenterY
	Click

	SearchX := FoundX
    SearchY := FoundY

}

ClickApkVersion()
{
	ModelImage := "apk.png"
	StartTime := A_TickCount
	;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage%
	ImageSearch, FoundX, FoundY, 340, 600, 800, 1600, %ModelImage%
	;~ EndTime := A_TickCount
	;~ SpendTime := (EndTime - StartTime)
	;~ MsgBox, SpendTime: %SpendTime% msec

	if (ErrorLevel = 1) {
        return
	}

	CenterX := FoundX + 50
	CenterY := FoundY + 40

	MouseMove, CenterX, CenterY
	Click
}

ClickFile()
{
	ModelImage := "file.png"
	;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage%
	ImageSearch, FoundX, FoundY, 340, 600, 800, 1600, %ModelImage%

	if (ErrorLevel = 1) {
        return
	}

	CenterX := FoundX + 40
	CenterY := FoundY + 10

	MouseMove, CenterX, CenterY
	Click

	SearchX := FoundX
    SearchY := FoundY
}

ClickMessage()
{
	ModelImage := "message.png"
	;~ ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ModelImage%
	ImageSearch, FoundX, FoundY, 340, 800, 800, 1600, %ModelImage%

	if (ErrorLevel = 1) {
        return
	}

	CenterX := FoundX + 50
	CenterY := FoundY + 40

	MouseMove, CenterX, CenterY
	Click
}

CaptureScreen(apk)
{
	Run, python E:\GitHub\Python\CaptureScreen.py %apk%, ,Hide
	Sleep, 1000
}

CopyAPK(apk)
{
	Source := "E:\U100\App\Output\" . apk              ; 원본 파일 경로
    Destination := FOLDER_PATH . "\" . apk ; 복사할 대상 경로

    ; 파일이 존재하는지 확인
    FileCopy, %Source%, %Destination%, 0  ; 1 = 덮어쓰기 허용
}

