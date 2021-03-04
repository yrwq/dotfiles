from libqtile import qtile
import os, subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy
from libqtile.config import ScratchPad
from libqtile.dgroups import simple_key_binder
import psutil

home = os.path.expanduser("~")
mod = "mod4"
alt = "mod1"

fontsize = 14
font = "Iosevka Nerd Font"

# Gruvbox
bgcolor = "212121"
lightbg = "32302f"
gray =    "544b45"
yellow =  "e78a4e"
red =     "ea6952"
green =   "a9b665"
magenta = "d3869b"
blue =    "7daea3"
orange =  "e76f22"
white =   "d4be98"

activeborder = green
inactiveborder = bgcolor

margin = 14
barheight = 30
borderwidth = 4

terminal = "st"
browser = "firefox"

rofi = ["rofi", "-show"]

keys = [
    Key([mod], "Tab", lazy.layout.next()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "l", lazy.layout.right()),

    Key([mod, "control"], "h", lazy.layout.shrink_main()),
    Key([mod, "control"], "l", lazy.layout.grow_main()),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    Key([mod], "space", lazy.next_layout()),
    Key([mod], "Return", lazy.spawn(terminal)),

    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "e", lazy.shutdown()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "p", lazy.layout.flip()),

    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod], "b", lazy.hide_show_bar()),
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),

    Key([mod], "s", lazy.spawn(rofi + ["drun"])),
    Key([mod], "d", lazy.screen.next_group()),
    Key([mod], "a", lazy.screen.prev_group()),

    # Nerd Font picker
    Key([alt], "y", lazy.spawn("nerdy")),

    # Center current window
    Key([mod], "c", lazy.spawn("ctw")),
]

groups = [
    Group("Main"),
    Group("Web"),
    Group("Code"),
    Group("Music"),
    Group("Chat")
]
dgroups_key_binder = simple_key_binder("mod4")

lay_monad = {
    "border_width": borderwidth,
    "border_focus": activeborder,
    "border_normal": inactiveborder,
    "margin": margin,
    "ratio": 0.64,
    "single_border_width": 0,
    "min_secondary_size": 220,
    "change_ratio": 0.015
}
lay_cols = {
    "border_width": borderwidth,
    "border_focus": activeborder,
    "border_normal": inactiveborder,
    "margin": margin,
    "fair": True,
}
lay_tab = {
    "active_bg": green,
    "active_fg": bgcolor,
    "inactive_bg": bgcolor,
    "inactive_fg": white,
    "bg_color": bgcolor,
    "font": font,
    "sections": [""],
}
layouts = [
    layout.MonadTall(**lay_monad),
    layout.Columns(**lay_cols),
    layout.TreeTab(**lay_tab),
]

widget_defaults = {
        "font": font,
        "fontsize": fontsize,
        "padding": 12,
        "foreground": white,
        "background": bgcolor,
        "highlight_method": "text"
}
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    fontsize=fontsize+2,
                    borderwidth=0,
                    disable_drag=True,
                    active=gray,
                    inactive=gray,
                    this_current_screen_border=yellow,
                    this_screen_border=gray,
                    background=bgcolor,
                    urgent_alert_method='text',
                    urgent_text=red,
                    hide_unused=True,
                    visible_groups = ["Main", "Web", "Code", "Chat", "Music"]
                ),

                widget.Spacer(),

                widget.Memory(
                    fmt=" {}",
                    background=green,
                    foreground=bgcolor,
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.CPU(
                    fmt=" {}",
                    format='{load_percent}%',
                    background=green,
                    foreground=bgcolor,
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.Mpd2(
                    background=blue,
                    foreground=bgcolor,
                    status_format = "ﱘ {artist} - {title}",
                    idle_format = "ﱙ",
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.DF(
                    background=blue,
                    foreground=bgcolor,
                    visible_on_warn=False,
                    warn_color=red,
                    warn_space=10,
                    fmt = " {}",
                    format='{uf} {m}B',
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.KeyboardLayout(
                    fmt = " {}",
                    configured_keyboards = ["hu", "us", "de"],
                    background=orange,
                    foreground=bgcolor,
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.PulseVolume(
                    background=orange,
                    foreground=bgcolor,
                ),

                widget.Sep(
                    background=bgcolor,
                    foreground=bgcolor,
                    padding=5,
                ),

                widget.Clock(
                    background=magenta,
                    foreground=bgcolor,
                    font=font,
                    fontsize=fontsize+1,
                    format='%H:%M',
                ),

            ],
            barheight,
            opacity=1
        ),
    ),
]

mouse = [
    Drag(
        [mod], 'Button1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod], 'Button3',
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click(
        [mod], 'Button2',
        lazy.window.bring_to_front()
    )
]

follow_mouse_focus = False
floating_layout = layout.Floating(
                    **lay_monad,
                    float_rules=[
                        {'wmclass': 'confirm'},
                        {'wmclass': 'dialog'},
                        {'wmclass': 'download'},
                        {'wmclass': 'error'},
                        {'wmclass': 'file_progress'},
                        {'wmclass': 'notification'},
                        {'wmclass': 'splash'},
                        {'wmclass': 'toolbar'},
                        {'wmclass': 'confirmreset'},  # gitk
                        {'wmclass': 'makebranch'},  # gitk
                        {'wmclass': 'maketag'},  # gitk
                        {'wname': 'branchdialog'},  # gitk
                        {'wname': 'pinentry'},  # GPG key password entry
                        {'wmclass': 'ssh-askpass'},  # ssh-askpass
                    ]
)

@hook.subscribe.client_killed
def fallback(window):
    if window.group.windows != {window}:
        return

    for group in qtile.groups:
        if group.windows:
            qtile.current_screen.toggle_group(group)
            return
    qtile.current_screen.toggle_group(qtile.groups[0])

wmname = "qtile"
