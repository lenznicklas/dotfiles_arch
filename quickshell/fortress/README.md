# Quickshell Fortress Modular

Minimal modular Quickshell bar for Hyprland.

## Layout

- Left: occupied workspaces + always the active workspace, even when empty
- Center: clock
- Right: battery + lock button

## Files

```text
quickshell-fortress-modular/
├── shell.qml
└── modules/
    ├── Bar.qml
    ├── BatteryChip.qml
    ├── ChipButton.qml
    ├── ClockChip.qml
    ├── Theme.qml
    └── Workspaces.qml
```

## Install

```bash
mkdir -p ~/.config/quickshell/fortress
cp -r shell.qml modules ~/.config/quickshell/fortress/
quickshell -c fortress
```

## Workspace sizing

Edit `modules/Theme.qml`:

```qml
property int workspaceDotSize: 14
property int workspaceActiveWidth: 42
property int workspacePulseWidth: 62
```
