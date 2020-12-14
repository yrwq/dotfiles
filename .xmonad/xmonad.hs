import XMonad
import System.Exit
import System.IO.Unsafe
import Data.Maybe
import Data.Tree
import Data.List (sortBy)
import Data.Function (on)
import Data.List as DL
import Data.Char as DC
import Data.Ratio
import Data.Char (isSpace)
import Data.Monoid
import Data.Tuple
import qualified Data.Tuple.Extra as TE

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Grid

import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.WorkspaceHistory

import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (safeSpawn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.DwmPromote
import XMonad.Actions.WindowGo
import XMonad.Actions.Minimize
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect
import qualified XMonad.Actions.TreeSelect as TS

import XMonad.Util.EZConfig (additionalKeysP)
import Control.Monad (forM_, join)
import XMonad.Util.NamedWindows (getName)

--
-- Variables
--

myFont :: String
myFont = "xft:Iosevka Custom:size=12"

myTerminal :: String
myTerminal = "$TERMINAL"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2

myModMask       = mod4Mask
altMask = mod4Mask

myEditor :: String
myEditor = "emacsclient -c -a emacs "

myWorkspaces    = ["1","2","3","4","5"]

myNormalBorderColor  = "#1d2021"
myFocusedBorderColor = "#bdae93"

--
-- Autostart
--

myStartupHook = do
              spawn "$HOME/.config/polybar/launch.sh &"
              spawnOnce "picom &"
              spawnOnce "dunst &"
              spawnOnce "nitrogen --restore &"
              spawnOnce "emacs --daemon &"

myConfigs :: [(String, String, String)]
myConfigs = [ ("aliases", myEditor ++ "~/.config/shell/aliasrc", "")
            , ("bookmark-dirs", myEditor ++ "~/.config/shell/bm-files", "")
            , ("bookmark-files", myEditor ++ "~/.config/shell/bm-dirs", "")
            , ("awesome", myEditor ++ "~/.config/awesome", "")
            , ("directories", myEditor ++ "~/.config/directories", "")
            , ("lf", myEditor ++ "~/.config/lf/lfrc", "")
            , ("newsboat", myEditor ++ "~/.config/newsboat/urls", "")
            , ("nvim", myEditor ++ "~/.config/nvim/init.vim", "")
            , ("polybar", myEditor ++ "~/.config/polybar/config", "")
            , ("ranger", myEditor ++ "~/.config/ranger/rc.conf", "")
            , ("rofi", myEditor ++ "~/.config/rofi/config", "")
            , ("profile", myEditor ++ "~/.config/shell/profile", "")
            , ("shortcuts", myEditor ++ "~/.config/shell/shortcutrc", "")
            , ("zshnameddirrc", myEditor ++ "~/.config/shell/zshnameddirrc", "")
            , ("surf-style", myEditor ++ "~/.config/surf/styles/default.css", "")
            , ("termite", myEditor ++ "~/.config/termite/config", "")
            , ("xprofile", myEditor ++ "~/.config/x11/xprofile", "")
            , ("xinitrc", myEditor ++ "~/.xinitrc", "")
            , ("picom", myEditor ++ "~/.config/picom.conf", "")
            , ("emacs", myEditor ++ "~/.emacs.d/init.el", "")
            , ("xmonad", myEditor ++ "~/.xmonad/xmonad.hs", "")
            , ("firefox", myEditor ++ "~/.mozilla/firefox/*.default-release/chrome/userChrome.css", "")
            , ("flavour templates", myEditor ++ "~/.local/share/flavours/base16/templates", "")
            , ("flavour schemes", myEditor ++ "~/.local/share/flavours/base16/schemes", "")
            , ("flavour config", myEditor ++ "~/.config/flavours/config.toml", "")
            , ("st", myEditor ++ "~/.local/src/st/config.h", "")
            , ("surf", myEditor ++ "~/.local/src/surf/config.h", "")
            , ("dwm", myEditor ++ "~/.local/src/dwm/config.h", "")
            ]

--
-- treeselect often used applications
--

myApps :: [(String, String, String)]
myApps = [ ("Firefox", "firefox", "Firefox web browser")
            , ("Qutebrowser", "qutebrowser", "Browser with vim bindings")
            , ("File Manager", "st -c files -e lf", "")
            , ("News", "st -c news -e newsboat", "")
            , ("Mail", "st -c mail -e neomutt", "")
            ]

--
-- treeselect scripts
--

myScripts :: [(String, String, String)]
myScripts = [ ("art", "art", "Notification with album art and current song")
            , ("chth", "chth", "Choose a theme")
            , ("chth -r", "chth -r", "Apply a random theme")
            , ("clr", "clr", "Pick a color and show a notification with the color")
            , ("dots", "dots", "Sync my dotfiles")
            , ("horoscope", "noti -hd", "show today's horoscope in notification")
            , ("horoscope", "noti -ht", "show tomorrow's horoscope in notification")
            , ("screenshot", "lien -a -f", "Full screen")
            , ("screenshot", "lien -s -f", "Select")
            , ("lock", "lock", "Lock the screen")
            , ("manp", "manp", "Read a man page in zathura")
            , ("mem", "mem", "Meme picker")
            , ("nerdy", "nerdy", "Nerd Font picker")
            , ("newsup", "newsup", "Update newsboat")
            , ("pickfont", "pickfont", "Pick a font and spawn st")
            , ("rec", "rec", "Start recording")
            , ("rec", "pkill ffmpeg", "Stop recording")
            , ("samedir", "samedir", "Open a terminal in the same directory")
            , ("shrt", "~/.xinitrc", "")
            , ("picom", myEditor ++ "~/.config/picom.conf", "")
            , ("emacs", myEditor ++ "~/.emacs.d/init.el", "")
            , ("xmonad", myEditor ++ "~/.xmonad/xmonad.hs", "")
            , ("firefox", myEditor ++ "~/.mozilla/firefox/*.default-release/chrome/userChrome.css", "")
            , ("flavour templates", myEditor ++ "~/.local/share/flavours/base16/templates", "")
            , ("flavour schemes", myEditor ++ "~/.local/share/flavours/base16/schemes", "")
            , ("flavour config", myEditor ++ "~/.config/flavours/config.toml", "")
            , ("st", myEditor ++ "~/.local/src/st/config.h", "")
            , ("surf", myEditor ++ "~/.local/src/surf/config.h", "")
            , ("dwm", myEditor ++ "~/.local/src/dwm/config.h", "")
            ]

--
-- treeselect
--

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "applications" "a list of programs I use often" (return ()))
     [Node (TS.TSNode (TE.fst3 $ myApps !! n)
                      (TE.thd3 $ myApps !! n)
                      (spawn $ TE.snd3 $ myApps !! n)
           ) [] | n <- [0..(length myApps - 1)]
     ]
   , Node (TS.TSNode "scripts" "scripts that can be run without a terminal" (return ()))
     [Node (TS.TSNode(TE.fst3 $ myScripts !! n)
                     (TE.thd3 $ myScripts !! n)
                     (spawn $ TE.snd3 $ myScripts !! n)
           ) [] | n <- [0..(length myScripts - 1)]
     ]
   , Node (TS.TSNode "config files" "config files that edit often" (return ()))
     [Node (TS.TSNode (TE.fst3 $ myConfigs !! n)
                      (TE.thd3 $ myConfigs !! n)
                      (spawn $ TE.snd3 $ myConfigs !! n)
           ) [] | n <- [0..(length myConfigs - 1)]
     ]
   ]

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xe61d2021 -- 90% transparent background
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffbdae93, 0xff1d2021)
                              , TS.ts_nodealt      = (0xffbdae93, 0xff1d2121)
                              , TS.ts_highlight    = (0xffbdae93, 0xff3c3836)
                              , TS.ts_extra        = 0xffbdae93
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 20
                              , TS.ts_originX      = 0
                              , TS.ts_originY      = 0
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    ]

