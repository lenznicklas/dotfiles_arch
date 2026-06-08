import QtQuick

QtObject {
  // Fortress / Cyan palette
  property color bg: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 1.0)
  property color panel: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.72)
  property color panelStrong: Qt.rgba(7 / 255, 16 / 255, 21 / 255, 0.90)
  property color muted: Qt.rgba(39 / 255, 69 / 255, 77 / 255, 0.68)
  property color text: Qt.rgba(217 / 255, 213 / 255, 195 / 255, 1.0)
  property color textMuted: Qt.rgba(217 / 255, 213 / 255, 195 / 255, 0.55)
  property color accent: Qt.rgba(30 / 255, 175 / 255, 196 / 255, 1.0)
  property color accentSoft: Qt.rgba(140 / 255, 203 / 255, 210 / 255, 1.0)
  property color danger: Qt.rgba(215 / 255, 111 / 255, 74 / 255, 1.0)
  property string fontName: "JetBrainsMono Nerd Font"

  // Bar geometry
  property int barHeight: 47 
  property int barMarginTop: 8
  property int barMarginHorizontal: 10
  property int barRadius: 22
  property int barPaddingHorizontal: 10
  property int chipHeight: 28

  // Workspace geometry / animation
  property int workspaceDotSize: 22 
  property int workspaceActiveWidth: 62
  property int workspacePulseWidth: 90 
  property int workspaceSpacing: 6
  property int workspaceAnimationMs: 600

  // Launcher geometry
  property int launcherWidth: 680
  property int launcherInputHeight: 48
  property int launcherRowHeight: 42
  property int launcherMaxResults: 6
  property int launcherTopGap: 8
}
