#--
# Planet Overgamma
# a game about planets, machines, and robots.
# copyright (C) 2018-19 iLiquid
#--

import rapid/gfx

import ../res

proc mouseInArea*(x, y, w, h: float): bool =
  result = win.mouseX >= x and win.mouseY >= y and
           win.mouseX < x + w and win.mouseY < y + h

proc mouseInCircle*(x, y, r: float): bool =
  let
    dx = x - win.mouseX
    dy = y - win.mouseY
  result = dx * dx + dy * dy <= r * r
