import Quickshell
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
