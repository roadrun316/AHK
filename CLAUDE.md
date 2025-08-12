# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AutoHotkey automation repository containing scripts for:
- Build automation and APK deployment workflows
- GUI automation using image recognition
- Window management and application switching
- OCR screen capture functionality
- Keyboard shortcuts and hotkey management

## AutoHotkey Version Compatibility

The codebase contains scripts for both AutoHotkey v1.1 and v2.0:

- **v1.1 scripts**: `test01.ahk`, `test_ocr.ahk`, `checkbox_click.ahk`, `win_hotkey.ahk`, `test_folder.ahk`
- **v2.0 scripts**: `hotkey.ahk`, `test_v2.ahk`
- **v1.1 directives**: `#SingleInstance, Force`, `#NoEnv`, `SendMode Input`
- **v2.0 directives**: `#Requires AutoHotkey v2.0`, `#SingleInstance Force`

When modifying existing files, maintain the original AutoHotkey version syntax and patterns.

## Key Architecture Components

### Build Automation System (`test01.ahk`)
- **Main workflow**: APK build automation with GUI interaction
- **Project detection**: Automated project name detection via Python script (`getProjectName.py`)
- **Image recognition**: Uses `.png` files for UI element detection
- **File operations**: APK copying to release folders with date-based organization
- **External integrations**: Python scripts for screen capture and project detection

### Core Functions Structure
```autohotkey
// Main automation workflow
InputParameter() -> CheckProjectName() -> ClickModelName() -> ClickApkVersion() -> ClickFile() -> CopyAPK() -> CaptureScreen()

// Project name mapping logic
CheckProjectName() // Maps git branch names to project identifiers (U100, J110, J116, J120, J140, O100, U105, etc.)

// GUI automation functions
ClickModelName() // Image search and click for model selection
ClickApkVersion() // APK version input automation  
ClickFile() // File selection dialog automation
ClickCheckBox() // Automated checkbox clicking in UI
ClickMessage() // Message input automation
```

### Image Recognition Pattern
All GUI automation relies on PNG image templates stored in the root directory:
- `modelname.png` - Model selection dropdown
- `apk.png` - APK version field
- `file.png` - File selection button
- `message.png` - Message input field
- `checkbox.png`, `checkbox2.png` - UI checkboxes

### Hotkey Mapping System
Global hotkeys use `AppsKey + Numpad` combinations:
- `AppsKey & Numpad1-9`: Set predefined APK configurations
- `AppsKey & Numpad0`: Execute full automation workflow
- `AppsKey & NumpadDot`: Project name detection only

### External Dependencies
- **Python scripts**: Located in `E:\GitHub\Python\`
  - `getProjectName.py` - Git branch detection
  - `CaptureScreen.py` - Screenshot automation
- **Tesseract OCR**: Used in `test_ocr.ahk` for text recognition
- **GDI+ functions**: Custom image manipulation functions

## File Patterns and Conventions

### Global Variables Pattern
```autohotkey
global COMMENT = "Description text"
global VERSION, MODEL_INDEX, APK_NAME, PROJECT_NAME, APK_MODEL
```

### Error Handling Pattern
```autohotkey
if (ErrorLevel = 1) {
    MsgBox Error message
    ExitApp
}
```

### Image Search Pattern
```autohotkey
ImageSearch, FoundX, FoundY, StartX, StartY, EndX, EndY, %ImageFile%
CenterX := FoundX + OffsetX
CenterY := FoundY + OffsetY
MouseMove, CenterX, CenterY
Click
```

## Development Workflow

### Running Scripts
- Execute `.ahk` files directly with AutoHotkey
- Test individual functions by adding temporary hotkeys
- Use `OutputDebug` for debugging (view in DebugView)

### Testing Image Recognition
1. Update PNG template images when UI changes
2. Adjust search coordinates in `ImageSearch` calls
3. Test coordinate calculations for click positions
4. Verify `ErrorLevel` handling for failed searches

### Adding New Automation
1. Create PNG templates for new UI elements
2. Add hotkey bindings following existing patterns
3. Implement error handling for all `ImageSearch` operations
4. Use global variables for configuration data

## File Organization

- **Primary automation**: `test01.ahk` (main build workflow)
- **Backup files**: `.bak` extensions contain previous versions
- **Test scripts**: `test_*.ahk` for experimental features
- **Utility scripts**: `win_hotkey.ahk`, `checkbox_click.ahk` for specific tasks
- **Image assets**: PNG files in root directory for GUI recognition