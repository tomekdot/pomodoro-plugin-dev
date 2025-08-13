# Pomodoro Timer for Openplanet

A clean, effective Pomodoro timer for Trackmania with tasks, stats, notifications, themes, and hotkeys.

## Features

- **⏰ Work/break cycles** with long break interval
- **📋 Tasks list** with quick stats (today / 7d / total)
- **🔔 Toast + sound notifications** (with volume)
- **🌈 Light/Dark themes** with transparent light window
- **📏 Auto-resize overlay** and position saving
- **⌨️ Hotkeys** (configurable; default require Ctrl)

## Overlay Modes & UI Improvements

The plugin offers three distinct overlay modes, which can be cycled using a hotkey (`Ctrl + F10` by default) or changed in the settings:

- **Timer Mode:** A compact view focused only on the timer, progress, and main controls.
- **Tasks Mode:** A larger view that includes the timer and a complete task management panel.
- **Compact Mode:** A highly configurable, minimal view. You can customize it in the settings to show or hide:
  - Action Buttons (Play/Pause, etc.)
  - Session Stats
  - Progress Bar (now width-limited if shown alone)
  - Tasks List

### Recent UI/UX Improvements

- The overlay close (X) button in the title bar now always works, regardless of how the overlay was opened.
- Action buttons in compact mode are now centered for a cleaner look.
- Overlay mode switcher buttons (top row) no longer change color when selected, for a more neutral appearance.
- The progress bar in compact mode is width-limited if it is the only element shown, for better appearance with the default font.

## Hotkeys (defaults)

- `Ctrl + F5`: Start/Pause
- `Ctrl + F6`: Reset
- `Ctrl + F8`: Skip to next session
- `Ctrl + F9`: Toggle overlay visibility
- `Ctrl + F10`: Cycle overlay mode

## Install

- Copy the folder `pomodoro-plugin-dev` into `Openplanet4/Plugins/` or use the .op package.

## Build (.op package)

- Run in PowerShell from this folder:

  ```powershell
  ./build-op.ps1
  ```

  This creates `pomodoro-timer.op` ready for upload.

## Credits

- Notification sounds by soundandmelodies (freesound.org, ID 776181)

## License

MIT License - feel free to modify and distribute!

## Contributing

Found a bug or have a feature request? Feel free to open an issue or submit a pull request!

---

**Happy Pomodoro-ing! 🍅⏰**