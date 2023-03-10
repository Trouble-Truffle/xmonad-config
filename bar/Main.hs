module Main (main) where

------------------------------------------------------------------------------
-- \|
-- Copyright: (c) 2018, 2019, 2022 Jose Antonio Ortega Ruiz
-- License: BSD3-style (see LICENSE)
--
-- Maintainer: jao@gnu.org
-- Stability: unstable
-- Portability: portable
-- Created: Sat Nov 24, 2018 21:03
--
--
-- An example of a Haskell-based xmobar. Compile it with
--   ghc --make -- xmobar.hs
-- with the xmobar library installed or simply call:
--   xmobar /path/to/xmobar.hs
-- and xmobar will compile and launch it for you and
------------------------------------------------------------------------------

import Xmobar

-- Example user-defined plugin

data HelloWorld = HelloWorld
  deriving (Read, Show)

instance Exec HelloWorld where
  alias HelloWorld = "hw"
  run HelloWorld = return "<fc=red>xmo</fc>"

-- Configuration, using predefined monitors as well as our HelloWorld
-- plugin:

config :: Config
config =
  defaultConfig
    { font = "xft:Sans Mono-10"
    , additionalFonts = []
    , borderColor = "black"
    , border = TopB
    , bgColor = "black"
    , fgColor = "grey"
    , alpha = 255
    , position = Top
    , textOffset = -1
    , iconOffset = -1
    , lowerOnStart = True
    , pickBroadest = False
    , persistent = False
    , hideOnStart = False
    , iconRoot = "."
    , allDesktops = True
    , overrideRedirect = True
    , textOutputFormat = Ansi
    , commands =
        [ Run $ Network "eth0" ["-L", "0", "-H", "32", "--normal", "green", "--high", "red"] 10
        , Run $ Network "eth1" ["-L", "0", "-H", "32", "--normal", "green", "--high", "red"] 10
        , Run $ Cpu ["-L", "3", "-H", "50", "--normal", "green", "--high", "red"] 10
        , Run $ Memory ["-t", "Mem: <usedratio>%"] 10
        , Run $ Swap [] 10
        , Run $ Com "uname" ["-s", "-r"] "" 36000
        , Run $ Date "%a %b %_d %Y %H:%M:%S" "date" 10
        , Run $ BatteryP ["BAT0"] ["-t", "<acstatus><watts> (<left>%)", "-L", "10", "-H", "80", "-p", "3", "--", "-O", "<fc=green>On</fc> - ", "-i", "", "-L", "-15", "-H", "-5", "-l", "red", "-m", "blue", "-h", "green", "-a", "notify-send -u critical 'Battery running out!!'", "-A", "3"] 600
        , Run XMonadLog
        ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%XMonadLog% | %cpu% | %memory% * %swap% }{ <fc=#ee9a00>%date%</fc> | %battery% | %uname%"
    }

main :: IO ()
main = configFromArgs config >>= xmobar
