-- desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks(avoidStruts, docksEventHook, manageDocks)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Util.SpawnOnce

import XMonad.Prompt.ConfirmPrompt

-- my custom settings
myTerminal :: String
myTerminal = "alacritty"

-- Color theming
myNormalBorderColor :: String
myNormalBorderColor = "#7c7c7c" -- gray for unfocused windows

myFocusedBorderColor :: String
myFocusedBorderColor = "#2ebd76" -- green-blue for focused


-- Startup hooks
-- myStartupHook :: X ()
myStartupHook = do
    -- compositor
    spawnOnce "compton -b"
    -- background
    spawnOnce "~/.fehbg &"
    -- screenshot tool
    spawnOnce "flameshot &"
    -- multiple keyboard layouts
    spawnOnce "setxkbmap -layout us,ru"
    -- bar
    spawnOnce "polybar -r &"
    -- spawnOnce "./eww/target/release/eww open bar" -> configure it later
    -- power management
    spawnOnce "xfce4-power-manager &"
    -- bluetooth tool
    spawnOnce "blueman-applet"
    -- network tool
    spawnOnce "nm-applet"


-- Key bindings
-- set Alt to default modifier
myModMask = mod1Mask

myKeys = --conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
    -- Mute Volume
    ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")

    -- Decrease Volume
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")

    -- Increase Volume
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")

    -- Increase Brightness
    , ((0, xF86XK_MonBrightnessUp), spawn "light -A 5")

    -- Decrease Brightness
    , ((0, xF86XK_MonBrightnessDown), spawn "light -U 5")
        
    -- Take Screenshot
    , ((0, xK_Print), spawn "flameshot gui")

    -- Lock Screen
    , ((myModMask .|. shiftMask, xK_b), spawn "betterlockscreen -l")

    -- Rofi menu
    , ((myModMask ,xK_p), spawn "rofi -no-config -no-lazy-grab -show drun -modi drun -theme $HOME/.config/rofi/launchers/type-1/style-1.rasi")

    -- Power Menu
    , ((myModMask .|. shiftMask, xK_q), spawn "rofi-power-menu")

    -- Suspend
    , ((0, xF86XK_PowerOff), spawn "rofi-power-menu")

    , ((0, xF86XK_PowerDown), spawn "rofi-power-menu")
    ]

main :: IO ()
main = do
    xmonad
    $ docks
    $ ewmh --maybe desktopConfig desktop session
    $ def 
    {  
        manageHook = manageDocks <+> manageHook def
        , layoutHook = avoidStruts $ layoutHook def
        -- startup scripts
        , startupHook = myStartupHook
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , borderWidth = 3
        , terminal = myTerminal
    } `additionalKeys` myKeys
