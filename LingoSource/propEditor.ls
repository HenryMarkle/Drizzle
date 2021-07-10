

global gLEProps, TEdraw, gDirectionKeys, gLOprops, gPEprops, gProps, gPEblink, gPEcounter, peScrollPos, peSavedRotat, peSavedFlip, peFreeQuad, peMousePos, lastPeMouse, mouseStill, propSettings, editSettingsProp, peSavedStretch


global ropeModel, settingsPropType, gPEcolors, closestProp, longPropPlacePos, snapToGrid

on exitFrame me
  lastPeMouse = peMousePos
  gPEblink = gPEblink + 1
  if(gPEblink > 800)then
    gPEblink = 0
  end if
  
  if(gPEcounter > 0)then
    gPEcounter = gPEcounter - 1
  end if
  
  if(editSettingsProp < 0)then
    member("tileMenu").alignment = #left
  else
    member("tileMenu").alignment = #center
  end if
  
  if((IsDecal(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]) = 0)and(propPlaceLayer() <= 5)and(propPlaceLayer() + gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].depth >= 6))then
    
    member("Prop editor warning text").text = "WARNING - this prop will intersect with the play layer!"
    
    
    if (gPEblink < 600)then
      sprite(18).visibility = true
    else
      sprite(18).visibility = false
    end if
    if(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "antimatter")then
      member("Prop editor warning text").text = "Antimatter prop intersecting play layer - remember to use a restore effect on affected play relevant terrain"
      sprite(17).color = color(255,255,255)
      sprite(18).color = color(255,255,255)
    else
      member("Prop editor warning text").text = "WARNING - this prop will intersect with the play layer!"
      sprite(17).color = color(255, 0, 0)
      sprite(18).color = color(255, 0, 0)
    end if
  else
    sprite(18).visibility = false
    sprite(17).color = color(255,255,255)
  end if
  
  repeat with q = 1 to 4 then
    
    if (_key.keyPressed([86, 91, 88, 84][q]))and(gDirectionKeys[q] = 0) and _movie.window.sizeState <> #minimized then
      
      gLEProps.camPos = gLEProps.camPos + [point(-1, 0), point(0,-1), point(1,0), point(0,1)][q] * (1 + 9 * _key.keyPressed(83) + 34 * _key.keyPressed(85))
      if not _key.keyPressed(92) then
        if gLEProps.camPos.loch < -1 then
          gLEProps.camPos.loch = -1
        end if
        if gLEProps.camPos.locv < -1 then
          gLEProps.camPos.locv = -1
        end if  
        if gLEProps.camPos.loch > gLEprops.matrix.count-51 then
          gLEProps.camPos.loch = gLEprops.matrix.count-51
        end if
        if gLEProps.camPos.locv > gLEprops.matrix[1].count-39 then
          gLEProps.camPos.locv = gLEprops.matrix[1].count-39
        end if
      end if
      repeat with l = 1 to 3 then
        lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
        TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
      end repeat
      drawShortCutsImg(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 16)
      renderPropsImage()
    end if
    gDirectionKeys[q] = _key.keyPressed([86, 91, 88, 84][q])
  end repeat
  
  
  sprite(8).visibility = false
  
  script("levelOverview").goToEditor()
  
  if(editSettingsProp = -1)then
    if _key.keyPressed(SPACE) and _movie.window.sizeState <> #minimized then 
      
      if (_key.keyPressed("W")) and (_key.keyPressed("A")) then
        gPEprops.propRotation = 270 + 45
        gPEcounter = 100
      else if (_key.keyPressed("W")) and (_key.keyPressed("D")) then
        gPEprops.propRotation =  45
        gPEcounter = 100
      else if (_key.keyPressed("S")) and (_key.keyPressed("D")) then
        gPEprops.propRotation =  90+45
        gPEcounter = 100
      else if (_key.keyPressed("S")) and (_key.keyPressed("A")) then
        gPEprops.propRotation =  180+45
        gPEcounter = 100
      else if (gPEcounter = 0)then
        if _key.keyPressed("W")then
          gPEprops.propRotation = 0
        else if _key.keyPressed("A")then
          gPEprops.propRotation = 270
        else if _key.keyPressed("S")then
          gPEprops.propRotation = 180
        else if _key.keyPressed("D")then
          gPEprops.propRotation = 90
        end if
      end if
    else if _movie.window.sizeState <> #minimized then
      if checkKey("W") then
        updatePropMenu(point(0, -1))
      end if
      if checkKey("S") then
        updatePropMenu(point(0, 1))
      end if
      if checkKey("A") then
        updatePropMenu(point(-1, 0))
      end if
      if checkKey("D") then
        updatePropMenu(point(1, 0))
      end if
    end if
  else
    if(editSettingsProp > gPEprops.props.count)then
      editSettingsProp = -1
      updatePropMenu(point(0, 0))
    else if _movie.window.sizeState <> #minimized then
      if checkKey("W") then
        updatePropSettings(point(0, -1))
      end if
      if checkKey("S") then
        updatePropSettings(point(0, 1))
      end if
      if checkKey("A") then
        updatePropSettings(point(-1, 0))
      end if
      if checkKey("D") then
        updatePropSettings(point(1, 0))
      end if
    end if
  end if
  
  
  
  
  if checkKey("Z") then
    gPEprops.color = gPEprops.color + 1
    if(gPEprops.color > gPEcolors.count)then
      gPEprops.color = 0
    end if
    if gPEprops.color = 0 then
      member("Prop Color Text").text = "PROP COLOR: " &"NONE"
      sprite(21).color = color(150, 150, 150)
    else
      member("Prop Color Text").text = "PROP COLOR: " & gPEcolors[gPEprops.color][1]
      sprite(21).color = gPEcolors[gPEprops.color][2]
    end if
  end if
  if(gPEprops.color = 1)then
    sprite(21).color = color(random(255), random(255), random(255))
  end if
  
  if checkKey("N") then
    if(editSettingsProp = -1)then
      editSettingsProp = 0
      --  DuplicatePropSettings()
      updatePropSettings(point(0,0))
    else
      editSettingsProp = -1
      updatePropMenu(point(0, 0))
    end if
  end if
  
  if _key.keyPressed("Q") and _movie.window.sizeState <> #minimized then
    gPEprops.propRotation = gPEprops.propRotation - 0.01
    if _key.keyPressed(SPACE) then
      gPEprops.propRotation = gPEprops.propRotation - 0.1
    end if
    mouseStill = 0
  else if _key.keyPressed("E") and _movie.window.sizeState <> #minimized then
    gPEprops.propRotation = gPEprops.propRotation + 0.01
    if _key.keyPressed(SPACE) then 
      gPEprops.propRotation = gPEprops.propRotation + 0.1
    end if
    mouseStill = 0
  end if
  
  if(gPEprops.propRotation < 0)then
    gPEprops.propRotation = gPEprops.propRotation + 360
  else if (gPEprops.propRotation>=360) then
    gPEprops.propRotation = gPEprops.propRotation - 360
  end if
  
  if _key.keyPressed(SPACE) and _movie.window.sizeState <> #minimized then 
    if _key.keyPressed("Y")then
      gPEprops.propFlipY = 1
    else if  _key.keyPressed("H")then
      gPEprops.propFlipY = -1
    end if
    if _key.keyPressed("G")then
      gPEprops.propFlipX = 1
    else if  _key.keyPressed("J")then
      gPEprops.propFlipX = -1
    end if
  else
    stretchSpeed = 0.002
    
    if _key.keyPressed("Y")  and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchY = gPEprops.propStretchY + stretchSpeed
      mouseStill = 0
    else if _key.keyPressed("H") and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchY = gPEprops.propStretchY - stretchSpeed
      mouseStill = 0
    end if
    if _key.keyPressed("G") and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchX = gPEprops.propStretchX - stretchSpeed
      mouseStill = 0
    else if _key.keyPressed("J") and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchX = gPEprops.propStretchX + stretchSpeed
      mouseStill = 0
    end if
    if _key.keyPressed("T") and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchX = 1
      gPEprops.propStretchY = 1
    end if
    if _key.keyPressed("R") and _movie.window.sizeState <> #minimized then
      gPEprops.propStretchX = 1
      gPEprops.propStretchY = 1
      gPEprops.propFlipX = 1
      gPEprops.propFlipY = 1
      gPEprops.propRotation = 0
    end if
    
    if(gPEprops.propStretchY < 0.1) then
      gPEprops.propStretchY = 0.1
    else if (gPEprops.propStretchY > 20) then
      gPEprops.propStretchY = 20
    end if
    
    if(gPEprops.propStretchX < 0.1) then
      gPEprops.propStretchX = 0.1
    else if (gPEprops.propStretchX > 20) then
      gPEprops.propStretchX = 20
    end if
  end if
  
  actn1 = 0
  actn2 = 0
  
  gPEprops.keys.m1 = _mouse.mouseDown and _movie.window.sizeState <> #minimized
  if (gPEprops.keys.m1)and(gPEprops.lastKeys.m1=0) then
    actn1 = 1
  end if
  gPEprops.lastKeys.m1 = gPEprops.keys.m1
  
  gPEprops.keys.m2 = _mouse.rightmouseDown and _movie.window.sizeState <> #minimized
  if (gPEprops.keys.m2)and(gPEprops.lastKeys.m2=0) then
    actn2 = 1
  end if
  gPEprops.lastKeys.m2 = gPEprops.keys.m2
  
  if _key.keyPressed("F") and _movie.window.sizeState <> #minimized then
    if(propSettings.findPos(#variation) <> void)and((actn1)or(actn2)) then
      propSettings.variation = propSettings.variation + actn1 - actn2
      mn = (1 - settingsPropType.random)
      if(propSettings.variation < mn)then
        propSettings.variation = settingsPropType.vars
      else if(propSettings.variation > settingsPropType.vars)then
        propSettings.variation = mn
      end if
      updateVariedPreview(settingsPropType, propSettings.variation)
      updateCursorText()
    end if
    
    actn1 = 0
    actn2 = 0
  end if
  
  if(actn2)then
    if _key.keyPressed(SPACE) and _movie.window.sizeState <> #minimized then 
      gPEprops.depth  = gPEprops.depth  - 1
    else 
      gPEprops.depth = gPEprops.depth  + 1
    end if
    if(gPEprops.depth < 0)then
      gPEprops.depth = 9
    else if(gPEprops.depth  > 9)then
      gPEprops.depth  = 0
    end if
    updateWorkLayerText()
  end if
  
  
  
  if _key.keyPressed("C") and _key.keyPressed("X") and _key.keyPressed(48) and _movie.window.sizeState <> #minimized then
    sprite(19).visible = true
    sprite(19).color = color(random(255), 0, 0)
    if(actn1)and(_mouse.mouseLoc.inside(rect(25,25,52,52)))then
      clearAllProps()
    end if
    actn1 = 0
  else
    sprite(19).visible = false
  end if
  
  if checkKey("L") then
    
    gPEprops.workLayer = gPEprops.workLayer +1
    if gPEprops.workLayer > 3 then
      gPEprops.workLayer = 1
    end if
    
    
    if gPEprops.workLayer = 2 then
      sprite(1).blend = 40
      sprite(2).blend = 40
      
      sprite(3).blend = 90
      sprite(4).blend = 90
      sprite(5).blend = 10
      sprite(6).blend = 10
    else if gPEprops.workLayer = 1 then
      sprite(1).blend = 20
      sprite(2).blend = 20
      sprite(3).blend = 40
      sprite(4).blend = 40
      sprite(5).blend = 90
      sprite(6).blend = 90
    else
      sprite(1).blend = 90
      sprite(2).blend = 90
      sprite(3).blend = 10
      sprite(4).blend = 10
      sprite(5).blend = 10
      sprite(6).blend = 10
    end if
    
    updateWorkLayerText()
    renderPropsImage()
    
  end if
  
  
  
  if(gPEprops.propRotation = 0)then
    dir = point(0, -1)
    perp = point(1, 0)
  else if (gPEprops.propRotation = 90)then
    dir = point(1, 0)
    perp = point(0, 1)
  else if (gPEprops.propRotation = 180)then
    dir = point(0, 1)
    perp = point(-1, 0)
  else if (gPEprops.propRotation = 270)then
    dir = point(-1, 0)
    perp = point(0, -1)
  else
    dir = DegToVec(gPEprops.propRotation)
    perp = giveDirFor90degrToLine(-dir, dir)
  end if
  
  if (_key.keyPressed("U")=0)and(_key.keyPressed("I")=0)and(_key.keyPressed("O")=0)and(_key.keyPressed("P")=0)and(_key.keyPressed("X")=0) then
    peMousePos = _mouse.mouseLoc
    if(snapToGrid)then
      peMousePos.loch = ((peMousePos.locH / 16.0)-0.4999).integer * 16
      peMousePos.locv = ((peMousePos.locv / 16.0)-0.4999).integer * 16
    end if
  end if
  
  
  
  
  if (gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "long")then
    if(longPropPlacePos = void)then
      gPEprops.propRotation = 0
      gPEprops.propStretchX = 1
      gPEprops.propStretchY = 1
      gPEprops.propFlipX = 1
      gPEprops.propFlipY = 1
      if(actn1)then
        longPropPlacePos = peMousePos + (point(-16, -16) + gLEProps.camPos*16)
        actn1 = 0
      end if
    else
      gPEprops.propRotation = lookAtpoint(longPropPlacePos - (point(-16, -16) + gLEProps.camPos*16), peMousePos)+90
      gPEprops.propStretchX = Diag(longPropPlacePos - (point(-16, -16) + gLEProps.camPos*16), peMousePos)/(200.0 * (16.0/20.0))
      peMousePos = (longPropPlacePos - (point(-16, -16) + gLEProps.camPos*16) + peMousePos)/2.0
      gPEprops.propStretchY = 1
      gPEprops.propFlipX = 1
      gPEprops.propFlipY = 1
      if(actn1)then
        longPropPlacePos = void
      end if
    end if
  end if
  
  
  
  
  
  lastClosest = closestProp
  closestProp = 0
  
  if(gPEprops.props.count > 0)and((_key.keyPressed("V"))or(_key.keyPressed("B"))or(_key.keyPressed("M")) ) and _movie.window.sizeState <> #minimized then
    closestProp = findClosestProp()
    
  end if
  
  if(editSettingsProp > 0)then
    closestProp = editSettingsProp
  end if
  
  if(closestProp <> lastClosest)and(closestProp < 1)then
    if(["variedDecal", "variedSoft", "variedStandard"].getPos(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp)>0)then
      updateVariedPreview(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV], propSettings.variation)
    end if
  end if
  
  if(closestProp > 0)then
    
    qd = gPEprops.props[closestProp][4] 
    offSetPnt = point(16, 16) - gLEProps.camPos*16
    qd = qd + [offSetPnt, offSetPnt, offSetPnt, offSetPnt]
    if(closestProp <> lastClosest)then
      sprite(15).member = propPreviewMember(gProps[gPEprops.props[closestProp][3].locH].prps[gPEprops.props[closestProp][3].locV])
      if(["variedDecal", "variedSoft", "variedStandard"].getPos(gProps[gPEprops.props[closestProp][3].locH].prps[gPEprops.props[closestProp][3].locV].tp)>0)then
        if closestProp = 0 then
          var = propSettings.variation
        else
          var = gPEprops.props[closestProp][5].settings.variation
        end if
        updateVariedPreview(gProps[gPEprops.props[closestProp][3].locH].prps[gPEprops.props[closestProp][3].locV], var)
      end if
    end if
    
    sprite(17).loc = point(-100, -100)
    
    if _key.keyPressed("V") and _movie.window.sizeState <> #minimized then
      sprite(15).color = color(255,0,0)
      sprite(15).foreColor = 6
      if(actn1) then
        gPEprops.props.deleteAt(closestProp)
        renderPropsImage()
      end if
    else  if _key.keyPressed("B") and _movie.window.sizeState <> #minimized then
      sprite(15).color = color(0,255,255)
      sprite(15).foreColor = color(255, 255, 255)
      if(actn1) then
        gPEprops.pmPos = gPEprops.props[closestProp][3]
        updatePropMenu(point(0, 0))
        
        propSettings = gPEprops.props[closestProp][5].settings
        settingsPropType = gProps[gPEprops.pmPos.loch].prps[gPEprops.pmPos.locV]
        
        editSettingsProp = -1
      end if
    else   if (editSettingsProp > 0) then
      sprite(15).color = color(0,255,0)
      sprite(15).foreColor = 187
    else if _key.keyPressed("M") and _movie.window.sizeState <> #minimized then
      sprite(15).color = color(0,0,255)
      sprite(15).foreColor = 62
      if(actn1) then
        editSettingsProp = closestProp
        propSettings = gPEprops.props[closestProp][5].settings
        settingsPropType = gProps[gPEprops.props[closestProp][3].loch].prps[gPEprops.props[closestProp][3].locV]
        updatePropSettings(point(0,0))
      end if
    end if
    if(editSettingsProp < 1)then
      sprite(15).blend = restrict(50 + 50*sin((gPEblink/800.0)*PI*4.0), 0, 100)
    else
      sprite(15).blend = restrict(50 + 50*sin((gPEblink/800.0)*PI*8.0), 0, 100)
    end if
  else
    mem = propPreviewMember(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV])
    
    scaleFac = 16.0/20.0
    
    qd = [peMousePos, peMousePos, peMousePos, peMousePos]
    qd[1] = qd[1] + (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) - (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
    qd[2] = qd[2] + (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) + (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
    qd[3] = qd[3] - (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) + (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
    qd[4] = qd[4] - (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) - (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
    
    if(_key.keyPressed("U") and _movie.window.sizeState <> #minimized)then
      peFreeQuad[1] = _mouse.mouseLoc - qd[1]
    else if(_key.keyPressed("I") and _movie.window.sizeState <> #minimized)then
      peFreeQuad[2] = _mouse.mouseLoc - qd[2]
    else if(_key.keyPressed("O") and _movie.window.sizeState <> #minimized)then
      peFreeQuad[3] = _mouse.mouseLoc - qd[3]
    else if(_key.keyPressed("P") and _movie.window.sizeState <> #minimized)then
      peFreeQuad[4] = _mouse.mouseLoc - qd[4]
    else if(_key.keyPressed("K") and _movie.window.sizeState <> #minimized) or (_key.keyPressed("R") and _movie.window.sizeState <> #minimized) then
      peFreeQuad = [point(0,0), point(0,0), point(0,0), point(0,0)]
    end if
    
    qd = qd + peFreeQuad
    
    if(actn1)and(_mouse.mouseLoc.inside(rect(16, 16, 848, 656))) then
      offSetPnt = point(-16, -16) + gLEProps.camPos*16
      placeProp(qd + [offSetPnt, offSetPnt, offSetPnt, offSetPnt])
    end if
    sprite(15).blend = 50
    sprite(15).color = color(0,0,0)
    sprite(15).foreColor = 255
    sprite(15).member = mem
    sprite(17).loc = peMousePos + point(40, 20)
  end if
  
  sprite(15).quad = qd
  
  if((gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "rope"))then
    viewRope = false
    
    
    if(lastPeMouse <> peMousePos) then
      mouseStill = 0
    else
      mouseStill = mouseStill + 1
    end if
    
    if(editSettingsProp > 0)or(_key.keyPressed("M") and _movie.window.sizeState <> #minimized)then
      mouseStill = 0
    end if
    
    if(_key.keyPressed("X")=0)then
      if(mouseStill = 10)then
        ropeFrames = 0
        resetRopeProp()
      else if (mouseStill > 10)then
        ropeFrames = ropeFrames + 1
        updateCursorText()
        script("ropeModel").modelRopeUpdate(1, gLEProps.camPos, 16.0/20.0)
        viewRope = true
      end if
    else
      viewRope = true 
    end if
    
    sprite(20).visibility = viewRope
  else
    ropeFrames = 0
    sprite(20).visibility = false
  end if
  
  go the frame
end


on findClosestProp()
  closestProp = 0
  smallestDist = 10000
  
  offSetMousePnt = (peMousePos - point(16, 16) + gLEProps.camPos*16.0) --* 20.0/16.0
  
  repeat with p = 1 to gPEprops.props.count then
    pos = (gPEprops.props[p][4][1] + gPEprops.props[p][4][2] + gPEprops.props[p][4][3] + gPEprops.props[p][4][4])/4.0
    -- pos = pos * 20.0/16.0
    if(diag(offSetMousePnt, pos) < smallestDist)then
      smallestDist = diag(offSetMousePnt, pos)
      closestProp = p
    end if
  end repeat
  
  return closestProp
end

on updateWorkLayerText()
  txt = "Work Layer:" && string(gPEprops.workLayer)
  put RETURN after txt
  put "Prop depth: " & propPlaceLayer() after txt
  member("layerText").text = txt
  if(gPEprops.pmPos.locH > gProps.count) then
    gPEprops.pmPos.locH = 1
  end if
  if(gPEprops.pmPos.locV > gProps[gPEprops.pmPos.locH].prps.count) then
    gPEprops.pmPos.locV = 1
  end if
  updateCursorText()
end

on updateCursorText()
  txt = "Prop depth: " & propPlaceLayer() & " to " & (propPlaceLayer() +  gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].depth)
  if(propSettings <> void)then
    if (propSettings.findPos(#variation) <> void) then
      put RETURN after txt
      put "Variation: " after txt
      if (propSettings.variation = 0)then
        put "Random" after txt
      else
        put propSettings.variation after txt
      end if
    end if
  end if
  
  member("Prop Depth Text").text = txt
end

on propPlaceLayer()
  return ((gPEprops.workLayer-1) * 10) + gPEprops.depth
end

on placeProp(qd)
  -- member("propsImage").image.copyPixels(mem.image, qd, mem.image.rect, {#ink:36})
  prop = [-propPlaceLayer(), gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].nm, gPEprops.pmPos, qd, [#settings:propSettings.duplicate()]]
  
  if(prop[5].settings.findpos(#color) <> void) then
    if gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tags.getPos("customColorRainBow") > 0 then
      gPEprops.color = 1
    end if
    prop[5].settings.color = gPEprops.color
  end if
  
  case (gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp)of
    "rope":
      prop[5].addProp(#points, [])
      repeat with q = 1 to ropeModel.segments.count then
        prop[5].points.add(script("ropeModel").SmoothedPos(q))
      end repeat
    "long":
      
    "variedDecal", "variedSoft", "variedStandard":
      if(prop[5].settings.variation = 0)then
        prop[5].settings.variation = random(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].vars)
      end if
  end case
  
  
  gPEprops.props.add(prop)
  gPEprops.props.sort()
  renderPropsImage()
  
  if(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "variedDecal")or(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "variedSoft")or(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].tp = "variedStandard")then
    if(propSettings.variation = 0)then
      updateVariedPreview(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV], 0)
    end if
  end if
  
  ApplyTransformationTags()
end 

on clearAllProps()
  gPEprops.props = []
  renderPropsImage()
end

on renderPropsImage()
  --gLEProps.camPos
  member("propsImage").image = image(52*16, 40*16, 16)
  member("propsImage2").image = image(52*16, 40*16, 16)
  
  camPosQuad = [gLEProps.camPos*16, gLEProps.camPos*16, gLEProps.camPos*16, gLEProps.camPos*16]
  
  displayLayer = (gPEprops.workLayer-1) * 10
  layer = 29
  
  repeat with p = 1 to gPEprops.props.count then
    prop = gPEprops.props[p]
    propData = gProps[prop[3].locH].prps[prop[3].locV]
    propLayer = -prop[1]
    mem = propPreviewMember(propData)
    blnd = 100 - IsDecal(propData)*40
    
    if(propLayer >= displayLayer) then
      
      
      if(propLayer < layer) then
        repeat with q = 1 to layer - propLayer then
          member("propsImage").image.copyPixels(member("pxl").image, rect(0,0,52*16, 40*16),rect(0,0,1,1), {#blend:10, #color:color(255, 255, 255)})
        end repeat
        layer = propLayer
        
      end if
      
      clr = color(0,0,0)
      if(propData.settings.findpos(#color) <> void) then
        if propData.settings.color > 0 then
          clr = gPEcolors[propData.settings.color]
        end if
      end if
      
      case (propData.tp) of
        "rope":
          member("propsImage").image.copyPixels(mem.image, prop[4]-camPosQuad, mem.image.rect, {#ink:36, #blend:blnd})
          q = 1
          repeat while q < prop[5].points.count then
            adaptedPos = prop[5].points[q]
            adaptedPos = adaptedPos - gLEProps.camPos*20.0
            adaptedPos = adaptedPos * 16.0/20.0
            member("propsImage").image.copyPixels(member("pxl").image, rect(adaptedPos-point(1,1), adaptedPos+point(2,2)), rect(0,0,1,1), {#color:propData.previewColor})
            q = q + propData.previewEvery
          end repeat
        "variedDecal", "variedSoft", "variedStandard":
          updateVariedPreview(propData, prop[5].settings.variation)
          member("propsImage").image.copyPixels(mem.image, prop[4]-camPosQuad, mem.image.rect, {#ink:36, #blend:blnd, #color:clr})
        otherwise:
          member("propsImage").image.copyPixels(mem.image, prop[4]-camPosQuad, mem.image.rect, {#ink:36, #blend:blnd, #color:clr})
      end case
      
      
    else
      member("propsImage2").image.copyPixels(mem.image, prop[4]-camPosQuad, mem.image.rect, {#ink:36, #blend:blnd, #color:clr})
    end if
  end repeat
  
  repeat with q = displayLayer to layer  then
    member("propsImage").image.copyPixels(member("pxl").image, rect(0,0,52*16, 40*16),rect(0,0,1,1), {#blend:10, #color:color(255, 255, 255)})
  end repeat
  
  if(["variedDecal", "variedSoft", "variedStandard"].getPos(gProps[gPEprops.pmpos.locH].prps[gPEprops.pmPos.locV].tp) > 0) then
    updateVariedPreview(gProps[gPEprops.pmpos.locH].prps[gPEprops.pmPos.locV], propSettings.variation)
  end if
end

on checkKey(key)
  rtrn = 0
  gPEProps.keys[symbol(key)] = _key.keyPressed(key) and _movie.window.sizeState <> #minimized
  if (gPEProps.keys[symbol(key)])and(gPEProps.lastKeys[symbol(key)]=0) then
    rtrn = 1
  end if
  gPEProps.lastKeys[symbol(key)] = gPEProps.keys[symbol(key)]
  return rtrn
end


on IsDecal(prop)
  if(prop.tp = "simpleDecal")or(prop.tp = "variedDecal")then
    return 1
  else
    return 0
  end if
end

on updatePropMenu(mv)
  
  gPEprops.pmPos = gPEprops.pmPos + mv
  if mv.locH <> 0 then
    if gPEprops.pmPos.locH < 1 then
      gPEprops.pmPos.locH = gProps.count
    else if gPEprops.pmPos.locH > gProps.count then
      gPEprops.pmPos.locH = 1
    end if 
    gPEprops.pmPos.locV = gPEprops.pmSavPosL[gPEprops.pmPos.locH]
  else if mv.locV <> 0 then
    if gPEprops.pmPos.locV < 1 then
      gPEprops.pmPos.locV = gProps[gPEprops.pmPos.locH].prps.count
    else if gPEprops.pmPos.locV > gProps[gPEprops.pmPos.locH].prps.count then
      gPEprops.pmPos.locV = 1
    end if
    gPEprops.pmSavPosL[gPEprops.pmPos.locH] = gPEprops.pmPos.locV
  end if
  
  if(gPEprops.pmPos.locV - 5 < peScrollPos) then
    peScrollPos = gPEprops.pmPos.locV - 5
  else if  (gPEprops.pmPos.locV - 15 > peScrollPos) then
    peScrollPos = gPEprops.pmPos.locV - 15
  end if
  
  peScrollPos = restrict(peScrollPos, 0, gProps[gPEprops.pmPos.locH].prps.count)
  
  txt = ""
  put "[" && gProps[gPEprops.pmPos.locH].nm && "]" after txt
  put RETURN after txt
  
  repeat with pr = 1+peScrollPos to 21+peScrollPos then
    if(pr > gProps[gPEprops.pmPos.locH].prps.count)then
      exit repeat
    else
      if pr = gPEprops.pmPos.locV then
        put "-" && gProps[gPEprops.pmPos.locH].prps[pr].nm && "-" && RETURN after txt
      else
        put gProps[gPEprops.pmPos.locH].prps[pr].nm && RETURN after txt
      end if
    end if
  end repeat
  
  if(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].notes.count > 0)then
    put RETURN after txt
    put RETURN after txt
    put "NOTES" after txt
    put RETURN after txt
    repeat with nt in gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].notes then
      put nt after txt
      put RETURN after txt
    end repeat
  end if
  
  member("tileMenu").text = txt
  
  -- put "propPreview TestProp" && gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].nm
  newPropSelected()
  
end

global settingCursor
on updatePropSettings(mv)
  if(editSettingsProp = 0)then
    editedPropTemplate = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]
  else
    adress = gPEprops.props[editSettingsProp][3]
    editedPropTemplate = gProps[adress.locH].prps[adress.locV]
  end if
  
  if(propSettings = void)then
    DuplicatePropSettings()
  end if
  
  settingCursor = settingCursor + mv.locV
  if mv.locV <> 0 then
    if settingCursor < 1 then
      settingCursor = propSettings.count
    else if settingCursor > propSettings.count then
      settingCursor = 1
    end if
  end if
  
  if(mv.locH <> 0)then
    case(propSettings.getPropAt(settingCursor).string)of
      "release":
        propSettings[settingCursor] = restrict( propSettings[settingCursor] + mv.locH, -1, 1)
      "renderOrder":
        propSettings[settingCursor] = propSettings[settingCursor] + mv.locH
      "seed":
        propSettings[settingCursor] = (_system.milliSeconds mod 1000)
      "renderTime":
        if(propSettings[settingCursor] = 0)then
          propSettings[settingCursor] = 1
        else
          propSettings[settingCursor] = 0
        end if
      "thickness":
        propSettings[settingCursor] = restrict( propSettings[settingCursor] + mv.locH*0.25, 1, 5)
      "variation":
        propSettings[settingCursor] = propSettings[settingCursor] + mv.locH
        mn = (1 - editedPropTemplate.random)
        if(propSettings[settingCursor] < mn)then
          propSettings[settingCursor] = settingsPropType.vars
        else if(propSettings[settingCursor] > settingsPropType.vars)then
          propSettings[settingCursor] = mn
        end if
        updateVariedPreview(settingsPropType, propSettings[settingCursor])
      "customDepth":
        propSettings[settingCursor] = propSettings[settingCursor] + mv.locH
        if(propSettings[settingCursor] < 1)then
          propSettings[settingCursor] = 30
        else if(propSettings[settingCursor] > 30)then
          propSettings[settingCursor] = 1
        end if
      "applyColor":
        propSettings[settingCursor] = 1 - propSettings[settingCursor]
      "color":
        propSettings[settingCursor] = propSettings[settingCursor] + mv.locH
        if(propSettings[settingCursor] < 0)then
          propSettings[settingCursor] = gPEcolors.count
        else if(propSettings[settingCursor] > gPEcolors.count)then
          propSettings[settingCursor] = 0
        end if
    end case
  end if
  
  txt = ""
  put editedPropTemplate.nm after txt
  put RETURN after txt
  put "SETTINGS"after txt
  put RETURN after txt
  put "(press 'N' to exit)" after txt
  put RETURN after txt
  repeat with st = 1 to propSettings.count then
    nm = propSettings.getPropAt(st).string
    put nm & " " after txt
    put RETURN after txt
    p = propSettings[st]
    t = ""
    case(nm)of
      "release":
        if(p = -1)then
          t = "left"
        else if (p = 1) then
          t = "right"
        else
          t = "none"
        end if
      "renderTime":
        if(p = 0)then
          t = "Pre Effcts"
        else
          t = "Post Effcts"
        end if
      "variation":
        if(propSettings[st] = 0)then
          t = "random"
        else
          t = propSettings[st].string
        end if
      "applyColor":
        if propSettings[st] = 0 then
          t = "NO"
        else
          t = "YES"
        end if
      "color":
        if propSettings[st] = 0 then
          t = "NONE"
        else
          t = gPEcolors[propSettings[st]][1]
        end if
      otherwise:
        t = propSettings[st].string
    end case
    
    if(st = settingCursor)then
      put ">" & t & "<   "after txt
    else
      put t after txt
    end if
    put RETURN after txt
    put RETURN after txt
  end repeat
  
  member("tileMenu").text = txt
  
  -- put "propPreview TestProp" && gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].nm
  -- newPropSelected()
  
end

on newPropSelected()
  resetTransformation()
  DuplicatePropSettings()
  prop = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]
  if(peSavedRotat <> -1)then
    gPEprops.propRotation = peSavedRotat
  end if
  
  if peSavedStretch.locH <> 0 then
    gPEprops.propStretchX = peSavedStretch.locH
  end if
  
  if peSavedStretch.locV <> 0 then
    gPEprops.propStretchY = peSavedStretch.locV
  end if
  
  if(peSavedFlip.locH <> 0)then
    gPEprops.propFlipX = peSavedFlip.locH
  end if
  
  if(peSavedFlip.locV <> 0)then
    gPEprops.propFlipY = peSavedFlip.locV
  end if
  
  propSettings.renderTime = 0
  snapToGrid = 0
  
  repeat with q = 1 to prop.tags.count then
    case prop.tags[q] of
      "postEffects":
        propSettings.renderTime = 1
      "snapToGrid":
        snapToGrid = 1
    end case
  end repeat
  
  
  ApplyTransformationTags()
  
  if(prop.tp = "rope")then
    resetRopeProp()
  end if
  
  if(["variedDecal", "variedSoft", "variedStandard"].getPos(prop.tp)>0)then
    updateVariedPreview(prop, propSettings.variation)
  end if
  
  updateWorkLayerText()
end


on ApplyTransformationTags()
  resetTransformation()
  
  peSavedRotat = -1
  peSavedFlip = point(0, 0)
  peSavedStretch = point(0, 0)
  
  prop = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]
  repeat with q = 1 to prop.tags.count then
    case prop.tags[q] of
      "randomRotat":
        peSavedRotat = gPEprops.propRotation
        gPEprops.propRotation = random(360)
      "randomFlipX":
        if(random(2)=1)then
          peSavedFlip.locH = gPEprops.propFlipX
          gPEprops.propFlipX = -gPEprops.propFlipX
        end if
      "randomFlipY":
        if(random(2)=1)then
          peSavedFlip.locV = gPEprops.propFlipY
          gPEprops.propFlipY = -gPEprops.propFlipY
        end if
    end case
  end repeat
  
  case prop.tp of
    "long":
      peSavedStretch = point(gPEprops.propStretchX, gPEprops.propStretchY)
      gPEprops.propRotation = 0
      gPEprops.propFlipX = 1
      gPEprops.propFlipY = 1
      gPEprops.propStretchX = 1
      gPEprops.propStretchY = 1
  end case
  
  
end

on resetTransformation()
  if(peSavedRotat <> -1)then
    gPEprops.propRotation  = peSavedRotat
  end if
  if(peSavedFlip.locH <> 0)then
    gPEprops.propFlipX  = peSavedFlip.locH
  end if
  if(peSavedFlip.locV <> 0)then
    gPEprops.propFlipY  = peSavedFlip.locV
  end if
    if(peSavedStretch.locH <> 0)then
    gPEprops.propStretchX  = peSavedStretch.locH
  end if
  if(peSavedStretch.locV <> 0)then
    gPEprops.propStretchX  = peSavedStretch.locV
  end if
end


on resetRopeProp()
  prop = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]
  -- ropePropPV = [#segments:[]]
  -- adaptedSegmentLength = (prop.segmentLength.float / 20.0)*16.0
  
  if(gPEprops.propRotation = 0)then
    dir = point(0, -1)
    perp = point(1, 0)
  else if (gPEprops.propRotation = 90)then
    dir = point(1, 0)
    perp = point(0, 1)
  else if (gPEprops.propRotation = 180)then
    dir = point(0, 1)
    perp = point(-1, 0)
  else if (gPEprops.propRotation = 270)then
    dir = point(-1, 0)
    perp = point(0, -1)
  else
    dir = DegToVec(gPEprops.propRotation)
    perp = giveDirFor90degrToLine(-dir, dir)
  end if
  
  mem = propPreviewMember(gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV])
  scaleFac = 16.0/20.0
  
  qd = [peMousePos, peMousePos, peMousePos, peMousePos]
  qd[1] = qd[1] + (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) - (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
  qd[2] = qd[2] + (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) + (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
  qd[3] = qd[3] - (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) + (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
  qd[4] = qd[4] - (dir*mem.rect.height * 0.5 * gPEprops.propStretchY * scaleFac * gPEprops.propFlipY) - (perp*mem.rect.width * 0.5 * gPEprops.propStretchX * scaleFac * gPEprops.propFlipX)
  
  offSetPnt = point(-16, -16) + gLEProps.camPos*16
  qd = qd + [offSetPnt, offSetPnt, offSetPnt, offSetPnt]
  
  --changing quad to 20*20 scale
  qd = qd * (20.0/16.0)
  
  pA = (qd[1] + qd[4])/2.0
  pB = (qd[2] + qd[3])/2.0
  
  collDep = ((gPEprops.workLayer-1) * 10) + gPEprops.depth + prop.collisionDepth
  if(collDep < 10)then
    cd = 1
  else if (collDep < 20)then
    cd = 2
  else
    cd = 3
  end if
  
  
  script("ropeModel").resetRopeModel(pA, pB, prop, gPEprops.propStretchY, cd, propSettings.release)
  
end

on updateVariedPreview(prop, var)
  mem = propPreviewMember(prop)
  
  
  imprtMem = member("previewImprt")
  member("previewImprt").importFileInto("Props\" &prop.nm&".png")
  imprtMem.name = "previewImprt"
  
  
  if prop.tp = "variedStandard" then
    sz = prop.sz*20.0
  else
    sz = prop.pxlSize
  end if
  
  mem.image = image(sz.locH, sz.locV, 16)
  if(var = 0)then
    repeat with v2 = 1 to prop.vars then
      mem.image.copyPixels(imprtMem.image, mem.image.rect, rect(sz.locH * (v2-1), 0, sz.locH * v2, sz.locV)+rect(0,1,0,1), {#ink:36})
    end repeat
  else
    --   put rect(prop.pxlSize.locH * (var-1), 0, prop.pxlSize.locV, prop.pxlSize.locH * var)
    mem.image.copyPixels(imprtMem.image, mem.image.rect, rect(sz.locH * (var-1), 0, sz.locH * var, sz.locV)+rect(0,1,0,1))
  end if
end


on propPreviewMember(prop)
  global loadedPropPreviews
  if(loadedPropPreviews = void) then
    loadedPropPreviews = []
  end if
  
  repeat with q = 1 to loadedPropPreviews.count then
    if loadedPropPreviews[q] = prop.nm then
      return member("propPreview" && prop.nm)
    end if
  end repeat
  
  tileAsProp = 0
  repeat with q = 1 to prop.tags.count then
    if prop.tags[q] = "Tile" then
      tileAsProp = 1
      exit repeat
    end if
  end repeat
  
  sav2 = member("previewImprt")
  if(tileAsProp)then
    member("previewImprt").importFileInto("Graphics\" &prop.nm&".png")
  else
    member("previewImprt").importFileInto("Props\" &prop.nm&".png")
  end if
  sav2.name = "previewImprt"
  
  newMem = new(#bitmap, castLib "customMems")
  
  case prop.tp of
    "standard":
      newMem.image = image(prop.sz.locH*20, prop.sz.locV*20, 16)
      
      repeat with c = 1 to prop.repeatL.count then
        c2 = prop.repeatL.count + 1 - c
        getRect = rect(0, (c2-1)*prop.sz.locV*20, prop.sz.locH*20, c2*prop.sz.locV*20)+rect(0,1,0,1)
        newMem.image.copyPixels(member("pxl").image, newMem.image.rect, rect(0,0,1,1), {#color:color(255, 255, 255), #blend:80.0/prop.repeatL.count})
        newMem.image.copyPixels(member("previewImprt").image, newMem.image.rect, getRect, {#ink:36})
      end repeat
      
    "simpleDecal", "soft", "softEffect", "antimatter":
      newMem.image = image(member("previewImprt").image.width, member("previewImprt").image.height, 16)
      newMem.image.copyPixels(member("previewImprt").image, newMem.image.rect, member("previewImprt").image.rect)
      
    "variedDecal", "variedSoft":
      newMem.image = image(prop.pxlSize.locH, prop.pxlSize.locV, 16)
      newMem.image.copyPixels(member("previewImprt").image, newMem.image.rect, rect(0,0,prop.pxlSize.locH, prop.pxlSize.locV))
      
    "variedStandard":
      newMem.image = image(prop.sz.locH*20*prop.vars, prop.sz.locV*20, 16)
      repeat with c = 1 to prop.repeatL.count then
        c2 = prop.repeatL.count + 1 - c
        getRect = rect(0, (c2-1)*prop.sz.locV*20, prop.sz.locH*20*prop.vars, c2*prop.sz.locV*20)+rect(0,1,0,1)
        newMem.image.copyPixels(member("pxl").image, newMem.image.rect, rect(0,0,1,1), {#color:color(255, 255, 255), #blend:80.0/prop.repeatL.count})
        newMem.image.copyPixels(member("previewImprt").image, newMem.image.rect, getRect, {#ink:36})
      end repeat
      
    "rope", "long":
      newMem.image = image(member("previewImprt").image.width, member("previewImprt").image.height, 16)
      newMem.image.copyPixels(member("previewImprt").image, newMem.image.rect, member("previewImprt").image.rect)
  end case
  
  newMem.name = "propPreview" && prop.nm
  
  loadedPropPreviews.add(prop.nm)
  
  return newMem
end







on DuplicatePropSettings()
  doIt = (settingsPropType = void)
  
  if(doIt = 0)then
   -- put settingsPropType.nm && gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].nm
    if (settingsPropType.nm <> gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].nm) then
      doIt = 1
    end if
  end if
  if (doIt) then
    propSettings = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV].settings.duplicate()
    propSettings.seed = Random(1000)
    settingsPropType = gProps[gPEprops.pmPos.locH].prps[gPEprops.pmPos.locV]
  end if
end 









