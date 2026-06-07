import Quickshell.Hyprland
import QtQuick

Row {
  id: workspaces

  property var theme

  spacing: theme.workspaceSpacing

  function visibleWorkspaces() {
    const focusedId = Hyprland.focusedWorkspace !== null ? Hyprland.focusedWorkspace.id : -1;

    return Hyprland.workspaces.values
      .filter(function(ws) {
        if (ws.id <= 0)
          return false;

        const isFocused = ws.id === focusedId || ws.focused;
        const hasWindows = ws.toplevels !== null && ws.toplevels.values.length > 0;

        // Show occupied workspaces and always show the currently active one,
        // even when it is empty.
        return isFocused || hasWindows;
      })
      .sort(function(a, b) { return a.id - b.id; });
  }

  Repeater {
    model: workspaces.visibleWorkspaces()

    Rectangle {
      id: wsButton

      required property var modelData
      property var workspace: modelData
      property bool active: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === workspace.id
      property bool pulse: false
      property bool hovered: mouse.containsMouse

      width: active ? (pulse ? theme.workspacePulseWidth : theme.workspaceActiveWidth) : theme.workspaceDotSize
      height: theme.workspaceDotSize
      radius: 999

      color: workspace.urgent ? theme.danger
           : active ? (pulse ? theme.accentSoft : theme.accent)
           : hovered ? Qt.rgba(140 / 255, 203 / 255, 210 / 255, 0.62)
           : theme.muted

      opacity: active ? 1.0 : hovered ? 0.88 : 0.58

      onActiveChanged: {
        if (active)
          pulseAnimation.restart();
      }

      SequentialAnimation {
        id: pulseAnimation
        ScriptAction { script: wsButton.pulse = true }
        PauseAnimation { duration: 170 }
        ScriptAction { script: wsButton.pulse = false }
      }

      Behavior on width {
        NumberAnimation {
          duration: theme.workspaceAnimationMs
          easing.type: Easing.OutCubic
        }
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 180
          easing.type: Easing.OutCubic
        }
      }

      Behavior on color {
        ColorAnimation {
          duration: 180
        }
      }

      MouseArea {
        id: mouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: wsButton.workspace.activate()
      }
    }
  }
}
