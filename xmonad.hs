-- Imports.
import qualified Data.Map as Map
import System.IO

import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.CycleWindows
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowNavigation
import XMonad.Actions.DwmPromote

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.Themes

import XMonad.Layout.DwmStyle

import XMonad.Prompt
import XMonad.Prompt.Shell

import qualified XMonad.StackSet as W

modm = mod4Mask

-- The main function.
main = do
	xmproc <- spawnPipe "xmobar /home/si14/.xmobarrc"
        config <- withWindowNavigationKeys myWinNavKeys
                  $ defaultConfig { modMask = mod4Mask,
                                    terminal = "sakura",
                                    focusFollowsMouse = False,
                                    focusedBorderColor = "yellow",
                                    layoutHook = myLayoutHook,
                                    manageHook = myManageHook,
                                    workspaces = myWorkspaces,
                                    logHook = myLogHook xmproc
                                  }
                  `additionalKeysP` myKeys
        xmonad config

promptConfig = defaultXPConfig {
	font = "xft:Ubuntu:size=10",
	position = Bottom
}

myWorkspaces = ["im", "web", "dev", "files", "other"]

myManageHook = manageDocks
             <+> composeAll []
             <+> manageHook defaultConfig

--myManageHook = composeAll  []
	--[
	--className =? "Chromium"       --> doF (W.shift (myWorkspaces !! 1)),
	--className =? "Geany"          --> doF (W.shift (myWorkspaces !! 2)),
	--]

myDWConfig = (theme smallClean) { fontName   = "xft:Ubuntu:size=8",
                                  decoHeight = 16 }

myLayoutHook = avoidStruts
               $ dwmStyle shrinkText myDWConfig
               $ layoutHook defaultConfig

myLogHook = \xmobarProc ->
  dynamicLogWithPP xmobarPP {
    ppOutput = hPutStrLn xmobarProc,
    ppTitle = xmobarColor "#eee" "" . shorten 120
    }

myWinNavKeys =
  [ ((modm              , xK_Up),    WNGo   U),
    ((modm              , xK_Left),  WNGo   L),
    ((modm              , xK_Down),  WNGo   D),
    ((modm              , xK_Right), WNGo   R),
    ((modm .|. shiftMask, xK_Up),    WNSwap U),
    ((modm .|. shiftMask, xK_Left),  WNSwap L),
    ((modm .|. shiftMask, xK_Down),  WNSwap D),
    ((modm .|. shiftMask, xK_Right), WNSwap R) ]

myKeys = [("M-M1-b", spawn "google-chrome"),
          ("M-M1-f", spawn "thunar"),

          --("C-M1-l", spawn "slock"),

          ("C-M1-<Right>",   nextWS),
          ("C-M1-<Left>",    prevWS),
          ("C-M1-S-<Right>", shiftToNext >> nextWS),
          ("C-M1-S-<Left>",  shiftToPrev >> prevWS),
          ("C-M-S-<Left>",   shiftPrevScreen),
          ("C-M-S-<Right>",  shiftNextScreen),

          ("M-<Return>", dwmpromote),

          ("M-x", shellPrompt promptConfig)]
