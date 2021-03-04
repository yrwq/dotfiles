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

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Tabbed
import XMonad.Layout.Minimize
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Grid
import XMonad.Layout.Drawer

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

    , ("M-S-r", spawn "xmonad --recompile;xmonad --restart")
    , ("M-S-e", io exitSuccess)
    , ("M-y", spawn "ytw")
    , ("M-q", kill)
    , ("M-b", spawn "bar")
    , ("M-.", incWindowSpacing 5)
    , ("M-,", decWindowSpacing 5)
    , ("M1-<Up>", spawn "pamixer -i 5")
    , ("M1-<Down>", spawn "pamixer -d 5")
    , ("M1-y", spawn "nerdy")
    , ("<Print>", spawn "lien -s -f")
    , ("M-<Print>", spawn "lien -a -f")
    , ("M-S-w", spawn "surf duckduckgo.com")
    , ("M-w", spawn "qutebrowser yrwq.github.io/termstart")
    , ("M-x", runOrRaise "discocss" (className =?  "Discord"))
    , ("C-e e", spawn "emacsclient -c -a ''")
    , ("C-e t", spawn "emacsclient -c -a '' /mnt/doc/org/todo.org")
    , ("M-r", spawn "st -c files -e lf")
    , ("M1-r", spawn "runs -c")
    , ("M1-q n", spawn "st -c news -e newsboat")
    , ("M1-q m", spawn "st -c music -e ncmpcpp")
    , ("M1-q e", spawn "st -c mail -e neomutt")
    , ("M-n", withFocused minimizeWindow)
    , ("M-S-n", withLastMinimized maximizeWindowAndFocus)
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

gapp = gaps [(U,30), (R,10), (D,10), (L,10)]

myLayout = avoidStruts (gapp $ minimize (tiled ||| grid)) ||| minimize (Full)
  where
     tiled   = spacing 5 $ Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
     myspiral  = spacing 5 $ spiral (6/7)
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
      mouseBindings      = myMouseBindings,
      layoutHook         = myLayout,
      logHook            = workspaceHistoryHook,
      manageHook         = manageHook defaultConfig
                           <+> manageDocks
                           <+> myManageHook,
      handleEventHook    = myEventHook,
      startupHook        = myStartupHook
} `additionalKeysP` myKeys
