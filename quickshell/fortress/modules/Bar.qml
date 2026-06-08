import Quickshell
import QtQuick

PanelWindow {
  id: win

  property var theme
  property var clock
  signal lockRequested()

  color: "transparent"
  implicitHeight: theme.barHeight
  exclusiveZone: theme.barHeight + theme.barMarginTop - 14

  anchors {
    top: true
    left: true
    right: true
  }

  margins {
    top: theme.barMarginTop
    left: theme.barMarginHorizontal
    right: theme.barMarginHorizontal
  }

  Rectangle {
    id: bar

    anchors.fill: parent
    color: theme.panel
    radius: theme.barRadius
    border.width: 2
    border.color: Qt.rgba(30 / 255, 175 / 255, 196 / 255, 0.48)

    Row {
      id: leftModules

      anchors.left: parent.left
      anchors.leftMargin: theme.barPaddingHorizontal
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Workspaces {
        theme: win.theme
      }
    }

    ClockChip {
      anchors.centerIn: parent
      theme: win.theme
      timeText: Qt.formatDateTime(win.clock.date, "hh:mm")
    }

    Row {
      id: rightModules

      anchors.right: parent.right
      anchors.rightMargin: theme.barPaddingHorizontal
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      BatteryChip {
        theme: win.theme
      }

      ChipButton {
        theme: win.theme
        text: ""
        width: 48
        onClicked: win.lockRequested()
      }
    }
  }
}
