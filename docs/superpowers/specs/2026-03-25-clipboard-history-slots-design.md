# Clipboard History Slots Design

**Date:** 2026-03-25

**Goal:** Extend `clipboard_history.ahk` so it can manage three independent clipboard history slots, while keeping the existing `F24`-based workflow and adding one slot-cycling hotkey.

## Context

The current script stores a single clipboard history list in memory and persists it to `clipboard_history.txt`. Copy capture is manual through `^F24`, and history paste is shown through `F24`. The script already supports delete and clear operations through menu handlers, but those handlers currently operate on the single global history array.

The user wants the same behavior duplicated across separate history groups, not a merged history with labels. The preferred interaction model is:

- Keep the existing `^F24` copy/save behavior.
- Keep the existing `F24` history menu behavior.
- Add one extra hotkey to cycle the active slot.
- Use exactly three slots.

## Recommended Approach

Use three independent history arrays in memory and three separate text files on disk:

- `clipboard_history_1.txt`
- `clipboard_history_2.txt`
- `clipboard_history_3.txt`

This keeps the code close to the existing design, avoids custom section parsing, and isolates corruption or manual edits to a single slot file.

## Data Model

Replace the single-history state with:

- `SlotCount := 3`
- `CurrentSlot := 1`
- `ClipboardHistories := []`
- `HistoryFiles := []`

Initialization will populate one empty array and one file path per slot. Each slot keeps the same `MaxHistoryItems` limit and the same encoding/decoding rules as the current implementation.

## Hotkeys

The hotkey behavior will be:

- `^F24`: copy with `Ctrl+C`, then save into the active slot
- `F24`: show the active slot's history menu
- `!F24`: cycle the active slot `1 -> 2 -> 3 -> 1`

The existing commented-out delete hotkeys remain untouched unless explicitly requested later. Delete and clear actions will continue to exist through the menu for the active slot only.

## Behavior Changes

### Copy capture

`AddToHistory(NewItem)` will write only to `ClipboardHistories[CurrentSlot]`.

Duplicate handling remains slot-local:

- If an item already exists in the current slot, remove the old entry.
- Insert the new entry at the front.
- Trim the slot back to `MaxHistoryItems`.

### History menu

`ShowHistoryMenu()` will render only the active slot's items. Empty-state text and action labels should mention the slot number so the user can immediately tell which list they are operating on.

### Delete and clear

`ShowDeleteMenu()`, `DeleteHistoryItem()`, `DeleteLastUsedItem()`, and `ClearHistory()` will operate only on the active slot's array and file.

### Slot switching

Cycling the slot will update `CurrentSlot` and show a tooltip such as `클립보드 슬롯 2 활성화`.

### Persistence

Startup loads all three slot files. Shutdown saves all three slot files. Missing files are treated as empty histories for their respective slots.

## Targeted Fixes Included With This Change

Two existing issues should be corrected while implementing the slot feature:

1. `PasteFromHistory()` currently shows a tooltip using `selectedItem`, but that variable is commented out before use. The tooltip should use the selected history item reliably.
2. The startup tooltip and some comments describe `Win+C` and `Win+Z`, while the actual active bindings are `^F24` and `F24`. The user-facing help text should match the real bindings.

## Error Handling

- Empty clipboard content is still ignored.
- Missing slot files are not errors.
- Menu handlers should guard against invalid indexes as they do now.
- Slot cycling should always wrap within `1..SlotCount`.

## Testing Plan

Manual verification should cover:

1. Save two items into slot 1 and confirm they appear only in slot 1.
2. Cycle to slot 2, save different items, and confirm slot 1 remains unchanged.
3. Cycle through slot 3 and verify empty-state messaging works there.
4. Delete an item in one slot and verify the other slots are unchanged.
5. Clear one slot and verify the other slots persist.
6. Restart the script and confirm each slot reloads from its own file.
7. Confirm paste tooltip text works after selecting a history entry.

## Files Expected To Change

- Modify `clipboard_history.ahk`
- Replace single-file persistence with three slot-specific files created beside the script as needed

## Risks

- The persistence format remains line-based and uses token replacement, so it still has the same edge case if raw clipboard text contains the reserved replacement markers.
- Because the script uses `Sleep` after copy and paste operations, timing behavior still depends on the target application. This change does not broaden that behavior; it only preserves it.
