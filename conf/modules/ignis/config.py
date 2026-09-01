import json
import subprocess

from ignis.app import IgnisApp
from ignis.utils import Utils
from ignis.widgets import Widget

app = IgnisApp.get_default()
app.apply_css(f"{Utils.get_current_dir()}/style.scss")


def common_shortcuts() -> list[dict[str, str]]:
    result = subprocess.run(
        ["hypr-keybinds", "--common-json"],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def shortcut_row(shortcut: dict[str, str]) -> Widget.CenterBox:
    return Widget.CenterBox(
        css_classes=["shortcut-row"],
        start_widget=Widget.Label(
            css_classes=["shortcut-action"],
            label=shortcut["action"],
            halign="start",
        ),
        end_widget=Widget.Label(
            css_classes=["shortcut-key"],
            label=shortcut["key"],
            halign="end",
        ),
    )


Widget.Window(
    namespace="haxorus-shortcuts",
    anchor=["bottom", "right"],
    layer="bottom",
    kb_mode="none",
    exclusivity="normal",
    margin_bottom=34,
    margin_right=34,
    child=Widget.Box(
        vertical=True,
        css_classes=["shortcut-widget"],
        child=[
            Widget.Label(
                css_classes=["shortcut-heading"],
                label="HAXORUS",
                halign="start",
            ),
            Widget.Separator(css_classes=["shortcut-rule"]),
            *[shortcut_row(shortcut) for shortcut in common_shortcuts()],
        ],
    ),
)
