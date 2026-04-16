# Clipboard History Slots Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `clipboard_history.ahk` so one script can manage three independent clipboard history slots and cycle the active slot with a new `Alt+F24` hotkey.

**Architecture:** Replace the single global history array with slot-aware state: one active slot, one history array per slot, and one persistence file per slot. Keep the existing menu-based UX, but scope every action to the active slot and surface slot state clearly in tooltips and menu labels.

**Tech Stack:** AutoHotkey v1, menu-based desktop utility script, file persistence via `FileAppend`/`Loop, Read`

---

### Task 1: Convert global state to three slot-aware histories

**Files:**
- Modify: `clipboard_history.ahk`
- Test: manual verification in AutoHotkey by launching `clipboard_history.ahk`

- [ ] **Step 1: Add the first failing behavior check**

Define the expected behavior before editing:

- Startup should create in-memory state for slots 1, 2, and 3.
- `CurrentSlot` should begin at 1.
- Each slot should have an independent history array and file path.

Because this repository does not have an automated AutoHotkey test harness, use a temporary debug check inside the script while developing:

```ahk
ShowTooltip("DEBUG FAIL unless slot state exists", 1000)
```

Expected failure before implementation:
- No slot-aware state exists yet; only one `ClipboardHistory` array is present.

- [ ] **Step 2: Verify the current script lacks slot state**

Run:

```bash
AutoHotkey64.exe clipboard_history.ahk
```

Expected:
- Script still runs with the single-history model.
- There is no active-slot tooltip or slot-aware behavior.

- [ ] **Step 3: Implement minimal slot-aware globals**

Change the top-level state in `clipboard_history.ahk` to include:

```ahk
SlotCount := 3
CurrentSlot := 1
ClipboardHistories := []
HistoryFiles := []
```

Add an initialization function that creates empty arrays and file paths for slots 1..3.

- [ ] **Step 4: Verify initialization works**

Run:

```bash
AutoHotkey64.exe clipboard_history.ahk
```

Expected:
- Script launches without errors.
- Startup tooltip appears.
- No menu or save/load handler crashes due to missing arrays.

- [ ] **Step 5: Commit**

```bash
git add clipboard_history.ahk
git commit -m "refactor: prepare clipboard history slots"
```

### Task 2: Make copy, menu, delete, and clear behavior operate on the active slot

**Files:**
- Modify: `clipboard_history.ahk`
- Test: manual verification in AutoHotkey by launching `clipboard_history.ahk`

- [ ] **Step 1: Define the failing behavior**

Expected behavior:

- `^F24` saves into the active slot only.
- `F24` shows the active slot only.
- Delete and clear actions affect the active slot only.

Current failure:
- All handlers still read and write one shared history list.

- [ ] **Step 2: Verify the failure manually**

Run the script and note that there is no slot separation yet:

```bash
AutoHotkey64.exe clipboard_history.ahk
```

Expected:
- Saving and menu operations are still global rather than slot-specific.

- [ ] **Step 3: Implement minimal slot-scoped behavior**

Update these functions to use `ClipboardHistories[CurrentSlot]` or a helper that returns the active slot history:

- `AddToHistory(NewItem)`
- `ShowHistoryMenu()`
- `ShowDeleteMenu()`
- `PasteFromHistory()`
- `DeleteHistoryItem()`
- `DeleteLastUsedItem()`
- `ClearHistory()`

Update menu labels and empty-state labels to mention the active slot.

- [ ] **Step 4: Fix the existing paste tooltip bug while touching slot logic**

Inside `PasteFromHistory()`, assign the selected history entry before paste and use that value in the tooltip:

```ahk
selectedItem := activeHistory[index]
Clipboard := selectedItem
ShowTooltip("슬롯 " . CurrentSlot . " 붙여넣기: " . GetPreview(selectedItem), 1000)
```

- [ ] **Step 5: Verify slot-scoped behavior**

Manual test:

1. Start in slot 1.
2. Save two items with `^F24`.
3. Open the menu with `F24`.
4. Delete one item or clear the slot.

Expected:
- All visible operations refer to slot 1 only.
- Tooltip text uses the selected item correctly.

- [ ] **Step 6: Commit**

```bash
git add clipboard_history.ahk
git commit -m "feat: scope clipboard actions to active slot"
```

### Task 3: Add slot-cycling hotkey and slot-aware status messages

**Files:**
- Modify: `clipboard_history.ahk`
- Test: manual verification in AutoHotkey by launching `clipboard_history.ahk`

