global gSEProps, gLEVEL

on exitFrame me
  
  
  
  repeat with q = 1 to 4 then
    repeat with c = 1 to 2 then
      if c = 1 then
        sprite(30+((q-1)*2)+c).loc = point(100+(gSEProps.sounds[q].vol/255.0)*500, (q-1)*150 + c*50 + 100)
      else if c = 2 then
        sprite(30+((q-1)*2)+c).loc = point(100+250+(gSEProps.sounds[q].pan/100.0)*250, (q-1)*150 + c*50 + 100)
      end if
    end repeat
  end repeat
  
  sprite(50).loc = _mouse.mouseLoc+point(20,20)
  
  
  if _mouse.mouseDown then
    repeat with q = 1 to gSEProps.rects.count then
      if _mouse.mouseLoc.inside(gSEProps.rects[q][1]) then
        if gSEProps.rects[q][2][2] = 1 then
          gSEProps.sounds[gSEProps.rects[q][2][1]].vol = ((_mouse.mouseLoc.locH-100)/500.0)*255
          gSEProps.sounds[gSEProps.rects[q][2][1]].vol = restrict(gSEProps.sounds[gSEProps.rects[q][2][1]].vol, 0, 255)
          --          if gSEProps.sounds[gSEProps.rects[q][2][1]].vol = 0 then
          --            gSEProps.sounds[gSEProps.rects[q][2][1]].mem = "None"
          --            member("AmbienceSound"&gSEProps.rects[q][2][1]).text = "No ambience sound"
          --          end if
          sound(gSEProps.rects[q][2][1]).volume =  gSEProps.sounds[gSEProps.rects[q][2][1]].vol
        else
          gSEProps.sounds[gSEProps.rects[q][2][1]].pan = ((_mouse.mouseLoc.locH-350)/500.0)*255
          gSEProps.sounds[gSEProps.rects[q][2][1]].pan = restrict(gSEProps.sounds[gSEProps.rects[q][2][1]].pan, -100, 100)
          sound(gSEProps.rects[q][2][1]).pan =  gSEProps.sounds[gSEProps.rects[q][2][1]].pan
        end if
        exit repeat
      end if
    end repeat
  end if
  
  if _mouse.mouseLoc.inside(rect(760, 50, 860, 1000)) then
    lstPos = _mouse.mouseLoc.locv/12
    
    
    lstPos = lstPos - 4
    if (lstPos > 0)and(lstPos<= gSEprops.ambientSounds.count) then
      sprite(11).loc = point(750, 6+(lstPos+4)*12)
      if _mouse.mouseDown then
        gSEprops.pickedUpSound = gSEprops.ambientSounds[lstPos]
        member("buttonText").text = gSEprops.ambientSounds[lstPos]
      end if
    else
      sprite(11).loc = point(-100, -100)
      lstPos = lstPos - gSEprops.ambientSounds.count - 5
      if (lstPos > 0)and(lstPos<= gSEprops.songs.count) then
        sprite(11).loc = point(745, 6+(lstPos+4+gSEprops.ambientSounds.count+5)*12)
        if _mouse.mouseDown then
          gLEVEL.music = gSEprops.songs[lstPos]
          
          if gLEVEL.music = "none" then
            sav = member("music")
            member("music").importFileInto("music\" & "overwrite" &".mp3")
            sav.name = "music"
            sound(5).pan = 0
            sound(5).volume = 0
            sound(5).stop()
          else
            sav = member("music")
            member("music").importFileInto("music\" & gLEVEL.music &".mp3")
            sav.name = "music"
            sound(5).pan = 0
            sound(5).volume = 255
            sound(5).play([#member:sav, #loopCount:0])
          end if
          
          sprite(12).loc = point(750, 6+(lstPos+4+gSEprops.ambientSounds.count+5)*12)
        end if
      end if
    end if
  else
    sprite(11).loc = point(-100, -100)
  end if
  
  
  script("levelOverview").goToEditor()
  
  go the frame
end