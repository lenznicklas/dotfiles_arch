import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

PanelWindow {
  id: launcher

  property var theme
  property var targetScreen
  property string query: input.text

  property var hiddenApps: [
  "avahi-discover",
  "bssh",
  "bvnc",
  "qv4l2",
  "qvidcap",
  "org.gnome.Extensions",
  "org.gnome.Settings",
  "xgps",
  "xgpsspeed",
  "Neovim"
]

property var filteredEntries: {
  const q = query.trim().toLowerCase();

  if (q.length === 0)
    return [];

  return DesktopEntries.applications.values
    .filter(function(app) {
      if (hiddenApps.includes(app.id) || hiddenApps.includes(app.name))
        return false;

      const haystack = [
        app.name || "",
        app.genericName || "",
        app.comment || "",
        app.keywords ? app.keywords.join(" ") : ""
      ].join(" ").toLowerCase();

      return haystack.includes(q);
    })
    .sort(function(a, b) {
      return a.name.localeCompare(b.name);
    })
    .slice(0, theme.launcherMaxResults);
}

  screen: targetScreen
  visible: false
  focusable: visible
  aboveWindows: true
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  implicitHeight: content.height + 4

  anchors {
    top: true
    left: true
    right: true
  }

  margins {
    top: theme.barMarginTop + theme.barHeight + theme.launcherTopGap
    left: 0
    right: 0
  }

  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  HyprlandFocusGrab {
    windows: [launcher]
    active: launcher.visible
    onCleared: launcher.hideLauncher()
  }

  function toggle() {
    if (visible)
      hideLauncher();
    else
      showLauncher();
  }

  function showLauncher() {
    input.text = "";
    results.currentIndex = 0;
    visible = true;
    input.forceActiveFocus();
  }

  function hideLauncher() {
    visible = false;
    input.text = "";
  }

  function launchSelected() {
    if (filteredEntries.length === 0)
      return;

    const index = Math.max(0, Math.min(results.currentIndex, filteredEntries.length - 1));
    const app = filteredEntries[index];

    if (app) {
      app.execute();
      hideLauncher();
    }
  }

  Column {
    id: content

    width: theme.launcherWidth
    spacing: 8

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    Rectangle {
      id: inputBox

      width: parent.width
      height: theme.launcherInputHeight
      radius: 999

      color: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.88)
      border.width: 2
      border.color: Qt.rgba(30 / 255, 175 / 255, 196 / 255, 0.58)

      Text {
        visible: input.text.length === 0
        text: "search apps..."
        color: theme.textMuted
        font.family: theme.fontName
        font.pixelSize: 15

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 22
      }

      TextInput {
        id: input

        color: theme.text
        selectionColor: theme.accentSoft
        selectedTextColor: theme.bg
        font.family: theme.fontName
        font.pixelSize: 16
        clip: true
        verticalAlignment: TextInput.AlignVCenter

        anchors.fill: parent
        anchors.leftMargin: 22
        anchors.rightMargin: 22

        onTextChanged: results.currentIndex = 0

        Keys.onPressed: function(event) {
          if (event.key === Qt.Key_Escape) {
            launcher.hideLauncher();
            event.accepted = true;
          } else if (event.key === Qt.Key_Down) {
            results.currentIndex = Math.min(results.currentIndex + 1, launcher.filteredEntries.length - 1);
            event.accepted = true;
          } else if (event.key === Qt.Key_Up) {
            results.currentIndex = Math.max(results.currentIndex - 1, 0);
            event.accepted = true;
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            launcher.launchSelected();
            event.accepted = true;
          }
        }
      }
    }

    Rectangle {
      id: resultsBox

      visible: launcher.filteredEntries.length > 0
      width: parent.width
      height: results.height + 12
      radius: 22
      color: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.86)
      border.width: 1
      border.color: Qt.rgba(30 / 255, 175 / 255, 196 / 255, 0.38)

      ListView {
        id: results

        width: parent.width - 12
        height: Math.min(count, theme.launcherMaxResults) * theme.launcherRowHeight
        anchors.centerIn: parent
        clip: true
        interactive: false
        currentIndex: launcher.filteredEntries.length > 0 ? Math.max(0, currentIndex) : -1
        model: launcher.filteredEntries

        delegate: Rectangle {
          id: row

          required property var modelData
          required property int index

          width: results.width
          height: theme.launcherRowHeight
          radius: 14
          color: ListView.isCurrentItem ? Qt.rgba(140 / 255, 203 / 255, 210 / 255, 0.22) : "transparent"

          Text {
            text: modelData.name || "Unknown"
            color: ListView.isCurrentItem ? theme.accentSoft : theme.text
            font.family: theme.fontName
            font.pixelSize: 14
            elide: Text.ElideRight

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: results.currentIndex = index
            onClicked: {
              results.currentIndex = index;
              launcher.launchSelected();
            }
          }
        }
      }
    }
  }
}
