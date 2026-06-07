import QtQuick

QtObject {
  // Fortress / Cyan palette
  property color bg: "#071015"
  property color panel: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.72)
  property color panelStrong: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.90)
  property color muted: Qt.rgba(39 / 255, 69 / 255, 77 / 255, 0.68)
  property color text: "#d9d5c3"
  property color accent: "#1eafc4"
  property color accentSoft: "#8ccbd2"
  property color danger: "#d76f4a"
  property string fontName: "JetBrainsMono Nerd Font"

  // Bar geometry
  property int barHeight: 42
  property int barMarginTop: 8
  property int barMarginHorizontal: 10
  property int barRadius: 18
  property int barPaddingHorizontal: 10

  // Workspace geometry / animation
  property int workspaceDotSize: 14
  property int workspaceActiveWidth: 42
  property int workspacePulseWidth: 62
  property int workspaceSpacing: 6
  property int workspaceAnimationMs: 240
}
