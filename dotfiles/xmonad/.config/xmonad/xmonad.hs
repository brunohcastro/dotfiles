--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import qualified Data.Map as M
import Data.Maybe (fromJust, isJust)
import Data.Monoid
import System.Directory
import System.Exit (ExitCode (ExitSuccess), exitSuccess, exitWith)
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (WSType (WSIs))
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, filterOutWsPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.DynamicProperty (dynamicPropertyChange)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen, fullscreenEventHook)
import XMonad.Hooks.ManageDocks (avoidStruts, checkDock, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, doLower, isDialog, isFullscreen)
import XMonad.Hooks.RefocusLast (isFloat)
import XMonad.Layout.NoBorders (smartBorders)
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce (spawnOnce)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["dev", "chat", "www", "4", "5", "6", "7", "8", "9"]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..]

colorScheme = "doom-one"

colorBack = "#282c34"

colorFore = "#bbc2cf"

color01 = "#1c1f24"

color02 = "#ff6c6b"

color03 = "#98be65"

color04 = "#da8548"

color05 = "#51afef"

color06 = "#c678dd"

color07 = "#5699af"

color08 = "#202328"

color09 = "#5b6268"

color10 = "#da8548"

color11 = "#4db5bd"

color12 = "#ecbe7b"

color13 = "#3071db"

color14 = "#a9a1e1"

color15 = "#46d9ff"

color16 = "#dfdfdf"

colorTrayer :: String
colorTrayer = "--tint 0x282c34"

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor = "#dddddd"

myFocusedBorderColor = "#ff0000"

isVisible w ws = any ((w ==) . W.tag . W.workspace) (W.visible ws)

lazyView w ws = if isVisible w ws then ws else W.view w ws

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
      -- launch rofi
      ((modm, xK_e), spawn "rofi -show drun -modi drun,window,run,ssh"),
      -- launch gmrun
      ((modm .|. shiftMask, xK_p), spawn "gmrun"),
      -- close focused window
      ((modm .|. shiftMask, xK_q), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm, xK_Return), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm, xK_l), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

      -- Quit xmonad
      ((modm .|. shiftMask, xK_l), io exitSuccess),
      -- Restart xmonad
      ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart"),
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\" -"))
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(lazyView, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_g, xK_c, xK_r] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      [ ((0, xK_F12), namedScratchpadAction myScratchPads "terminal"),
        ((modm .|. shiftMask, xK_m), namedScratchpadAction myScratchPads "music"),
        ((modm .|. shiftMask, xK_s), namedScratchpadAction myScratchPads "calculator")
      ]
  where
    -- The following lines are needed for named scratchpads.
    nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "terminal" spawnTerm findTerm manageTerm,
    NS "music" spawnSpotify findSpotify manageSpotify,
    NS "calculator" spawnCalc findCalc manageCalc
  ]
  where
    spawnTerm = myTerminal ++ " -t scratchpad"
    findTerm = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w
    spawnSpotify = "/home/bruno/.local/bin/spotify"
    findSpotify = className =? "Spotify"
    manageSpotify = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w
    spawnCalc = "qalculate-gtk"
    findCalc = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
      where
        h = 0.5
        w = 0.4
        t = 0.75 - h
        l = 0.70 - w

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook =
  composeAll
    [ manageDocks,
      className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      className =? "confirm" --> doFloat,
      className =? "dialog" --> doFloat,
      className =? "Galculator" --> doFloat,
      className =? "copyq" --> doFloat,
      className =? "Yad" --> doFloat,
      className =? "spotify" --> doFloat,
      appName =? "pavucontrol" --> doFloat,
      appName =? "blueman-manager" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore,
      isFullscreen --> doFullFloat,
      isFloat --> doCenterFloat,
      isDialog --> doCenterFloat,
      className =? "discord" --> doShift (myWorkspaces !! 1),
      className =? "Slack" --> doShift (myWorkspaces !! 1),
      className =? "Google-chrome" --> doShift (myWorkspaces !! 2)
    ]
    <+> namedScratchpadManageHook myScratchPads

--    <+> dynamicPropertyChange "WM_NAME" composeAll [(title =? "Spotify" --> customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))

myDynamicManageHook =
  composeAll
    [ className =? "Spotify" --> doCenterFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook = do
  spawn "killall trayer"
  spawn "killall picom"
  spawnOnce "nm-applet"
  spawnOnce "xfce4-power-manager"
  spawnOnce "volumeicon"
  spawnOnce "dunst"
  spawnOnce "unclutter"
  spawnOnce "nitrogen --restore"
  spawnOnce "dex -ae i3"
  spawn "sleep 2 && picom"
  spawn "sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x000000 --height 22 --iconspacing 10"
  spawn "xsetroot -xcf /usr/share/icons/capitaine-cursors/cursors/left_ptr 16"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/bruno/.config/xmobar/xmobarrc"
  xmonad $
    ewmhFullscreen $
      docks $
        ewmh
          def
            { -- simple stuff
              terminal = myTerminal,
              focusFollowsMouse = myFocusFollowsMouse,
              clickJustFocuses = myClickJustFocuses,
              borderWidth = myBorderWidth,
              modMask = myModMask,
              workspaces = myWorkspaces,
              normalBorderColor = myNormalBorderColor,
              focusedBorderColor = myFocusedBorderColor,
              -- key bindings
              keys = myKeys,
              mouseBindings = myMouseBindings,
              -- hooks, layouts
              layoutHook = smartBorders $ myLayout,
              manageHook = myManageHook,
              handleEventHook = dynamicPropertyChange "WM_NAME" myDynamicManageHook <+> myEventHook,
              logHook =
                dynamicLogWithPP $
                  filterOutWsPP [scratchpadWorkspaceTag] $
                    xmobarPP
                      { ppOutput = \x -> hPutStrLn xmproc x, -- xmobar on monitor 1
                      --                        >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                      --                        >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
                        ppCurrent =
                          xmobarColor color06 ""
                            . wrap
                              ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">")
                              "</box>",
                        -- Visible but not current workspace
                        ppVisible = xmobarColor color06 "" . clickable,
                        -- Hidden workspace
                        ppHidden =
                          xmobarColor color05 ""
                            . wrap
                              ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">")
                              "</box>"
                            . clickable,
                        -- Hidden workspaces (no windows)
                        ppHiddenNoWindows = xmobarColor color05 "" . clickable,
                        -- Title of active window
                        ppTitle = xmobarColor color16 "" . shorten 60,
                        -- Separator character
                        ppSep = "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>",
                        -- Urgent workspace
                        ppUrgent = xmobarColor color02 "" . wrap "!" "!",
                        -- Adding # of windows on current workspace to the bar
                        ppExtras = [windowCount],
                        -- order of things in xmobar
                        ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                      },
              startupHook = myStartupHook
            }

-- Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-Shift-Enter  Launch alacritty",
      "mod-e            Launch rofi",
      "mod-Shift-p      Launch gmrun",
      "mod-Shift-q      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-Shift-j  Swap the focused window with the next window",
      "mod-Shift-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-q  Quit xmonad",
      "mod-q        Restart xmonad",
      "mod-[1..9]   Switch to workSpace N",
      "",
      "-- Workspaces & screens",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{g,c,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{g,c,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
