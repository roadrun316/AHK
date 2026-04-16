# Repository Guidelines

## Project Structure & Module Organization
- Root directory holds AutoHotkey v1 scripts by feature: `clipboard_history.ahk`, `emat.ahk`, `win_hotkey.ahk`, etc.
- `.bak` companions capture the previous revision of each script; update them only when you intend to preserve the prior state.
- Supporting assets (`*.png`) illustrate UI states; `clipboard_history.txt` stores persisted clipboard data; `.lnk` files open frequently used environments.
- Keep experiments under `test_*.ahk` or `test_folder/`; remove temporary files after validation to avoid confusing automation.

## Build, Test, and Development Commands
- Launch a script with `AutoHotkey64.exe clipboard_history.ahk` (adjust the filename as needed).
- Reload a running script through the tray icon → Reload Script; end duplicate instances before testing changes.
- When capturing diagnostic output, use `ListVars` or write to `%A_ScriptDir%\logs\`; ensure the `logs/` directory stays gitignored.

## Coding Style & Naming Conventions
- Follow AutoHotkey v1 syntax: start files with directives such as `#SingleInstance Force` and `SendMode Input`.
- Indent logic blocks four spaces; leave hotkey definitions (`^F24::`, `!1::`) flush left for quick scanning.
- Prefer PascalCase for variables (`ClipboardHistory`, `MaxHistoryItems`) and lowercase helper labels when used.
- Introduce complex regions with banner comments (`; ==== Section ====`) as seen in `emat.ahk`; write bilingual comments only when the feature requires it.
- Persist sidecar resources beside their script and name them `<script>_<purpose>.txt` for clarity.

## Testing Guidelines
- Validate changes manually: run the target script, trigger every hotkey documented at the top of the file, and confirm window detection behaves as expected.
- For `clipboard_history.ahk`, check that `clipboard_history.txt` rotates entries correctly and the GUI overlay responds to navigation keys.
- Capture updated screenshots (e.g., `active_window_screenshot.png`) whenever UI affordances change.

## Commit & Pull Request Guidelines
- Use concise, imperative commit messages similar to `단축키 수정` or `update clipboard_history and emat scripts`; include Korean or English as appropriate.
- Bundle related script and asset updates; note deliberate `.bak` adjustments in the message body.
- Pull requests should outline the behavior change, reproduction steps, linked tickets, and before/after visuals when touching UI.
- Confirm scripts reload without errors and clean any temporary files before submitting for review.

## Security & Configuration Tips
- Avoid committing hard-coded credentials, server addresses, or environment-specific paths; source them from prompts or configuration files outside the repo.
- Always call `SetWorkingDir, %A_ScriptDir%` (or verify it exists) so automation writes only within the repository.
