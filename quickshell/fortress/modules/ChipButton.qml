import QtQuick

Rectangle {
  id: chip

  property var theme
  property alias text: label.text
  signal clicked()

  height: 28
  radius: 999
  color: mouse.containsMouse ? Qt.rgba(30 / 255, 175 / 255, 196 / 255, 0.28) : theme.muted

  Behavior on color {
    ColorAnimation { duration: 180 }
  }

  Text {
    id: label
    anchors.centerIn: parent
    color: mouse.pressed ? theme.bg : mouse.containsMouse ? theme.accentSoft : theme.text
    font.family: theme.fontName
    font.pixelSize: 14
    font.bold: true
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: chip.clicked()
  }
}
