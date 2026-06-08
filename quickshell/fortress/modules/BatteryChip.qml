import QtQuick
import Quickshell.Services.UPower

Rectangle {
  id: root

  property var theme
  property var battery: UPower.displayDevice

  function percent() {
    if (!battery)
      return "--";

    const raw = battery.percentage;

    if (raw === undefined || raw === null || isNaN(raw))
      return "--";

    // Quickshell/UPower may expose either 0.79 or 79 depending on version/device.
    if (raw <= 1)
      return Math.round(raw * 100);

    return Math.round(raw);
  }

  function charging() {
    // onBattery=false means AC/charging/full. This is stable and avoids enum-name issues.
    return !UPower.onBattery;
  }

  function icon() {
    const p = percent();

    if (p === "--")
      return "󰂑";

    if (charging())
      return "󰂄";

    if (p >= 90) return "󰁹";
    if (p >= 80) return "󰂂";
    if (p >= 70) return "󰂁";
    if (p >= 60) return "󰂀";
    if (p >= 50) return "󰁿";
    if (p >= 40) return "󰁾";
    if (p >= 30) return "󰁽";
    if (p >= 20) return "󰁼";
    if (p >= 10) return "󰁻";

    return "󰂎";
  }

  function isLow() {
    const p = percent();
    return p !== "--" && p <= 15 && !charging();
  }

  width: batteryText.implicitWidth + 24
  height: theme.chipHeight
  radius: 999

  color: isLow() ? Qt.rgba(215 / 255, 111 / 255, 74 / 255, 0.92)
       : charging() ? Qt.rgba(127 / 255, 163 / 255, 111 / 255, 0.88)
       : theme.muted

  Behavior on color {
    ColorAnimation { duration: 180 }
  }

  Text {
    id: batteryText

    anchors.centerIn: parent
    text: root.percent() === "--" ? "󰂑 AC" : root.icon() + " " + root.percent() + "%"
    color: root.isLow() || root.charging() ? theme.bg : theme.text
    font.family: theme.fontName
    font.pixelSize: 14
    font.bold: true
  }
}
