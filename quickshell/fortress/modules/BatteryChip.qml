import Quickshell.Services.UPower
import QtQuick

Rectangle {
  id: chip

  property var theme

  readonly property var device: UPower.displayDevice
  readonly property bool ready: device !== null && device.ready
  readonly property int percent: ready ? Math.round(device.percentage) : -1
  readonly property bool charging: ready && (
    device.state === UPowerDeviceState.Charging ||
    device.state === UPowerDeviceState.PendingCharge ||
    device.state === UPowerDeviceState.FullyCharged
  )

  function icon() {
    if (!ready || percent < 0)
      return "󰂑";
    if (charging)
      return "󰂄";
    if (percent <= 10)
      return "󰂎";
    if (percent <= 20)
      return "󰁼";
    if (percent <= 40)
      return "󰁾";
    if (percent <= 60)
      return "󰂀";
    if (percent <= 80)
      return "󰂂";
    return "󰁹";
  }

  width: batteryText.implicitWidth + 24
  height: 28
  radius: 999
  color: percent >= 0 && percent <= 15 && !charging ? Qt.rgba(215 / 255, 111 / 255, 74 / 255, 0.92)
       : charging ? Qt.rgba(127 / 255, 163 / 255, 111 / 255, 0.88)
       : theme.muted

  Behavior on color {
    ColorAnimation { duration: 180 }
  }

  Text {
    id: batteryText
    anchors.centerIn: parent
    text: chip.percent >= 0 ? `${chip.icon()} ${chip.percent}%` : "󰂑 AC"
    color: (chip.percent >= 0 && chip.percent <= 15 && !chip.charging) || chip.charging ? theme.bg : theme.text
    font.family: theme.fontName
    font.pixelSize: 14
    font.bold: true
  }
}
