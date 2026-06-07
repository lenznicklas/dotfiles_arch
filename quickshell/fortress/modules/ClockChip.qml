import QtQuick

Rectangle {
  id: chip

  property var theme
  property string timeText: "--:--"

  width: clockText.implicitWidth + 32
  height: 28
  radius: 999
  color: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.62)
  border.width: 1
  border.color: Qt.rgba(30 / 255, 175 / 255, 196 / 255, 0.38)

  Text {
    id: clockText
    anchors.centerIn: parent
    text: chip.timeText
    color: theme.text
    font.family: theme.fontName
    font.pixelSize: 14
    font.bold: true
  }
}
