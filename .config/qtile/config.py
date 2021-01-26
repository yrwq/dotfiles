from libqtile import qtile
import os, subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy
from libqtile.config import ScratchPad
import psutil

home = os.path.expanduser('~')
mod = 'mod4'

fontsize = 14
font = 'Inter'
semiboldfont = f'{font} Semibold'
boldfont = f'{font} Bold'
font += ' Medium'

# sonokai
bgcolor = '2c2e34'
gray = '828282'
yellow = 'e5c463'
red = 'f85e84'
green = '9ecd6f'
magenta = 'ab9df2'
blue = '7accd7'
orange = 'ef9062'
white = 'e3e1e4'

activeborder = '52596B'
inactiveborder = bgcolor
margin = 14
barheight = 22
borderwidth = 2

terminal = 'st'
browser = 'env MOZ_X11_EGL=1 firefox'

rofi = ['rofi', '-show']

player_cmd = (
        'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '
        '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.'
)

keys = [
    Key([mod], 'j', lazy.layout.down()),
    Key([mod], 'k', lazy.layout.up()),
    Key([mod], 'h', lazy.layout.shrink_main()),
    Key([mod], 'l', lazy.layout.grow_main()),

    Key([mod, 'control'], 'j', lazy.layout.shuffle_down()),
    Key([mod, 'control'], 'k', lazy.layout.shuffle_up()),

    Key([mod], 'space', lazy.layout.next()),
    Key([mod], 'Return', lazy.spawn(terminal)),

    Key([mod], 'q', lazy.window.kill()),
    Key([mod], 'n', lazy.layout.normalize()),
    Key([mod], 'm', lazy.layout.maximize()),
    Key([mod], 'comma', lazy.layout.reset()),
    Key([mod], 'f', lazy.window.toggle_fullscreen()),
    Key([mod], 'p', lazy.layout.flip()),

    Key([mod, 'shift'], 'r', lazy.restart()),
    Key([mod], 'b', lazy.hide_show_bar()),
    Key([mod, 'shift'], 's', lazy.spawncmd()),
    Key([mod, 'shift'], 'space', lazy.window.toggle_floating()),

    Key([], 'XF86AudioRaiseVolume', lazy.spawn('pactl set-sink-volume 0 +5%')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('pactl set-sink-volume 0 -5%')),
    Key([], 'XF86AudioMute', lazy.spawn('pactl set-sink-mute 0 toggle')),
    Key([], 'XF86MonBrightnessUp', lazy.spawn('brightnessctl s +100')),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('brightnessctl s 100-')),

    Key([mod], 's', lazy.spawn(rofi + ['drun'])),
]

groups = [Group(i) for i in 'asdfui']
for i in groups:
    keys.extend(
        [
            Key(
                [mod], i.name,
                lazy.group[i.name].toscreen(),
                desc=f'Switch to group {i.name}'
            ),
            Key(
                [mod, 'control'], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f'Switch to & move focused window to group {i.name}'
            ),
        ]
    )


layout_theme = {
    'border_width': borderwidth,
    'border_focus': activeborder,
    'border_normal': inactiveborder,
    'margin': margin,
    'ratio': 0.64,
    'single_border_width': 0,
    'min_secondary_size': 220,
    'change_ratio': 0.015
}
layouts = [layout.MonadTall(**layout_theme)]

widget_defaults = {
        'font': font,
        'fontsize': fontsize,
        'padding': 12,
        'foreground': yellow,
        'background': bgcolor,
        'highlight_method': 'text'
}
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    fmt='~',
                    foreground=gray,
                    font=boldfont,
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(rofi + ['drun', '-location', '1']),
                        'Button2': lambda qtile:
                        qtile.cmd_spawn(f'{home}/.scripts/power.sh'),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(rofi + ['window', '-location', '1']),
                    }
                ),
                widget.GroupBox(
                    font=semiboldfont,
                    fontsize=fontsize+2,
                    borderwidth=0,
                    disable_drag=True,
                    active=gray,
                    inactive=bgcolor,
                    this_current_screen_border=yellow,
                    this_screen_border=gray,
                    background=bgcolor,
                    urgent_alert_method='text',
                    urgent_text=red
                ),
                widget.Prompt(
                    prompt="run: ",
                    ignore_dups_history=True,
                ),
                widget.Spacer(),
                widget.Mpris2(
                    name='spotify',
                    foreground=gray,
                    stop_pause_text='▶',
                    objname='org.mpris.MediaPlayer2.spotify',
                    display_metadata=['xesam:artist', 'xesam:title'],
                    scroll_chars=None,
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(f'{player_cmd}PlayPause'),
                        'Button2': lambda qtile:
                        qtile.cmd_spawn(f'{player_cmd}Previous'),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(f'{player_cmd}Next')
                    }
                ),
                widget.Spacer(),
                widget.CPU(
                    format='{load_percent}%',
                    foreground=gray,
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(f'perfmon'),
                        'Button2': lambda qtile:
                        qtile.cmd_spawn(f'sound'),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(terminal)
                    }
                ),
                widget.ThermalSensor(
                        foreground=gray,
                        foreground_alert=red,
                        threshold=85
                ),
                widget.Memory(
                    foreground=gray,
                    format='{MemUsed} MB',
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(f'irc'),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(f'term')
                    }
                ),
                widget.DF(
                    visible_on_warn=False,
                    warn_color=red,
                    warn_space=10,
                    format='{uf} {m}B',
                    foreground=gray,
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(f'filemanager'),
                        'Button2': lambda qtile:
                        qtile.cmd_spawn(f'-e ncdu'),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(f'e vifm')
                    }
                ),
                widget.PulseVolume(foreground=magenta),
                widget.Backlight(
                    foreground=blue,
                    backlight_name='intel_backlight',
                    change_command='brightnessctl s {0}'
                ),
                widget.CheckUpdates(
                    distro='Arch_checkupdates',
                    display_format='{updates}',
                    execute=f'{terminal} -e yay',
                    colour_have_updates=orange
                ),
                widget.Clock(
                    font=boldfont,
                    fontsize=fontsize+1,
                    format='%H:%M ',
                    mouse_callbacks = {
                        'Button1': lambda qtile:
                        qtile.cmd_spawn(f'rss'),
                        'Button2': lambda qtile:
                        qtile.cmd_hide_show_bar(),
                        'Button3': lambda qtile:
                        qtile.cmd_spawn(f'calendar')
                    }
                )
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
                    **layout_theme,
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

@hook.subscribe.startup_once
def autostart():
    processes = [
        ['nitrogen', '--restore'],
        ['picom', '-b', '--experimental-backends'],
        ['redshift'],
        rofi + ['drun']
    ]

    for p in processes:
        subprocess.Popen(p)
