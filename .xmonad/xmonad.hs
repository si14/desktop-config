-- Imports.
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWindows
import XMonad.Actions.CycleWS
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import XMonad.Prompt
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W

-- The main function.
main = do
	xmproc <- spawnPipe "xmobar /home/alwx/.xmobarrc"
	xmonad $ defaultConfig { 
			modMask = mod4Mask, 
			terminal = "sakura",
			focusFollowsMouse = False,
			focusedBorderColor = "yellow",
			layoutHook = avoidStruts  $  layoutHook defaultConfig,
			manageHook = manageDocks <+> myManageHook
					<+> manageHook defaultConfig,
			workspaces = myWorkspaces,
			logHook = dynamicLogWithPP xmobarPP {
				ppOutput = hPutStrLn xmproc,
				ppTitle = xmobarColor "#eee" "" . shorten 120
			}
		}
		`additionalKeysP`
		[
			("M1-b", spawn "chromium"),
			("M1-f", spawn "thunar"),
			("C-M1-l", spawn "slock"),
			("M-<Right>", nextWS),
			("M-<Left>", prevWS),
			("M-S-<Right>", shiftToNext),
			("M-S-<Left>", shiftToPrev),
			("M-s", shellPrompt promptConfig)
		]

promptConfig = defaultXPConfig {
	font = "xft:Droid Sans Mono:size=8",
	position = Bottom
}

myWorkspaces = ["im", "web", "dev", "files", "other"]

myManageHook = composeAll 
	[
	className =? "Chromium"       --> doF (W.shift (myWorkspaces !! 1)),
	className =? "Geany"          --> doF (W.shift (myWorkspaces !! 2)),
	]
