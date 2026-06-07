import operator
from pathlib import Path
from collections.abc import Iterator

from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.entry import Entry
from fabric.widgets.image import Image
from fabric.widgets.label import Label
from fabric.widgets.scrolledwindow import ScrolledWindow
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.utils import DesktopApp, get_desktop_applications, idle_add, remove_handler


HIDDEN = ["v4l2 test utility", "avahi", "xgps", "v4l2 video capture utility"]

class AppLauncher(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="launcher",
            title="fabric-launcher",
            layer="overlay",
            anchor="center",
            exclusivity="none",
            keyboard_mode="exclusive",
            visible=True,
            all_visible=False,
            **kwargs,
        )

        self._arranger_handler = 0
        self._all_apps = [
                app for app in get_desktop_applications()
                if not any(
                    hidden in ((app.display_name or "") + " " + (app.name or "")).casefold()
                    for hidden in HIDDEN
                    )
                ]

        self.viewport = Box(spacing=6, orientation="v")

        self.search_entry = Entry(
            name="search",
            placeholder="Search applications...",
            h_expand=True,
            notify_text=lambda entry, *_: self.arrange_viewport(entry.get_text()),
        )

        self.scrolled_window = ScrolledWindow(
            min_content_size=(520, 420),
            max_content_size=(520, 420),
            child=self.viewport,
        )

        self.add(
            Box(
                name="launcher-inner",
                spacing=10,
                orientation="v",
                children=[
                    self.search_entry,
                    self.scrolled_window,
                ],
            )
        )

        self.add_keybinding("escape", lambda *_: self.application.quit())

        self.show_all()
        self.search_entry.grab_focus()
        self.arrange_viewport("")

    def arrange_viewport(self, query: str = ""):
        if self._arranger_handler:
            remove_handler(self._arranger_handler)

        self.viewport.children = []

        filtered_apps_iter = iter(
            [
                app
                for app in self._all_apps
                if query.casefold()
                in (
                    (app.display_name or "")
                    + " "
                    + (app.name or "")
                    + " "
                    + (app.generic_name or "")
                ).casefold()
            ]
        )

        should_resize = operator.length_hint(filtered_apps_iter) == len(self._all_apps)

        self._arranger_handler = idle_add(
            lambda *_: self.add_next_application(filtered_apps_iter)
            or (self.resize_viewport() if should_resize else False),
            pin=True,
        )

        return False

    def add_next_application(self, apps_iter: Iterator[DesktopApp]):
        app = next(apps_iter, None)
        if not app:
            return False

        self.viewport.add(self.app_button(app))
        return True

    def resize_viewport(self):
        self.scrolled_window.set_min_content_width(
            self.viewport.get_allocation().width
        )
        return False

    def app_button(self, app: DesktopApp):
        return Button(
            name="app",
            child=Box(
                orientation="h",
                spacing=12,
                children=[
                    Image(pixbuf=app.get_icon_pixbuf(), h_align="start", size=32),
                    Label(
                        label=app.display_name or app.name or "Unknown",
                        v_align="center",
                        h_align="start",
                    ),
                ],
            ),
            tooltip_text=app.description,
            on_clicked=lambda *_: (app.launch(), self.application.quit()),
        )


if __name__ == "__main__":
    launcher = AppLauncher()
    app = Application("fabric-launcher", launcher)
    app.set_stylesheet_from_file(str(Path(__file__).with_name("launcher.css")))
    app.run()
