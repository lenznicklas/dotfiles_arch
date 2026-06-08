import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

import "modules"

ShellRoot {
  id: root

  Theme {
    id: appTheme
  }

  SystemClock {
    id: sysClock
    precision: SystemClock.Minutes
  }

  Process {
    id: lockProc
    command: ["bash", "-lc", "pidof hyprlock >/dev/null || hyprlock"]
  }

    Launcher {
    id: launcher
    targetScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    theme: appTheme
  }

  Notes {
    id: notes
    targetScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    theme: appTheme
  }

  GlobalShortcut {
    name: "launcher"
    description: "Toggle launcher"
    onPressed: launcher.toggle()
  }

  GlobalShortcut {
    name: "notes"
    description: "Toggle notes"
    onPressed: notes.toggle()
  }

  Variants {
    model: Quickshell.screens

    Bar {
      required property var modelData

      screen: modelData
      theme: appTheme
      clock: sysClock

      onLockRequested: lockProc.startDetached()
    }
  }
}
