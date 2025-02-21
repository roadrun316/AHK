#SingleInstance,Force

SetBatchLines, -1
SendMode, Input

ocrPath := "C:\Program Files\Tesseract-OCR\tesseract.exe" ; Tesseract 경로
screenshot := "D:\Util\aaa.png"
outputText := "D:\Util\result"

; F9 키로 OCR 실행
F9::
    ; 화면 캡처 (드래그로 영역 선택)
    ;~ RunWait, mshta "javascript:var sh=new ActiveXObject('WScript.Shell');sh.SendKeys('^{PRTSC}');close()",, Hide

    ;~ ; 클립보드 이미지 저장
    ;~ Clipboard := ""
    ;~ Send, ^v
    ;~ ClipWait, 2
    ;~ if !ClipboardAll
    ;~ {
        ;~ MsgBox, NO IMAGE.
        ;~ return
    ;~ }
    ;~ FileDelete, %screenshot%
    ;~ FileAppend, %ClipboardAll%, %screenshot%

    ; Tesseract OCR 실행
    RunWait, %ocrPath% "%screenshot%" "%outputText%" --oem 1 --psm 3, , Hide

    ; 결과 읽기
    FileRead, ocrResult, %outputText%.txt
    MsgBox, Text:`n%ocrResult%
return