- [ ] **Step 1: Define the failing behavior**

Expected behavior:

- `!F24` cycles `1 -> 2 -> 3 -> 1`
- A tooltip announces the newly active slot

Current failure:
- No slot switch hotkey exists.

- [ ] **Step 2: Verify the failure**

Run:

```bash
AutoHotkey64.exe clipboard_history.ahk
```

Expected:
- Pressing `Alt+F24` does nothing.

- [ ] **Step 3: Implement minimal slot cycling**

Add:

```ahk
!F24::
    CycleClipboardSlot()
return
```

Implement `CycleClipboardSlot()` so it wraps inside `1..SlotCount` and shows a tooltip such as:

```ahk
ShowTooltip("클립보드 슬롯 " . CurrentSlot . " 활성화", 1200)
```

- [ ] **Step 4: Update startup help text**

Change the initial tooltip text to match actual bindings:

```ahk
ShowTooltip("클립보드 히스토리 활성화됨`nCtrl+F24: 복사 및 저장`nF24: 현재 슬롯 메뉴`nAlt+F24: 슬롯 전환", 3500)
```

- [ ] **Step 5: Verify slot switching**

Manual test:

1. Launch the script.
2. Press `Alt+F24` three times.

Expected:
- Tooltip shows slot 2, then slot 3, then slot 1.
- `F24` continues to show only the newly active slot.

- [ ] **Step 6: Commit**

```bash
git add clipboard_history.ahk
git commit -m "feat: add clipboard slot cycling hotkey"
```

### Task 4: Split persistence into one file per slot and verify restart behavior

**Files:**
- Modify: `clipboard_history.ahk`
- Create at runtime: `clipboard_history_1.txt`, `clipboard_history_2.txt`, `clipboard_history_3.txt`
- Test: manual verification in AutoHotkey by launching `clipboard_history.ahk`

- [ ] **Step 1: Define the failing behavior**

Expected behavior:

- Each slot saves and loads from its own file.
- Restart preserves the independence of all three slots.

Current failure:
- The script still uses one `clipboard_history.txt` file.

- [ ] **Step 2: Verify the failure**

Inspect the current persistence target in `clipboard_history.ahk`.

Expected:
- Only one history file path exists.

- [ ] **Step 3: Implement minimal slot-aware persistence**

Refactor persistence functions to accept a slot number:

```ahk
SaveHistoryToFile(slot)
LoadHistoryFromFile(slot)
```

Add an initializer that builds:

```ahk
HistoryFiles[1] := A_ScriptDir . "\clipboard_history_1.txt"
HistoryFiles[2] := A_ScriptDir . "\clipboard_history_2.txt"
HistoryFiles[3] := A_ScriptDir . "\clipboard_history_3.txt"
```

Startup should loop through all slots and load each file. `OnExit` should loop through all slots and save each one.

- [ ] **Step 4: Verify persistence**

Manual test:

1. Put different entries into slots 1 and 2.
2. Exit the script.
3. Relaunch the script.
4. Switch between slots and open the menu.

Expected:
- Each slot restores its own history from its own file.

- [ ] **Step 5: Inspect generated files**

Check that these files exist beside the script and contain the expected encoded entries:

```bash
ls -1 clipboard_history_*.txt
```

Expected:
- Three slot-specific history files are present after use.

- [ ] **Step 6: Commit**

```bash
git add clipboard_history.ahk clipboard_history_1.txt clipboard_history_2.txt clipboard_history_3.txt
git commit -m "feat: persist clipboard history per slot"
```

### Task 5: Final manual regression pass

**Files:**
- Modify: `clipboard_history.ahk` only if defects are found
- Test: manual verification in AutoHotkey by launching `clipboard_history.ahk`

- [ ] **Step 1: Run full manual verification**

Validate:

1. Slot 1 stores its own history.
2. Slot 2 stores different content.
3. Slot 3 empty state is correct before use.
4. Delete and clear operate only on the active slot.
5. Paste tooltip shows the right preview.
6. Restart reloads each slot independently.

- [ ] **Step 2: Fix only issues found during verification**

If a regression appears, make the smallest focused correction in `clipboard_history.ahk`.

- [ ] **Step 3: Re-run the manual verification**

Expected:
- All slot behaviors work as designed with no script errors.

- [ ] **Step 4: Commit**

```bash
git add clipboard_history.ahk
git commit -m "fix: finalize clipboard history slot behavior"
```