--
-- Prompt
--

myXPConfig :: XPConfig
myXPConfig = def
      { font                = myFont
      , bgColor             = "#1d2021"
      , fgColor             = "#bdae93"
      , bgHLight            = "#3c3836"
      , fgHLight            = "#bdae93"
      , borderColor         = "#3c3836"
      , promptBorderWidth   = 4
      , promptKeymap        = myXPKeymap
      , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing
      }

myXPConfig' :: XPConfig
myXPConfig' = myXPConfig
      { autoComplete        = Nothing
      }

promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", passRemovePrompt)   -- remove passwords (requires 'pass')
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

myXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]


--
-- Keybinds
--

myKeys :: [(String, X ())]
myKeys =
  [ ("M-<Return>", spawn "$TERMINAL")
    , ("M-S-<Return>", dwmpromote)
    , ("M-d", nextWS)
    , ("M-a", prevWS)
    , ("M-S-d", shiftToNext >> nextWS)
    , ("M-S-a", shiftToPrev >> prevWS)
    , ("M1-C-j", withFocused (keysResizeWindow (-10,-10) (1,1)))
    , ("M1-C-k", withFocused (keysResizeWindow (10,10) (1,1)))
    -- center focused window, x and y is should be half of your resolution
    -- , ("M-c", withFocused (keysMoveWindowTo (x,y) (1%2,1%2)))
    , ("M-c", withFocused (keysMoveWindowTo (640,512) (1/2,1/2)))
    
    , ("M-s", spawn "rofi -show drun")
    -- , ("M-S-s", spawn "dmenu_run")

    , ("C-g s", shellPrompt myXPConfig)
    , ("C-g m", manPrompt myXPConfig)
    , ("C-g p", passPrompt myXPConfig)
    , ("C-g g", passGeneratePrompt myXPConfig)
    , ("C-g r", passRemovePrompt myXPConfig)
    
    , ("M-S-r", spawn "xmonad --recompile;xmonad --restart")
    , ("M-S-e", io exitSuccess)
    , ("M-y", spawn "ytw")
    , ("M-q", kill)
    , ("M-.", incWindowSpacing 5)
    , ("M-,", decWindowSpacing 5)
    , ("M1-<Up>", spawn "pamixer -i 5")
    , ("M1-<Down>", spawn "pamixer -d 5")
    , ("M1-y", spawn "nerdy")
    , ("<Print>", spawn "lien -s -f")
    , ("M-<Print>", spawn "lien -a -f")
    , ("M-w", runOrRaise "qutebrowser" (className =? "qutebrowser"))
    , ("M-S-w", spawn "surf duckduckgo.com")
    , ("M-x", runOrRaise "discocss" (className =?  "Discord"))
    , ("C-e e", spawn "emacsclient -c -a ''")                            -- start emacs
    , ("C-e b", spawn "emacsclient -c -a '' --eval '(ibuffer)'")         -- list emacs buffers
    , ("C-e d", spawn "emacsclient -c -a '' --eval '(dired nil)'")       -- dired emacs file manager
    , ("C-e t", spawn "emacsclient -c -a '' /mnt/doc/org/todo.org")
    , ("M-r", spawn "st -c files -e lf")
    , ("M1-q n", spawn "st -c news -e newsboat")
    , ("M1-q m", spawn "st -c music -e ncmpcpp")
    , ("M1-q e", spawn "st -c mail -e neomutt")
    , ("C-s s", treeselectAction tsDefaultConfig) -- edit configs

  ]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

  -- left
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
  -- middle
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

  -- right
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    ]

--
-- layouts
--

gapp = gaps [(U,35), (R,10), (D,10), (L,10)]

myLayout = avoidStruts (gapp $ tiled ||| myaccord ||| myspiral ||| grid)
  where
     tiled   = spacing 5 $ Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
     myspiral  = spacing 5 $ spiral (6/7)
     myaccord = spacing 5 $ Accordion
     grid = spacing 5 $ Grid

myManageHook = insertPosition Below Newer <+> composeAll
    [ resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mconcat [ fullscreenEventHook
          ]

main = do
  xmonad $ ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        logHook            = workspaceHistoryHook,
        manageHook         = insertPosition Master Newer <+> myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook
} `additionalKeysP` myKeys
