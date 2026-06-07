from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import (
    HyprlandActiveWindow,
    HyprlandWorkspaces,
    WorkspaceButton,
)
from gi.repository import GLib
from pathlib import Path
from fabric.widgets.label import Label
from fabric.widgets.button import Button
from fabric.utils import exec_shell_command_async

class Battery(Label):
    def __init__(self):
        super().__init__(
            name="battery",
            label="󰁹 --%",
        )

        self.battery_path = self.find_battery()
        self.update_battery()

        # alle 15 Sekunden aktualisieren
        GLib.timeout_add_seconds(15, self.update_battery)

    def find_battery(self):
        for path in Path("/sys/class/power_supply").iterdir():
            type_file = path / "type"

            if type_file.exists():
                try:
                    if type_file.read_text().strip() == "Battery":
                        return path
                except Exception:
                    pass

        return None

    def read_file(self, name, fallback=""):
        if not self.battery_path:
            return fallback

        try:
            return (self.battery_path / name).read_text().strip()
        except Exception:
            return fallback

    def battery_icon(self, capacity, status):
        if status == "Charging":
            return "󰂄"

        if capacity >= 90:
            return "󰁹"
        if capacity >= 80:
            return "󰂂"
        if capacity >= 70:
            return "󰂁"
        if capacity >= 60:
            return "󰂀"
        if capacity >= 50:
            return "󰁿"
        if capacity >= 40:
            return "󰁾"
        if capacity >= 30:
            return "󰁽"
        if capacity >= 20:
            return "󰁼"
        if capacity >= 10:
            return "󰁻"

        return "󰂎"

    def update_battery(self):
        if not self.battery_path:
            self.set_label("󰂑 AC")
            return True

        capacity_raw = self.read_file("capacity", "0")
        status = self.read_file("status", "Unknown")

        try:
            capacity = int(capacity_raw)
        except ValueError:
            capacity = 0

        icon = self.battery_icon(capacity, status)
        self.set_label(f"{icon} {capacity}%")

        style = self.get_style_context()

        for css_class in ["charging", "low", "critical", "full"]:
            style.remove_class(css_class)

        if status == "Charging":
            style.add_class("charging")
        elif capacity <= 10:
            style.add_class("critical")
        elif capacity <= 20:
            style.add_class("low")
        elif capacity >= 90:
            style.add_class("full")

        return True


class AnimatedWorkspaceButton(WorkspaceButton):
    def __init__(self, ws_id):
        super().__init__(
                id=ws_id,
                name="workspace-button",
                #label=str(ws_id),
                )

        self.connect("notify::active", self.on_active_changed)

    def on_active_changed(self, *_):
        ctx = self.get_style_context()

        ctx.add_class("switching")

        if self.get_property("active"):
            ctx.add_class("switching-in")
        else:
            ctx.add_class("switching-out")

        GLib.timeout_add(260, self.clear_switching_classes)

    def clear_switching_classes(self):
        ctx = self.get_style_context()
        ctx.remove_class("switching")
        ctx.remove_class("switching-in")
        ctx.remove_class("switching-out")
        return GLib.SOURCE_REMOVE

def lock_screen(*_):
    print("LOCK BUTTON CLICKED")
    exec_shell_command_async(["bash", "-lc", "pidof hyprlock >/dev/null || hyprlock"])

class StatusBar(Window):
    def __init__(self):
        super().__init__(
            name="bar",
            title="fabric-bar",
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            margin="8px 10px 0px 10px",
            visible=False,
        )

        self.children = CenterBox(
            name="bar-inner",

            start_children=Box(
                name="left",
                orientation="h",
                spacing=8,
                children=[
                    HyprlandWorkspaces(
                        name="workspaces",
                        spacing=3,
                        buttons_factory=lambda ws_id: AnimatedWorkspaceButton(ws_id),
                    ),
                ],
            ),

            center_children=Box(
                name="center",
                children=[
                    HyprlandActiveWindow(name="active-window"),
                ],
            ),

            end_children=Box(
                name="right",
                orientation="h",
                spacing=8,
                children=[
                    DateTime(name="clock"),
                    Battery(),
                    Button(
                        name="lock-button",
                        child=Label(label=""),
                        on_clicked=lock_screen,
                    ),
                ],
            ),
        )

        self.show_all()

if __name__ == "__main__":
    bar = StatusBar()
    app = Application("fabric-bar", bar)
    app.set_stylesheet_from_file("bar.css")
    app.run()
