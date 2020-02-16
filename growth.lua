-- growth (nc01-drone)
-- @dewb
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

function load_sample(i)
  names = {"dd.wav", "bc.wav", "eb.wav"}
  file = _path.code .. "nc01-drone/lib/" .. names[i]
  softcut.buffer_read_mono(file,0,0,-1,1,1)
end

function init()
	load_sample(1)
  softcut.enable(1,1)
  softcut.buffer(1,1)
  softcut.level(1,1.0)
  softcut.level_slew_time(1, 0.25)
  softcut.loop(1,1)
  softcut.loop_start(1,1)
  softcut.loop_end(1,2)
  softcut.position(1,1)
  softcut.rate(1,1.0)
  softcut.play(1,1)
  softcut.pre_filter_hp(1, 4.0)
  softcut.pre_filter_rq(1, 4.0)
  softcut.pre_filter_dry(1, 0.0)

  print("approaching...")
end

v = 1.0
s = 1
e = 2
r = 1
world = 1
fc = 5000

function enc(n,d)
  if n == 1 then
    v = util.clamp(v + d/100, 0, 4)
    softcut.level(1,v)
  elseif n == 3 then
    s = s + d/50
    e = e + d/40
    softcut.loop_start(1,s)
    softcut.loop_end(1,e)
  elseif n == 2 then
    local mag = math.abs(d)
    local sign = d / mag
    if mag > 4 then
      r = r + sign*(mag-3)/100
      softcut.rate(1, r)
    else
      fc = util.clamp(fc + d * 100, 200, 32000)
      softcut.pre_filter_fc(1, fc)
      print(fc)
    end
  end
end

function key(n,z)
  if z == 0 then return end
  if n == 2 then
    k = math.random(1,20) - 10
    s = s + k
    e = s + 1
    softcut.loop_start(1,s)
    softcut.loop_end(1,e)
  elseif n == 3 then
    world = (world % 3) + 1
    load_sample(world)
  end
end

function redraw()
  screen.clear()
  screen.move(64,50)
  screen.aa(1)
  screen.font_face(4)
  screen.font_size(50)
  screen.text_center("3")
  screen.update()
end
