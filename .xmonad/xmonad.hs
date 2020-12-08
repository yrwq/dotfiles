import XMonad
import Data.Monoid
import System.Exit
import System.IO.Unsafe
import Data.Maybe
import Data.List (sortBy)
import Data.Function (on)
import Data.List as DL
import Data.Char as DC
import Data.Bifunctor

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog

import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (safeSpawn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.WindowGo
import Control.Monad (forM_, join)
import XMonad.Util.NamedWindows (getName)

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2
myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5"]

myTerminal = "$TERMINAL"


clrbg = getColor "*background"
clrfg = getColor "*foreground"

myNormalBorderColor  = clrbg
myFocusedBorderColor = clrfg

myKeys :: [(String, X ())]
myKeys =
 [ ("M-<Return>", spawn "$TERMINAL")
  , ("M-t", spawn "emacsclient -c /mnt/doc/org/todo.org")
  , ("M-e", spawn "emacsclient -c")
  , ("M-r", spawn "st -c files -e lf")
  , ("M-n", spawn "st -c news -e newsboat")
  , ("M-s", spawn "rofi -show drun")
  , ("M-S-m", spawn "st -c mail -e neomutt")
  , ("M-S-r", spawn "xmonad --recompile;xmonad --restart")
  , ("M-S-e", io exitSuccess)
  , ("M-q", kill)
  , ("M-.", incWindowSpacing 5)
  , ("M-,", decWindowSpacing 5)
  , ("M1-<Up>", spawn "pamixer -i 5")
  , ("M1-<Down>", spawn "pamixer -d 5")
  , ("M1-y", spawn "nerdy")
  , ("M1-e", spawn "rofimoji")
  , ("<Print>", spawn "lien -s -f")
  , ("M-w", runOrRaise "qutebrowser" (className =? "qutebrowser"))
  , ("M-x", runOrRaise "discocss" (className =?  "Discord"))
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

myLayout = avoidStruts (gaps [(U,35), (R,5), (D,5), (L,5)] $ tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = spacing 5 $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myManageHook = composeAll
    [ className =? "mpv"        --> doFloat
    , className =? "news"        --> doFloat
    , className =? "files"        --> doFloat
    , className =? "mail"        --> doFloat
    , className =? "Sxiv"        --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mconcat [ fullscreenEventHook
          ]

myStartupHook = do
              spawn "flavours apply gruvbox-dark-pale"
              spawn "xrdb ~/.Xresources"
              spawn "$HOME/.config/polybar/launch.sh"
              spawnOnce "picom"
              spawnOnce "emacs --daemon"
              spawnOnce "nitrogen --restore"

updateGaps :: (Functor f, Bifunctor p) => (c -> d) -> f (p b c) -> f (p b d)
updateGaps f = fmap $ bimap id f

getFromXres :: String -> IO String
getFromXres key = fromMaybe "" . findValue key <$> runProcessWithInput "xrdb" ["-query"] ""
  where
    findValue :: String -> String -> Maybe String
    findValue xresKey xres =
      snd <$> (
                DL.find ((== xresKey) . fst)
                $ catMaybes
                $ splitAtColon
                <$> lines xres
              )

    splitAtColon :: String -> Maybe (String, String)
    splitAtColon str = splitAtTrimming str <$> (DL.elemIndex ':' str)

    splitAtTrimming :: String -> Int -> (String, String)
    splitAtTrimming str idx = bimap trim trim . (second tail) $ splitAt idx str

    trim :: String -> String
    trim = DL.dropWhileEnd (DC.isSpace) . DL.dropWhile (DC.isSpace)

getColor :: String -> String
getColor = unsafePerformIO . getFromXres

main = do
  xmonad $ ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        -- logHook            = eventLogHook,
        manageHook         = manageDocks <+> manageHook def,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook
} `additionalKeysP` myKeys
