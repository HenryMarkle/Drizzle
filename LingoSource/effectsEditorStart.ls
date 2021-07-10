global gTEprops, gTiles, gEEprops, gLEprops, gLOprops, gEnvEditorProps

on exitFrame me
  
  sprite(15).color = color(255, 255, 255)
  
  member("effectsMatrix").image = image(52,40,32)
  
  sprite(3).blend = 30
  sprite(4).blend = 50
  sprite(5).blend = 70
  sprite(6).blend = 100
  
  repeat with spr = 3 to 9 then
    sprite(spr).rect = rect(16,16,53*16, 41*16)
  end repeat
  
  
  
  repeat with q = 1 to gLOprops.size.loch then
    repeat with c = 1 to gLOprops.size.locv then
      member("effectsMatrix").image.setPixel(q-1, c-1, color(0, 0, 0))
    end repeat
  end repeat
  
  member("TEimg1").image = image(52*16, 40*16, 16)
  member("TEimg2").image = image(52*16, 40*16, 16)
  member("TEimg3").image = image(52*16, 40*16, 16)
  member("levelEditImage1").image = image(52*16, 40*16, 16)
  member("levelEditImage2").image = image(52*16, 40*16, 16)
  member("levelEditImage3").image = image(52*16, 40*16, 16)
  member("levelEditImageShortCuts").image = image(52*16, 40*16, 16)
  
  TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 1)
  TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 2)
  TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 3)
  lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 1)
  lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 2)
  lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 3)
  drawShortCutsImg(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 16)
  
  gDirectionKeys = [0,0,0,0]
  
  sprite(3).blend = 10
  sprite(4).blend = 10
  sprite(5).blend = 60
  sprite(6).blend = 10
  sprite(7).blend = 70
  sprite(8).blend = 100
  
  
  --  sav = gLeProps.camPos
  --  gLeProps.camPos = point(0,0)
  --  repeat with l = 1 to 3 then
  --    lvlEditDraw(rect(1,1,cols,rows), l, 1)
  --    TEdraw(rect(1,1,cols,rows), l, 1)
  --  end repeat
  --  drawShortCutsImg(rect(1,1,cols,rows))
  --  gLeProps.camPos = sav
  
  l = [#n:0, #m1:0, m2:0, #w:0, #a:0, #s:0, #d:0, #e:0, #r:0, #f:0]
  gEEprops.lastKeys = l.duplicate()
  gEEprops.keys = l.duplicate()
  
  -- call(#updateEffectsMenu, point(0,0))
  --call(#up script("effectsEditor").initMode("createNew")
  script("effectsEditor").updateEffectsMenu(point(0,0))
  script("effectsEditor").updateEffectsL(0)
  script("effectsEditor").initMode("createNew")
  -- script("effectsEditor").initMode("createNew")
  
  script("effectsEditor").drawEfMtrx(gEEprops.editEffect)
end


