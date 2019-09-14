#--
# Planet Overgamma
# a game about planets, machines, and robots.
# copyright (C) 2018-19 iLiquid
#--

import gui/windows
import debug
import res

var
  wm*: WindowManager
  winGame*, winHud*, winToolbox*: Window

proc initGUI*() =
  info("Opening", "GUIs")
  wm = newWindowManager(win)
  # TODO: mode wheel
  winGame = wm.newWindow(0, 0, 0, 0, "Game", wkGame)
  wm.add(winGame)
  winHud = wm.newWindow(0, 0, 0, 0, "HUD", wkHud)
  wm.add(winHud)

  var winTest = wm.newWindow(128, 128, 256, 256, "Controls", wkDecorated)
  wm.add(winTest)
