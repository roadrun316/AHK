#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

LogFolder := "d:\log"
MaxFolders := 20
MenuTitle := "최근 로그 폴더 선택"

global FolderPaths

F1::
{
  ; 메뉴가 없으면 임시로 생성 (오류 방지)
  Menu, LogFolderMenu, Add, Temp, DummyFunction
  Menu, LogFolderMenu, DeleteAll  ; 기존 메뉴 초기화

  FolderList := GetRecentFolders(LogFolder, MaxFolders)

  if (FolderList = "")
  {
    MsgBox, 48, Error, 로그 폴더가 존재하지 않거나 비어 있습니다: %LogFolder%
    return
  }

  FolderPaths := {}

  Loop, Parse, FolderList, `n
  {
    FolderName := A_LoopField
    if (FolderName != "")
    {
		SplitPath, FolderName, NameOnly  ; 폴더 경로에서 폴더 이름만 추출
      FolderPaths .= FolderName . "`n"
      Menu, LogFolderMenu, Add, %NameOnly%, GoToFolder
    }
  }
  Menu, LogFolderMenu, Show, , , %MenuTitle%
  return
}

GoToFolder() {
  ;~ LinuxPath := ConvertToLinuxPath(A_ThisMenuItem)
  send, cd %A_ThisMenuItem%/sdcard/EMLog/main{Enter}
  return
}

ConvertToLinuxPath(winPath) {
  ;~ drive := SubStr(winPath, 1, 1)  ; 드라이브 문자 추출
  ;~ drive := Format("{:L}", drive)  ; 소문자로 변환
  ;~ rest := SubStr(winPath, 3)  ; 드라이브 문자 이후 경로
  StringReplace, rest, rest, \, /, All  ; 백슬래시를 슬래시로 변경
  ;~ return "/mnt/" . drive . rest
  return rest
}

DummyFunction() {
  return
}

GetRecentFolders(FolderPath, MaxCount) {
    if !FileExist(FolderPath) {
        return ""
    }

    FileList := []
    Loop, Files, %FolderPath%\*, D
    {
        ; 파일의 경로와 수정 시간을 배열에 저장
        FileList.Push(A_LoopFileLongPath "|" A_LoopFileTimeModified)
    }

    ; 최신순으로 수정시간을 기준으로 정렬
    FileList.Sort((a, b) => StrSplit(b, "|")[2] - StrSplit(a, "|")[2])

    OutputList := ""
    Loop, % Min(MaxCount, FileList.MaxIndex())
    {
        ; 파일 경로만 추출하여 출력
        FilePath := StrSplit(FileList[A_Index], "|")[1]
        OutputList .= FilePath . "`n"
    }

    return OutputList
}
