global vertRepeater, r, gEEprops, solidMtrx, gLEprops, colr, gdLayer, gLOProps, gLevel, gEffectProps, gViewRender, keepLooping, gRenderCameraTilePos, effectSeed
global effectIn3D, gAnyDecals

on exitFrame me
  if gViewRender then
    if _key.keyPressed(48) and _movie.window.sizeState <> #minimized then
      _movie.go(9)
    end if
    me.newFrame()
    if keepLooping then
      go the frame
    end if
  else
    repeat while keepLooping
      me.newFrame()
    end repeat
  end if
end


on newFrame me
  
  vertRepeater = vertRepeater + 1
  
  
  if (gEEprops.effects.count = 0)then
    keepLooping = 0
    exit
  else if (r=0)then
    vertRepeater = 1
    r = 1
    me.initEffect()
  end if
  
  if ((vertRepeater > 60)and(gEEprops.effects[r].crossScreen = 0))or((vertRepeater > gLOprops.size.locV)and(gEEprops.effects[r].crossScreen = 1)) then
    me.exitEffect()
    r = r + 1
    
    if r > gEEprops.effects.count then
      keepLooping = 0
      exit
    else
      me.initEffect()
      vertRepeater = 1
    end if
  end if
  
  
  
  
  if (gEEprops.effects[r].crossScreen = 0) then
    sprite(59).locV = vertRepeater*20
    repeat with q = 1 to 100 then
      q2 = q + gRenderCameraTilePos.locH
      c2 = vertRepeater + gRenderCameraTilePos.locV
      if(q2 > 0)and(q2 <= gLOprops.size.locH)and(c2 > 0)and(c2 <= gLOprops.size.locV)then
        me.effectOnTile(q, vertRepeater, q2, c2)
      end if
    end repeat
  else
    sprite(59).locV = (vertRepeater-gRenderCameraTilePos.locV)*20
    repeat with q2 = 1 to gLOprops.size.locH then
      me.effectOnTile(q2-gRenderCameraTilePos.locH, vertRepeater-gRenderCameraTilePos.locV, q2, vertRepeater)
    end repeat
  end if
  
  
end


on effectOnTile me, q, c, q2, c2
  if gEEprops.effects[r].mtrx[q2][c2] > 0 then
    
    savSeed = the randomSeed
    the randomSeed = seedForTile(point(q2, c2), effectSeed)
    
    case gEEprops.effects[r].nm of
      "Slime", "rust", "barnacles", "erode", "melt", "Roughen", "SlimeX3", "Destructive Melt", "Super Melt", "Super Erode", "DecalsOnlySlime":
        me.applyStandardErosion(q,c,0, gEEprops.effects[r].nm)
      "Root Grass", "Cacti", "Rubble", "Rain Moss", "Seed Pods", "Grass", "Horse Tails", "Circuit Plants", "Feather Plants":
        me.applyStandardPlant(q,c,0, gEEprops.effects[r].nm)
      "Growers":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(2)=1) then
          me.applyhugeflower(q,c,0)
        end if
      "Arm Growers":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(2)=1) then
          me.ApplyArmGrower(q,c,0)
        end if
      "Fungi Flowers":
        if gEEprops.effects[r].mtrx[q2][c2] > 0 then
          me.applyFungiFlower(q,c)
        end if
      "Lighthouse Flowers":
        if gEEprops.effects[r].mtrx[q2][c2] > 0 then
          me.applyLHFlower(q,c)
        end if
      "Fern", "Giant Mushroom":
        if gEEprops.effects[r].mtrx[q2][c2] > 0 then
          me.applyBigPlant(q,c)
        end if
      "sprawlbush", "featherFern", "Fungus Tree":
        if gEEprops.effects[r].mtrx[q2][c2] > 0 then
          me.apply3Dsprawler(q,c, gEEprops.effects[r].nm)
        end if
      "hang roots":
        repeat with r2 = 1 to 3 then
          if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) then
            me.applyHangRoots(q,c,0)
          end if
        end repeat
      "wires":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(2)=1) then
          me.applyWire(q,c,0)
        end if
      "chains":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(2)=1) then
          me.applyChain(q,c,0)
        end if
      "blackGoo":
        me.applyBlackGoo(q,c,0)
      "DarkSlime":
        me.applyDarkSlime(q,c, gEEprops.effects[r].nm)
      "Restore As Scaffolding", "Restore as Pipes":
        me.applyRestoreEffect(q,c, q2, c2, gEEprops.effects[r].nm)
      "Rollers":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(5)=1) then
          me.ApplyRoller(q,c,0)
        end if
      "Thorn Growers":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyThornGrower(q,c,0)
        end if
      "Garbage Spirals":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(6)=1) then
          me.ApplyGarbageSpiral(q,c,0)
        end if
      "Thick Roots":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) then
          me.applyThickRoots(q,c,0)
        end if
      "Shadow Plants":
        if (random(100)<gEEprops.effects[r].mtrx[q2][c2]) and (random(3)=1) then
          me.applyShadowPlants(q,c,0)
        end if
      "DaddyCorruption":
        me.applyDaddyCorruption(q,c,gEEprops.effects[r].mtrx[q2][c2])
      "Slag":
        me.applySlag(q,c,gEEprops.effects[r].mtrx[q2][c2])
    end case
    
    the randomSeed = savSeed
    
  end if
end


on initEffect me
  effectSeed = 0
  repeat with a = 1 to gEEprops.effects[r].Options.count then
    if(gEEprops.effects[r].Options[a][1] = "Seed")then
      effectSeed = gEEprops.effects[r].Options[a][3]
      exit repeat
    end if
  end repeat
  
  effectIn3D = false
  repeat with op in gEEprops.effects[r].options then
    case op[1] of 
      "Color":
        colr = [color(255, 0, 255), color(0, 255, 255), color(0, 255, 0)][["Color1", "Color2", "Dead"].getPos(op[3])]
        gdLayer = ["A", "B", "C"][["Color1", "Color2", "Dead"].getPos(op[3])]
      "Seed":
        the randomSeed = op[3]
      "3D":
        effectIn3D = (op[3] = "On")
    end case
  end repeat
  
  case gEEprops.effects[r].nm of
    "blackGoo":
      cols = 100
      rows = 60
      
      member("blackOutImg1").image = image(cols*20, rows*20, 32)
      member("blackOutImg1").image.copyPixels(member("pxl").image, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      member("blackOutImg2").image = image(cols*20, rows*20, 32)
      member("blackOutImg2").image.copyPixels(member("pxl").image, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      sprite(57).visibility = 1
      sprite(58).visibility = 1
      
      global gRenderCameraTilePos, gRenderCameraPixelPos
      
      repeat with q = 1 to 100 then
        repeat with c = 1 to 60 then
          q2 = q + gRenderCameraTilePos.locH
          c2 = c + gRenderCameraTilePos.locV
          if(q2 < 1)or(q2 > gLOprops.size.locH)or(c2 < 1)or(c2 > gLOprops.size.locV)then
            member("blackOutImg1").image.copyPixels(member("pxl").image, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
            member("blackOutImg2").image.copyPixels(member("pxl").image, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
          end if
        end repeat
      end repeat
      
      
      rct = member("blob").image.rect
      repeat with q2 = 1 to cols then
        repeat with c2 = 1 to rows then
          if(q2+gRenderCameraTilePos.locH > 0)and(q2+gRenderCameraTilePos.locH <= gLOprops.size.locH)and(c2+gRenderCameraTilePos.locV > 0)and(c2+gRenderCameraTilePos.locV <= gLOprops.size.locV)then
            tile = point(q2,c2)+gRenderCameraTilePos
            
            if (gEEprops.effects[r].mtrx[tile.locH][tile.locV] = 0) then
              sPnt = giveMiddleOfTile(point(q2,c2))+point(-10,-10)--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              
              repeat with d = 1 to 10 then
                repeat with e = 1 to 10 then
                  ps = point(sPnt.locH + d*2, sPnt.locV + e*2)
                  -- if member("layer0").image.getPixel(ps) = color(255, 255, 255) then
                  member("blackOutImg1").image.copyPixels(member("blob").image, rect(ps.locH-6-random(random(11)),ps.locV-6-random(random(11)),ps.locH+6+random(random(11)),ps.locV+6+random(random(11))), rct, {#color:0, #ink:36})
                  member("blackOutImg2").image.copyPixels(member("blob").image, rect(ps.locH-7-random(random(14)),ps.locV-7-random(random(14)),ps.locH+7+random(random(14)),ps.locV+7+random(random(14))), rct, {#color:0, #ink:36})
                  -- end if 
                end repeat
              end repeat
            else if ((gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(5) > 0)or(gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(4) > 0))and(gLEProps.matrix[tile.locH][tile.locV][2][1]=1) then
              ps = giveMiddleOfTile(point(q2,c2))--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              member("blackOutImg1").image.copyPixels(member("blob").image, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              member("blackOutImg2").image.copyPixels(member("blob").image, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
              member("blackOutImg1").image.copyPixels(member("blob").image, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              member("blackOutImg2").image.copyPixels(member("blob").image, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
            end if
          end if
        end repeat
      end repeat
      
    "fungi flowers":
      
      l = [2,3,4,5]
      l2 = []
      repeat with a = 1 to 4 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "lighthouse flowers":
      
      l = [1,2,3,4,5,6,7,8]
      l2 = []
      repeat with a = 1 to 8 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Fern", "Giant Mushroom":
      l = [1,2,3,4,5,6,7]
      l2 = []
      repeat with a = 1 to 7 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "DaddyCorruption":
      global daddyCorruptionHoles
      daddyCorruptionHoles = []
      
    "Slag":
      global slagHoles
      slagHoles = []
      
  end case
  
  
  txt = ""
  put "<APPLYING EFFECTS>                                                            Press TAB to abort" after txt
  put RETURN after txt
  
  repeat with ef = 1 to gEEprops.effects.count then
    
    if ef = r then
      put string(ef)&". ->"&gEEprops.effects[ef].nm after txt
    else
      put string(ef)&". "&gEEprops.effects[ef].nm after txt
    end if
    put RETURN after txt
  end repeat
  
  member("effectsL").text = txt
end

on exitEffect me
  case gEEprops.effects[r].nm of
    "blackGoo":
      
      
      member("layer0").image.copyPixels(member("blackOutImg1").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(0, 255, 0)})
      member("layer0").image.copyPixels(member("blackOutImg2").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(255, 0, 0)})
      
      
      member("blackOutImg1").image = image(1, 1, 1)
      -- member("blackOutImg2").image = image(1, 1, 1)
      sprite(58).visibility = 0
      sprite(57).visibility = 0
      
    "daddyCorruption":
      global daddyCorruptionHoles
      repeat with i = 1 to daddyCorruptionHoles.count then
        qd = rotateToQuad(rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2],-daddyCorruptionHoles[i][2],daddyCorruptionHoles[i][2],daddyCorruptionHoles[i][2]), daddyCorruptionHoles[i][3])
        repeat with d = 0 to 1 then
          member("layer"&string(daddyCorruptionHoles[i][4]+d)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 255, 255), #ink:36})
        end repeat
        if(random(2)=1)and(random(100)>daddyCorruptionHoles[i][5])then
          member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 0, 0), #ink:36})
        else
          member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(0, 255, 255), #ink:36})
          copyPixelsToEffectColor("B", daddyCorruptionHoles[i][4]+2, rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2]*1.5,-daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5), "softBrush1", member("softBrush1").rect, 0.5, lerp(random(50)*0.01, 1.0, random(daddyCorruptionHoles[i][5])*0.01))
        end if
      end repeat
      daddyCorruptionHoles = []
      
    "Slag":
      global slagHoles
      repeat with i = 1 to slagHoles.count then
        qd = rotateToQuad(rect(slagHoles[i][1], slagHoles[i][1])+rect(-slagHoles[i][2],-slagHoles[i][2],slagHoles[i][2],slagHoles[i][2]), slagHoles[i][3])
        repeat with d = 0 to 1 then
          member("layer"&string(slagHoles[i][4]+d)).image.copyPixels(member("SlagBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 255, 255), #ink:36})
        end repeat
        if(random(2)=1)and(random(100)>slagHoles[i][5])then
          member("layer"&string(slagHoles[i][4]+2)).image.copyPixels(member("SlagBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 0, 0), #ink:36})
        else
          member("layer"&string(slagHoles[i][4]+2)).image.copyPixels(member("SlagBulb").image, qd, rect(60, 1, 134, 74), {#color:color(0, 255, 255), #ink:36})
          copyPixelsToEffectColor("B", slagHoles[i][4]+2, rect(slagHoles[i][1], slagHoles[i][1])+rect(-slagHoles[i][2]*1.5,-slagHoles[i][2]*1.5,slagHoles[i][2]*1.5,slagHoles[i][2]*1.5), "softBrush1", member("softBrush1").rect, 0.5, lerp(random(50)*0.01, 1.0, random(slagHoles[i][5])*0.01))
        end if
      end repeat
      slagHoles = []
      
  end case
end




on applyStandardErosion me, q, c, eftc, tp
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  fc = gEEprops.effects[r].affectOpenAreas + (1.0-gEEprops.effects[r].affectOpenAreas)* (     solidAfaMv(point(q2,c2), 3)   )
  
  
  repeat with d = 1 to 30 then
    lr = 30-d
    if (lr = 9)or(lr=19) then
      sld = (solidMtrx[q2][c2][ 1+(d>9)+(d>19) ])
      fc = gEEprops.effects[r].affectOpenAreas + (1.0-gEEprops.effects[r].affectOpenAreas)* ( solidAfaMv(point(q2,c2), 1+(d>9)+(d>19)) )
    end if
    deepEffect = 0
    
    if (lr = 0)or(lr=10)or(lr=20)or(sld=0)then
      deepEffect = 1
    end if
    
    repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2]*(0.2 + (0.8*deepEffect))*0.01*gEEprops.effects[r].repeats*fc then
      if deepEffect then
        pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
      else
        if random(2)=1 then
          pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
        else 
          pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
        end if
      end if
      
      case tp of
        "rust",  "barnacles":
          pnt = pnt+degToVec(random(360))*4
          cl =  member("layer"&string(lr)).image.getPixel(pnt)
        "erode", "Super Erode":
          pnt = pnt+degToVec(random(360))*2
          if (member("layer"&string(lr)).image.getPixel(pnt) = color(255, 255, 255)) or ((random(108)=1) and (tp <> "Super Erode")) then
            cl = "GOTHROUGH"
          else
            cl = color(255, 255, 255)
          end if
        "Destructive Melt":
          cl =  member("layer"&string(lr)).image.getPixel(pnt)
          if(cl = color(255, 255, 255))then
            cl = "WHITE"
          end if
        otherwise:
          cl =  member("layer"&string(lr)).image.getPixel(pnt)
      end case
      
      
      if cl <> color(255, 255, 255) then
        case tp of
          "slime", "slimeX3":
            if (cl <> color(255, 255, 255))then
              ofst = random(2)-1
              lgt = 3 + random(random(random(6)))
              if  effectIn3D then
                nwLr = get3DLr(lr)
              else
                nwLr = restrict(lr -1 + random(2), 0, 29)
              end if
              member("layer"&string(nwLr)).image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), member("pxl").image.rect, {#color:cl})
              if(gAnyDecals)then
                dcCol = member("layer"&string(nwLr)&"dc").image.getPixel(pnt)
                member("layer"&string(nwLr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), member("pxl").image.rect, {#color:dcCol})
              end if
              if random(2)=1 then
                member("layer"&string(nwLr)).image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), member("pxl").image.rect, {#color:cl})
                if(gAnyDecals)then
                  member("layer"&string(nwLr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), member("pxl").image.rect, {#color:dcCol})
                end if
              else
                member("layer"&string(nwLr)).image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), member("pxl").image.rect, {#color:cl})
                if(gAnyDecals)then
                  member("layer"&string(nwLr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), member("pxl").image.rect, {#color:dcCol})
                end if
              end if
            end if
            
          "DecalsOnlySlime":
            ofst = random(2)-1
            lgt = 3 + random(random(random(6)))
            
            if(gAnyDecals)then
              dcCol = member("layer"&string(lr)&"dc").image.getPixel(pnt)
              member("layer"&string(lr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), member("pxl").image.rect, {#color:dcCol})
              
              if random(2)=1 then
                member("layer"&string(lr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), member("pxl").image.rect, {#color:dcCol})
              else
                member("layer"&string(lr)&"dc").image.copyPixels(member("pxl").image, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), member("pxl").image.rect, {#color:dcCol})
              end if
            end if
            
          "rust":
            ofst = random(2)-1
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              nwLr = lr
            end if
            member("layer"&string(nwLr)).image.copyPixels(member("rustDot").image, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), member("rustDot").image.rect, {#color:cl, #ink:36})
            
          "barnacles":
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              nwLr = restrict(lr -1 + random(2), 0, 29)
            end if
            if random(2)-1 then
              member("layer"&string(nwLr)).image.copyPixels(member("barnacle1").image, rect(pnt, pnt)+rect(-3,-3,4,4), member("barnacle1").image.rect, {#color:cl, #ink:36})
              member("layer"&string(nwLr)).image.copyPixels(member("barnacle2").image, rect(pnt, pnt)+rect(-2,-2,3,3), member("barnacle2").image.rect, {#color:color(255,0,0), #ink:36})
            else
              ofst = random(2)-1
              member("layer"&string(nwLr)).image.copyPixels(member("rustDot").image, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), member("rustDot").image.rect, {#color:[color(255,0,0),cl][random(2)], #ink:36})
            end if
          "erode":
            if(random(6)>1)then
              nwLr = lr
            else
              nwLr = restrict(lr + 1, 0, 29)
            end if
            
            repeat with a = 1 to 6 then
              pnt = pnt + point(-3+random(5), -3+random(5))
              ofst = random(2)-1
              member("layer"&string(nwLr)).image.copyPixels(member("rustDot").image, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), member("rustDot").image.rect, {#color:color(255, 255, 255), #ink:36})
            end repeat
          "Super Erode":
            if(random(40 + 4 * lr * (lr > 19))>1)then
              nwLr = lr
            else
              nwLr = restrict(lr -2 + random(3), 0, 29)
            end if
            
            repeat with a = 1 to 6 then
              pnt = pnt + point(-4+random(7), -4+random(7))
              member("layer"&string(nwLr)).image.copyPixels(member("SuperErodeMask").image, rect(pnt, pnt)+rect(-4, -4, 4, 4), member("SuperErodeMask").image.rect, {#color:color(255, 255, 255), #ink:36})
            end repeat
          "melt":
            cp = image(4,4,32)
            rct = rect(pnt,pnt)+rect(-2,-2,2,2)
            cp.copyPixels(member("layer"&string(lr)).image, rect(0,0,4,4), rct)
            cp.setPixel(point(0,0), color(255,255,255))
            cp.setPixel(point(3,0), color(255,255,255))
            cp.setPixel(point(0,3), color(255,255,255))
            cp.setPixel(point(3,3), color(255,255,255))
            member("layer"&string(lr)).image.copyPixels(cp, rct+rect(0,1,0,1), rect(0,0,4,4), {#ink:36})
            member("tst").image = cp
            
          "roughen":
            if(cl = color(0, 255, 0))then
              var = random(20)
              --member("layer"&string(lr)).image.copyPixels(member("roughenTexture").image, rect(pnt, pnt)+rect(-3, -3, 4, 4), rect((var-1)*7, 0, var*7, 7), {#ink:36})
              repeat with lch = 0 to 6 then
                repeat with lcv = 0 to 6 then
                  if(member("layer"&string(lr)).image.getPixel(pnt.locH-3+lch, pnt.locV-3+lcv) = color(0, 255, 0))then
                    gtCl = member("roughenTexture").image.getPixel(lch+(var-1)*7, lcv)
                    if gtCl <> color(255, 255, 255) then
                      member("layer"&string(lr)).image.setPixel(pnt.locH-3+lch, pnt.locV-3+lcv, gtCl)
                    end if
                  end if
                end repeat
              end repeat
            end if
            
          "Super Melt":
            maskImg = member("destructiveMeltMask").image
            cpImg = image(maskImg.width,maskImg.height,32)
            rct = rect(pnt-point(maskImg.width,maskImg.height)/2.0, pnt+point(maskImg.width,maskImg.height)/2.0)
            cpImg.copyPixels(member("layer"&string(lr)).image, cpImg.rect, rct)
            cpImg.copyPixels(maskImg, cpImg.rect, maskImg.rect, {#ink:36, #color:color(255, 255, 255)})
            mvDown = random(7)*(gEEprops.effects[r].mtrx[q2][c2]/100.0)
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              nwLr = restrict(lr -1 + random(2), 0, 29)
            end if
            if((lr > 6)and(nwLr <= 6))or((nwLr > 6)and(lr <= 6))then
              nwLr = lr
            end if
            member("layer"&string(nwLr)).image.copyPixels(cpImg, rct + rect(0, 0, 0, mvDown), cpImg.rect, {#ink:36})
            
          "Destructive Melt":
            maskImg = member("destructiveMeltMask").image
            cpImg = image(maskImg.width,maskImg.height,32)
            rct = rect(pnt-point(maskImg.width,maskImg.height)/2.0, pnt+point(maskImg.width,maskImg.height)/2.0)
            
            cpImg.copyPixels(member("layer"&string(lr)).image, cpImg.rect, rct)
            pnt = point(-2+random(3), -2+random(3))
            rct = rct + rect(pnt, pnt)
            -- cpImg.copyPixels(maskImg, cpImg.rect, maskImg.rect, {#ink:36, #color:color(255, 255, 255)})
            mvDown = random(7)*(gEEprops.effects[r].mtrx[q2][c2]/100.0)
            if effectIn3D then
              nwLr = get3DLr(lr)
            else
              nwLr = restrict(lr -1 + random(2), 0, 29)
            end if
            if((lr > 6)and(nwLr <= 6))or((nwLr > 6)and(lr <= 6))then
              nwLr = lr
            end if
            member("layer"&string(lr)).image.copyPixels(cpImg, rct + rect(0, 0, 0, mvDown), cpImg.rect, {#mask:member("destructiveMeltDestroy").image.createMask()})
            -- if(cl = "WHITE")then
            member("layer"&string(nwLr)).image.copyPixels(cpImg, rct + rect(0, 0, 0, mvDown*0.5), cpImg.rect, {#mask:member("destructiveMeltDestroy").image.createMask(), #ink:36})
            -- end if
            if(cl = "WHITE")then
              member("layer"&string(lr)).image.copyPixels(member("destructiveMeltDestroy").image,  rect(rct.left, rct.top, rct.right, rct.bottom+mvDown), member("destructiveMeltDestroy").image.rect, {#ink:36, #color: color(255, 255, 255)})
            end if
        end case
      end if
    end repeat
  end repeat
  
  
  --reDrawPoles(point(q2, c2), layer, q, c, drawLayer)
  
end

on get3DLr(lr)
  nwLr = restrict(lr - 2 + random(3), 0, 29)
  if(lr = 6)and(nwLr=5)then
    nwLr = 6
  else if(lr = 5)and(nwLr=6)then
    nwLr = 5
  end if
  return nwLr
end 

on applyDarkSlime me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  --gEEprops.effects[r].mtrx[q][c]
  cls = [color(255, 0,0), color(0,255, 0), color(0,0,255)]
  
  fc = 0 + (1.0-0)* (     solidAfaMv(point(q2,c2), 1)   )
  --lr = 
  repeat with d = 0 to 29 then
    lr = d--29-d+1
    if (lr=0)or(lr = 10)or(lr=20) then
      sld = (solidMtrx[q2][c2][ 1+(lr>9)+(lr>19) ])
      fc = 0 + (1.0-0)* ( solidAfaMv(point(q2,c2)+gRenderCameraTilePos, 1+(lr>9)+(lr>19)) )
    end if
    deepEffect = 0
    
    if (lr = 0)or(lr=10)or(lr=20)or(sld=0)then
      deepEffect = 1
    end if
    
    repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2]*(0.2 + (0.8*deepEffect))*0.01*80*fc then
      if deepEffect then
        pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
      else
        if random(2)=1 then
          pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
        else 
          pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
        end if
      end if
      if member("layer"&string(lr)).image.getPixel(pnt) <> color(255,255,255) then
        lgt = random(40)
        if member("layer"&string(lr)).image.getPixel(pnt+point(0,lgt)) <> color(255,255,255) then
          clr = cls[random(3)]
          member("layer"&string(lr)).image.copyPixels(member("pxl").image, rect(pnt, pnt+point(1, lgt)), rect(0,0,1,1), {#color:clr})
          if random(2)=1 then
            member("layer"&string(lr)).image.copyPixels(member("pxl").image, rect(pnt, pnt+point(1, lgt))+rect(-1, 1, -1, -1), rect(0,0,1,1), {#color:clr})
          else
            member("layer"&string(lr)).image.copyPixels(member("pxl").image, rect(pnt, pnt+point(1, lgt))+rect(1, 1, 1, -1), rect(0,0,1,1), {#color:clr})
          end if
        end if
      end if
    end repeat
  end repeat
  
  
  --  repeat with cnt = 1 to gEEprops.effects[r].mtrx[q][c] then
  --    lr = random(30)-1
  --    pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
  --    if member("layer"&string(lr)).image.getPixel(pnt) <> color(255,255,255) then
  --      lgt = random(40)
  --      if member("layer"&string(lr)).image.getPixel(pnt) <> color(255,255,255) then
  --        member("layer"&string(lr)).image.copyPixels(member("pxl").image, rect(pnt, pnt+point(1, lgt)), rect(0,0,1,1), {#color:cls[random(3)]})
  --      end if
  --    end if
  --  end repeat
end 


on giveAnEffectPos me, q, c, d, sld
  pnt = point(0,0)
  l = 1+(d>9)+(d>19)
  if (d = 0)or(d=9)or(d=19)or(sld)then--solidMtrx[q][c][l]=0) then
    pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
  else
    if random(2)=1 then
      pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
    else 
      pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
    end if
  end if
  
  return pnt
end



on applyStandardPlant me, q, c, eftc, tp
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  amount = 17
  case tp of
    "Root Grass":
      amount = 12
    "Grass":
      amount = 10
    "Seed Pods":
      amount = random(5)
    "Cacti":
      amount = 3
    "Rain Moss":
      amount = 9
    "rubble":
      amount = 11
    "Horse Tails":
      amount = 1 + random(3)
    "Circuit Plants":
      amount = 2
    "Feather Plants":
      amount = 4
  end case
  
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      lsL = [1,2,3]
    "1":
      lsL = [1]
    "2":
      lsL = [2]
    "3":
      lsL = [3]
    "1:st and 2:nd":
      lsL = [1,2]
    "2:nd and 3:rd":
      lsL = [2,3]
  end case
  
  -- gradImg = image(10,30,16)
  -- mskImg = image(10,30,16)
  
  repeat with layer in lsL then
    if (solidMtrx[q2][c2][layer]<>1)and(solidAfaMv(point(q2,c2+1), layer)=1) then
      -- mdPnt = giveMiddleOfTile(point(q,c))
      
      repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2]*0.01*amount then
        pnt = me.giveGroundPos(q,c,layer)
        lr = random(9) + (layer-1)*10
        
        
        case tp of
          "Grass":
            freeSides = 0
            if (solidAfaMv(point(q2-1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=3) then
              --freeSides = freeSides + 1
              amount = amount/2
            end if
            if (solidAfaMv(point(q2+1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=2) then
              -- freeSides = freeSides + 1
              amount = amount/2
            end if
            
            rct = rect(pnt, pnt) + rect(-10,-20,10, 10)
            
            rnd = random(20)
            
            flp = random(2)-1
            if flp then
              rct = vertFlipRect(rct)
            end if
            
            gtRect = rect((rnd-1)*20, 0, rnd*20, 30)+rect(1,0,1,0)
            member("layer"&string(lr)).image.copyPixels(member("GrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              -- pnt = depthPnt(pnt, lr-5)
              rct = rect(pnt, pnt) + rect(-10,-20,10, 10)
              if flp then
                rct = vertFlipRect(rct)
              end if
              
              copyPixelsToEffectColor(gdLayer, lr, rct, "GrassGrad", gtRect, 0.5)
              --              member("gradImgMask").image.copyPixels(member("GrassGrad").image, rect(0,0,20,30), gtRect)
              --              member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("gradImg").image, rct, rect(0,0,20,30), {#maskImage: member("gradImgMask").image.createMask()})
            end if   
            
          "Root Grass":
            freeSides = 0
            if (solidAfaMv(point(q2-1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=3) then
              freeSides = freeSides + 1
            end if
            if (solidAfaMv(point(q2+1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=2) then
              freeSides = freeSides + 1
            end if
            
            rct = rect(pnt, pnt) + rect(-5,-17,5, 3)
            if (freeSides > 0) or (amount<0.5) then
              rnd = 10+random(5)
            else
              rnd = random(10)
            end if
            
            flp = random(2)-1
            if flp then
              rct = vertFlipRect(rct)
            end if
            
            gtRect = rect((rnd-1)*10, 0, rnd*10, 30)+rect(1,0,1,0)
            member("layer"&string(lr)).image.copyPixels(member("RootGrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              -- pnt = depthPnt(pnt, lr-5)
              rct = rect(pnt, pnt) + rect(-5,-17,5, 3)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "RootGrassGrad", gtRect, 0.5)
              --member("gradImgMask").image.copyPixels(member("RootGrassGrad").image, rect(0,0,10,30), gtRect)
              --member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("gradImg").image, rct, rect(0,0,10,30), {#maskImage: member("gradImgMask").image.createMask()})
            end if   
            
          "Seed Pods":
            rnd = random(7)
            rct = rect(pnt, pnt) + rect(-10,-77,10, 3)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 80)+rect(1,0,1,0)
            if flp then
              rct = vertFlipRect(rct)
            end if
            member("layer"&string(lr)).image.copyPixels(member("SeedPodsGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              -- pnt = depthPnt(pnt, lr-5)
              rct = rect(pnt, pnt) + rect(-10,-77,10, 3)
              if flp then
                rct = vertFlipRect(rct)
              end if
              -- member("gradImgMask").image.copyPixels(member("SeedPodsGrad").image, rect(0,0,20,80), gtRect)
              -- member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("gradImg").image, rct, rect(0,0,20,80), {#maskImage: member("gradImgMask").image.createMask()})
              copyPixelsToEffectColor(gdLayer, lr, rct, "SeedPodsGrad", gtRect, 0.5)
            end if 
            
          "Circuit Plants":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              rnd = random(restrict((20*(gEEprops.effects[r].mtrx[q2][c2]-11+random(21))*0.01).integer, 1, 16))
              sz = 0.15+0.85*power(gEEprops.effects[r].mtrx[q2][c2]*0.01, 0.85)
              rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
              flp = random(2)-1
              gtRect = rect((rnd-1)*40, 0, rnd*40, 100)+rect(1,0,1,0)
              if flp then
                rct = vertFlipRect(rct)
              end if
              member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
              if(sz < 0.75)then
                member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct+rect(1,0,1,0), gtRect, {#color:colr, #ink:36})
                member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct+rect(0,1,0,1), gtRect, {#color:colr, #ink:36})
              end if
              if colr <> color(0,255,0) then
                rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
                if flp then
                  rct = vertFlipRect(rct)
                end if
                copyPixelsToEffectColor(gdLayer, lr, rct, "CircuitPlantGrad", gtRect, 0.5)
              end if 
            end if
            
          "Feather Plants":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              leanDir = 0
              if(q2 > 1)then
                if(afaMvLvlEdit(point(q2-1,c2), layer)=0)and(afaMvLvlEdit(point(q2-1,c2+1), layer)=1)then
                  leanDir = leanDir + gEEprops.effects[r].mtrx[q2-1][c2]
                else if (afaMvLvlEdit(point(q2-1,c2), layer)=1) then
                  leanDir = leanDir - 90
                end if
              end if
              if(q2 < gLOprops.size.locH-1)then
                if(afaMvLvlEdit(point(q2+1,c2), layer)=0)and(afaMvLvlEdit(point(q2+1,c2+1), layer)=1)then
                  leanDir = leanDir - gEEprops.effects[r].mtrx[q2+1][c2]
                else if (afaMvLvlEdit(point(q2+1,c2), layer)=1) then
                  leanDir = leanDir + 90
                end if
              end if
              
              rnd = random(restrict((20*(gEEprops.effects[r].mtrx[q2][c2]-11+random(21))*0.01).integer, 1, 16))
              sz = 1--0.2+0.8*power(gEEprops.effects[r].mtrx[q2][c2]*0.01, 0.85)
              rct = rect(pnt, pnt) + rect(-20*sz,-90*sz,20*sz, 100*sz)
              gtRect = rect((rnd-1)*40, 0, rnd*40, 190)+rect(1,0,1,0)
              
              rct = rotateToQuad(rct, (65.0*((leanDir - 11 + random(21))/100.0))+0.1)
              
              checkForSolid = (rct[1]+rct[2]+rct[3]+rct[4])/4.0
              if(   member("layer"&string(lr)).image.getPixel(checkForSolid.locH, checkForSolid.locV) <> color(255, 255, 255))then
                
                if(leanDir - 11 + random(21) > 0) then
                  rct = flipQuadH(rct)
                end if
                
                member("layer"&string(lr)).image.copyPixels(member("FeatherPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
                if colr <> color(0,255,0) then
                  copyPixelsToEffectColor(gdLayer, lr, rct, "FeatherPlantGrad", gtRect, 0.5)
                end if 
              end if
            end if
            
          "Horse Tails":
            rnd = restrict(random(3+(20*gEEprops.effects[r].mtrx[q2][c2]*0.01).integer), 1, 14)
            rct = rect(pnt, pnt) + rect(-10,-48,10, 2)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 50)+rect(1,0,1,0)
            if flp then
              rct = vertFlipRect(rct)
            end if
            member("layer"&string(lr)).image.copyPixels(member("HorseTailGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              rct = rect(pnt, pnt) + rect(-10,-48,10, 2)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "HorseTailGrad", gtRect, 0.5)
            end if 
            
          "Cacti":
            repeat with rep = 1 to random(random(3)) then
              sz = 0.5+(random(gEEprops.effects[r].mtrx[q2][c2]*0.7)*0.01)
              rotat = -45+random(90)
              if (solidAfaMv(point(q2-1,c2+1), layer)=0)or(afaMvLvlEdit(point(q2,c2), layer)=3) then
                rotat = rotat - 10-random(30)
              end if
              if (solidAfaMv(point(q2+1,c2+1), layer)=0)or(afaMvLvlEdit(point(q2,c2), layer)=2) then
                rotat = rotat + 10+random(30)
              end if
              tpPnt = pnt + degToVec(rotat)*15*sz
              
              rct = rotateToQuad( rect((pnt+tpPnt)*0.5,(pnt+tpPnt)*0.5)+rect(-4*sz,-7*sz,4*sz,8*sz) ,lookAtPoint(pnt, tpPnt))
              member("layer"&string(lr)).image.copyPixels(member("bigCircle").image, rct, member("bigCircle").image.rect, {#color:colr, #ink:36})
              if colr <> color(0,255,0) then
                -- tpPnt = depthPnt(tpPnt, lr-5)
                rct = rect(tpPnt,tpPnt)+rect(-9*sz,-6*sz,9*sz,13*sz)+rect(-3,-3,3,3)
                -- member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("softBrush1").image, rct, member("softBrush1").image.rect, {#maskImage:member("mask").image.createMask()})
                copyPixelsToEffectColor(gdLayer, lr, rct, "softBrush1", member("softBrush1").image.rect, 0.5)
              end if
            end repeat
          "Rubble":
            rct = rect(pnt,pnt)+rect(-3,-3,3,3)+rect(-random(3),-random(3), random(3), random(3))
            rct = rotateToQuad(rct,random(360))
            rubbl = random(4)
            repeat with rep = 1 to 4 then
              if lr+rep-1 > 29 then
                exit repeat
              else
                member("layer"&string(lr+rep-1)).image.copyPixels(member("rubbleGraf"&string(rubbl)).image, rct, member("rubbleGraf"&string(rubbl)).image.rect, {#color:color(0,255,0), #ink:36})
              end if                
            end repeat
          "Rain Moss":
            pnt = pnt + degToVec(random(360))*random(random(100))*0.04
            rct = rect(pnt,pnt)+rect(-12,-12,13,13)--+rect(-random(3),-random(3), random(3), random(3))
            rct = rotateToQuad(rct,((random(4)-1)*90)+1)
            gtRect = random(4)
            gtRect = rect((gtRect-1)*25, 0, gtRect*25, 25)
            -- repeat with rep = 1 to 4 then
            --   if lr+rep-1 > 29 then
            --   exit repeat
            -- else
            member("layer"&string(lr)).image.copyPixels(member("rainMossGraf").image, rct, gtRect, {#color:colr, #ink:36})
            -- end if                
            -- end repeat
            if (colr <> color(0,255,0)) then
              tpPnt = depthPnt(pnt, lr-5)+degToVec(random(360))*random(6)
              rct = rect(tpPnt,tpPnt)+rect(-20,-20,20,20)+rect(0,0,-15,-15)
              -- member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("softBrush1").image, rct, member("softBrush1").image.rect, {#maskImage:member("mask").image.createMask(), #blend:random(50)+50})
              copyPixelsToEffectColor(gdLayer, lr, rct, "softBrush1", member("softBrush1").image.rect, 0.5)
            end if
            
        end case
      end repeat
    end if
  end repeat
end

on giveGroundPos me, q, c,l
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  pnt = mdPnt + point(-11+random(21), 10)
  --if (gLEprops.matrix[q][c][l][1]=0) then
  -- end if
  if (gLEprops.matrix[q2][c2][l][1]=3) then
    pnt.locV = pnt.locv - (pnt.locH-mdPnt.locH) - 5
  else if (gLEprops.matrix[q2][c2][l][1]=2) then
    pnt.locV = pnt.locv - (mdPnt.locH-pnt.locH) - 5
  end if
  return pnt
end

on applyHugeFlower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    
    h = pnt.locV
    
    repeat while h < 30000 then
      h = h + 1
      pnt.locH = pnt.locH -2 + random(3)
      member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH+2, h+2), member("pxl").image.rect, {#color:colr})
      tlPos = giveGridPos(point(pnt.locH, h)) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    -- member("gradient"&gdLayer&string(giveDpFromLr(d))).image.copyPixels(member("hugeFlowerMask").image, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), member("hugeFlowerMask").image.rect, {#maskImage:member("hugeFlowerMaskMask").image.createMask()})
    
    copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
    
    --     
    --    
    
    --    repeat with cntr = 1 to gEEprops.effects[r].mtrx[q][c]*0.01*17 then
    --      pnt = mdPnt + point(-11+random(21), -4+random(7))
    --      lr = random(10)-1
    --      member("layer"&string(lr)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, pnt.locV, pnt.locH+2, mdPnt.locV+11), member("pxl").image.rect, {#color:color(255,255,0), #ink:36})
    --      
    --      pnt = depthPnt(pnt, lr-5) 
    --      pnt2 = depthPnt(point(pnt.locH, mdPnt.locV+11), lr-5)
    --      member("gradientA"&string(giveDpFromLr(lr))).image.copyPixels(member("softBrush1").image, rect(pnt pnt)+rect(-6, -6, 6, pnt2.locV-pnt.locV), member("softBrush1").image.rect, {#maskImage:member("mask").image.createMask()})
    --      
    --    end repeat
  end if
end

on ApplyArmGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 101 + random(201)
    
    points = [pnt]
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 31 + random(61)
      dir = lerp(lastDir, dir, 0.75)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10, -25, 10, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      points.add(pnt)
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("ArmGrowerGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    if(points.count > 2)then
      repeat with p = 1 to points.count-1 then
        rct = (points[p] + points[p+1])/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(points[p], points[p+1]))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, power((points.count-p.float+1)/points.count.float, 1.5))
      end repeat
    end if
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end


on ApplyThornGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.5
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 61 + random(121)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("thornBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "thornBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end

on ApplyGarbageSpiral me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
      frontWall = 1
      backWall = 29
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "1":
      d = random(9)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    dir = random(360)
    dirAdd = 40+random(20)
    if(random(2)=1)then
      dirAdd = -dirAdd
    end if
    
    grav = -0.7
    
    spiralWait = 15 + random(15)
    spiral = 1.0
    searchBase = -8--12
    
    loseSpiralTime = 60 + random(300)
    
    spiralFac = lerp(0.95, 0.91, (gEEprops.effects[r].mtrx[q2][c2]/100.0) * (random(1000)/1000.0))
    
    dpthSpeed = lerp(-1.0, 1.0, random(1000)/1000.0)/20.0
    
    conPoints = [[pnt, d, 0]]
    points = [[pnt, d, 1]]
    
    cntr = 0
    repeat while pnt.locV < 30000 then
      cntr = cntr + 1
      dir = dir + dirAdd
      
      dirAdd = dirAdd * spiralFac
      spiralFac = spiralFac + 0.0013
      if(spiralFac > 0.993)then
        spiralFac = 0.993
      end if
      
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*3.0*power(spiral, 0.5)
      
      spiralWait = spiralWait - 1
      if(spiralWait < 0)then
        moveDir = point(0,0)
        repeat with dst = 1 to 7 then
          repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
            tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst*dst
            if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
              moveDir = moveDir + (tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV])
            end if
          end repeat
        end repeat
        pnt = pnt + (moveDir/4600.0)*searchBase*(1.0-power(spiral, 0.5))
        searchBase = searchBase + 0.15
        if(searchBase > 12)then
          searchBase = 12
        end if
        
        
        pnt.locV = pnt.locV + grav * (1.0-power(spiral, 0.5))
        grav = grav + 0.2 * (1.0-power(spiral, 0.5))--(abs(grav) + 0.8) * 0.009 * (1.0-power(spiral, 0.5))
        
        
        spiral = spiral - (1.0/loseSpiralTime.float)
        if(spiral < 0)then
          spiral = 0
          d = d + dpthSpeed
          if(d < frontWall)then
            d = frontWall
          else if (d > backWall) then
            d = backWall
          end if
          
        end if
      end if
      
      if(random(1000) < power(spiral, 4.0)*1000)then
        conPoints.add([pnt, d, cntr])
      end if
      
      pnt = lastPnt + moveToPoint(lastPnt, pnt, 3.0)
      
      points.add([pnt, d, spiral])
      
      
      
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    repeat with cntr = 1 to conPoints.count then
      a = conPoints[random(conPoints.count)][1]
      blnd = (1.0-power(restrict(conPoints[cntr][3].float / points.count, 0, 1), 1.3))
      useD = restrict(conPoints[cntr][2].integer, frontWall, backWall)
      if(random(10)=1)then
        qd = rect(a.locH, a.locV, a.locH+1, a.locv+random(random(100)))
        member("layer"&string(points[1][2])).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      else
        b = conPoints[random(conPoints.count)][1]
        dir = moveToPoint(a, b, 1.0)
        perp = giveDirFor90degrToLine(-dir, dir)*0.5
        qd = [a - perp, a + perp, b + perp, b-perp]
        member("layer"&string(points[1][2])).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      end if
    end repeat
    
    lastPnt = points[1][1]
    lastUseD = points[1][2]
    repeat with q = 1 to points.count then
      pnt = points[q][1]
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-1, -2, 1, 2)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      
      useD = restrict(points[q][2].integer, frontWall, backWall)
      blnd = 1.0-power(restrict(q.float / points.count, 0, 1), 1.3)
      blnd = lerp(blnd, 0.5, points[q][3])
      member("layer"&string(useD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      
      if(lastUseD <> useD)then
        member("layer"&string(lastUseD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, lastUseD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      end if
      
      lastUseD = useD
      lastPnt = pnt
    end repeat
    
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end




on ApplyRoller me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
      frontWall = 1
      backWall = 29
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "1":
      d = random(9)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    dir = random(360)
    dirAdd = (10+random(30))*0.3
    if(random(2)=1)then
      dirAdd = -dirAdd
    end if
    
    dspeed = (-11+random(21))/100.0
    
    lastUseD = d
    
    grav = 0.7
    
    points = [[pnt, d]]
    
    seedChance = 1.0
    
    repeat while pnt.locV < 30000 then
      dir = dir - 11 + random(21) + dirAdd
      
      dspeed = restrict(dspeed + (-11+random(21))/1000.0, -0.1, 0.1)
      
      d = d + dspeed
      if(d < frontWall)then
        d = frontWall
        dspeed = random(10)/100.0
      else if (d > backWall)then
        d = backWall
        dspeed = -random(10)/100.0
      end if
      
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*5.0
      pnt.locV = pnt.locV + grav
      
      grav = grav + 0.001
      
      
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-1.5, -3.5, 1.5, 3.5)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      --      if(random(2)=1)then
      --        qd = flipQuadH(qd)
      --      end if
      
      
      --  var = random(13)
      
      useD = restrict(d.integer, frontWall, backWall)
      
      if(seedChance > 0)then
        repeat with a = 1 to 8 then
          if(random(1000)<power(seedChance, 1.5)*1000)then
            seedPos = pnt + MoveToPoint(pnt, lastPnt, (diag(pnt, lastPnt)*random(1000)).float/1000.0) + degToVec(random(360))*random(3)
            seedLr = restrict(useD - 2 + random(3), frontWall, backWall)
            member("layer"&string(seedLr)).image.copyPixels(member("rustDot").image, rect(seedPos,seedPos)+rect(-2, -2, 2, 2), member("rustDot").image.rect, {#color:colr, #ink:36} )
            copyPixelsToEffectColor(gdLayer, seedLr, rect(seedPos,seedPos)+rect(-2, -2, 2, 2), "rustDot", member("rustDot").image.rect, 0.8, 1)
            
            if(random(3) > 1)then
              seedLr = restrict(seedLr - 1, frontWall, backWall)
              member("layer"&string(seedLr)).image.copyPixels(member("pxl").image, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), member("pxl").image.rect, {#color:colr} )
              copyPixelsToEffectColor(gdLayer, seedLr, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), "pxl", member("pxl").image.rect, 0.8, 1)
            else
              member("layer"&string(seedLr)).image.copyPixels(member("pxl").image, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), member("pxl").image.rect, {#color:color(255, 0, 0)} )
            end if
          end if
        end repeat
      end if
      seedChance = seedChance - random(100).float/2200.0
      
      points.add([pnt, useD])
      
      member("layer"&string(useD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr} )
      
      
      if(lastUseD <> useD)then
        member("layer"&string(lastUseD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr} )
      end if
      
      lastUseD = useD
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, 1 + (useD > 9) + (useD > 19)) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    if(points.count > 2)then
      repeat with p = 1 to points.count-1 then
        rct = (points[p][1] + points[p+1][1])/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-1.5, -3.5, 1.5, 3.5)
        qd = rotateToQuad(rct, lookAtPoint(points[p][1], points[p+1][1]))
        --  copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.8)
        copyPixelsToEffectColor(gdLayer, points[p][2], qd, "pxl", rect(0,0,1,1), 0.8, power((points.count-p.float+1)/points.count.float, 1.5))
      end repeat
    end if
    
    
  end if
end




on applyHangRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    -- member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    lftBorder = mdPnt.locH-10
    rgthBorder =  mdPnt.locH+10
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      -- member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH+2, h+2), member("pxl").image.rect, {#color:colr})
      lstPos = pnt
      pnt = pnt + degToVec(-45+random(90))*(2+random(6))
      pnt.locH = restrict(pnt.locH, lftBorder, rgthBorder)
      dir = moveToPoint(pnt, lstPos, 1.0)
      crossDir = giveDirFor90degrToLine(-dir, dir)
      qd = [pnt-crossDir, pnt+crossDir, lstPos+crossDir, lstPos-crossDir]
      member("layer"&string(d)).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:gLOProps.pals[gLOProps.pal].detCol})
      
      if solidAfaMv(giveGridPos(lstPos) + gRenderCameraTilePos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
  end if
end


on applyThickRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 0
    
    floatDpth = d
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      floatDpth = floatDpth + lerp(-0.3, 0.3, random(1000)/1000.0)
      if(floatDpth < frontWall)then
        floatDpth = frontWall
      else if(floatDpth > backWall)then
        floatDpth = backWall
      end if
      d = restrict(floatDpth.integer, frontWall, backWall)
      
      lstPos = pnt
      dir = lerp(dir, -45+random(90), 0.5)
      pnt = pnt + degToVec(dir)*(2+random(6))
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (gridPos.locH + q > 0)and(gridPos.locH + q < gEEprops.effects[r].mtrx.count)and(gridPos.locV-1 > 0)and(gridPos.locV-1 < gEEprops.effects[r].mtrx[1].count) then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV-1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*2.0
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      if(lstGridPos.locH <> gridPos.locH) then
        if (gridPos.locH > 0)and(gridPos.locH < gEEprops.effects[r].mtrx.count)and(gridPos.locV > 0)and(gridPos.locV < gEEprops.effects[r].mtrx[1].count) then
          if (gEEprops.effects[r].mtrx[gridPos.locH][gridPos.locV] = 0)and(gEEprops.effects[r].mtrx[lstGridPos.locH][lstGridPos.locV] > 0) then
            pnt.locH = restrict(pnt.locH, giveMiddleOfTile(giveGridPos(lstPos)).locH-9, giveMiddleOfTile(giveGridPos(lstPos)).locH+9)
          end if
        end if
      end if
      
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:color(0,255,0)})
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
    
    
    
  end if
end



on applyShadowPlants me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 180
    
    -- floatDpth = d
    
    
    
    cycle = lerp(6.0, 12.0, random(10000)/10000.0)
    cntr = random(50)
    
    tltFac = 0.0
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      cntr = cntr + 1
      --      floatDpth = floatDpth + lerp(-0.3, 0.3, random(1000)/1000.0)
      --      if(floatDpth < frontWall)then
      --        floatDpth = frontWall
      --      else if(floatDpth > backWall)then
      --        floatDpth = backWall
      --      end if
      --      d = restrict(floatDpth.integer, frontWall, backWall)
      
      lstPos = pnt
      dir = lerp(dir, 180-45+random(90), 0.1)
      dir = dir + sin((cntr/cycle)*PI*2.0)*8
      cycle = cycle + 0.1
      if(cycle > 35) then cycle = 35
      pnt = pnt + degToVec(dir)*3
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV+1 > 0)and(lstGridPos.locV-1 < gEEprops.effects[r].mtrx[1].count) then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV+1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*lerp(-2.0, 1.0, power(tltFac, 0.85))
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tltFac = tltFac + 0.002
      if(tltFac > 1.0)then tltFac = 1.0
      --      
      --      
      --      if(lstGridPos.locH <> gridPos.locH) then
      --        if (gridPos.locH > 0)and(gridPos.locH < gEEprops.effects[r].mtrx.count)and(gridPos.locV > 0)and(gridPos.locV < gEEprops.effects[r].mtrx[1].count) then
      --          if (lstGridPos.locH  > 0)and(lstGridPos.locH < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV > 0)and(lstGridPos.locV < gEEprops.effects[r].mtrx[1].count) then
      --            if (gEEprops.effects[r].mtrx[gridPos.locH][gridPos.locV] = 0)and(gEEprops.effects[r].mtrx[lstGridPos.locH][lstGridPos.locV] > 0) then
      --              pnt.locH = restrict(pnt.locH, giveMiddleOfTile(giveGridPos(lstPos)).locH-9, giveMiddleOfTile(giveGridPos(lstPos)).locH+9)
      --            end if
      --          end if
      --        end if
      --      end if
      
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    fuzzLength = 20+random(50)
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    thickness = lerp(thickness, restrict(points.count.float, 20.0, 180.0)/180.0, 0.5)
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      --rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      f =  sin(f*PI*0.5)
      rad = 1.1 + f*7.0*(points[q][3].float/6.0)*lerp(thickness, 0.5, 0.2)
      
      
      
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:color(0,0,255)})
          
          if(random(30) = 1)then
            me.sporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 15 + random(50) * (1.0-f), d - c[1], color(0,0,255))
          end if
          
          if(q < fuzzLength) and(random(fuzzLength) > q)and(random(6)=1) then
            f2 = q.float / fuzzLength.float
            me.sporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 65 + random(50) * (1.0-f2), d - c[1], color(0,0,255))
          end if
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
    
    
    
  end if
end

on sporeGrower me, pos, lngth, layer, col
  dir = point(0, -1)
  
  repeat with q = 1 to lngth then
    otherCol = member("layer"&layer).image.getPixel(pos.locH-1, pos.locV-1)
    if(otherCol <> col)and(otherCol <> color(255, 255, 255))then
      exit repeat
    else
      member("layer"&layer).image.setPixel(pos.locH-1, pos.locV-1, col)
      pos = pos + dir
      
      if(dir.locV = -1)and(random(2)=1)then
        if(random(2)=1)then
          dir = point(-1, 0)
        else
          dir = point(1, 0)
        end if
      else 
        dir = point(0, -1)
      end if
    end if
  end repeat
end


on applyDaddyCorruption me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  global daddyCorruptionHoles
  
  extraHoleChance = 1
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> -1)then
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d < 30)then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("DaddyBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:36})
          else
            member("layer"&string(dp+d)).image.copyPixels(member("DaddyBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:36})
          end if
        else
          exit repeat
        end if
      end repeat
      
      if((random(3) = 1)or(extraHoleChance=1))and(dp<27)then
        daddyCorruptionHoles.add([startPos, rad * (50+random(50))*0.01, random(360), dp, amount])
        extraHoleChance = 0
      end if
    end if
  end repeat  
end

on applySlag me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
 
  mdPnt = giveMiddleOfTile(point(q,c))
  global slagHoles
 
  extraHoleChance = 1
 
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
   
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
   
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
   
    startPos = mdPnt+point(-11+random(21), -11+random(21))
   
   
    solid = 0
   
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
   
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
   
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
   
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> -1)then
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
   
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d < 30)then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("SlagBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:36})
          else
            member("layer"&string(dp+d)).image.copyPixels(member("SlagBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:36})
          end if
        else
          exit repeat
        end if
      end repeat
     
      if((random(3) = 1)or(extraHoleChance=1))and(dp<27)then
        slagHoles.add([startPos, rad * (50+random(50))*0.01, random(360), dp, amount])
        extraHoleChance = 0
      end if
    end if
  end repeat
end

on applyWire me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    fatness = 1
    case gEEprops.effects[r].options[3][3] of
      "2px":
        fatness = 2
      "3px":
        fatness = 3
      "random":
        fatness = random(3)
    end case
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    member("wireImage").image.copypixels(member("pxl").image, rect(startPos.locH, startPos.locV-1, startPos.locH+1, startPos.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:color(0,0,0)})
    -- member("layer"&string(d)).image.copypixels(member("pxl").image, rect(startPos.locH, startPos.locV-1, startPos.locH+1, startPos.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:color(0,255,0)})
    goodStops = 0
    
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      repeat with rep = 1 to 1000 then
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep
        pnt.locV = startPos.locV + a - (power(2.71828183, rep/a)+power(2.71828183, -rep/a))*(a/2.0)
        
        dr = moveToPoint(lastPnt, pnt, fatness.float)
        
        member("wireImage").image.copypixels(member("pxl").image, rect(pnt.locH, pnt.locV, pnt.locH+1, lastPnt.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:color(0,0,0)})
        
        -- member("layer"&string(d)).image.copypixels(member("pxl").image, rect(pnt.locH, pnt.locV, pnt.locH+1, lastPnt.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:gLOProps.pals[gLOProps.pal].detCol})
        
        
        lastPnt = point(pnt.locH, pnt.locV)
        
        
        
        
        
        tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
        if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
          exit repeat
        else 
          if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
            if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
              if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          else
            if solidAfaMv(tlPos, lr) then
              goodStops = goodStops + 1
              exit repeat
            end if
          end if
        end if
        
      end repeat
    end repeat
    
    if goodStops = 2 then
      member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:gLOProps.pals[gLOProps.pal].detCol, #ink:36})
    end if
  end if
end

on applyChain me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
  end case
  
  
  lr = 1+(d>9)+(d>19)
  
  big = 0
  
  case gEEprops.effects[r].options[3][3] of
    "FAT":
      big = 1
  end case
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    if big then
      a = a + 10
    end if
    
    origOrnt = random(2)-1
    
    goodStops = 0
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      if dir = 0 then
        ornt = origOrnt
      else
        ornt = 1-origOrnt
      end if
      repeat with rep = 1 to 4000 then
        checkterrain = 0
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep*0.25
        pnt.locV = startPos.locV + a - (power(2.71828183, (rep*0.25)/a)+power(2.71828183, -(rep*0.25)/a))*(a/2.0)
        
        if big = 0 then
          if diag(pnt, lastPnt)>=7 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-3,-5,3,5)
              gtRect = rect(0,0,6,10)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-1,-5,1,5)
              gtRect = rect(7,0,8,10)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("chainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        else
          if diag(pnt, lastPnt)>=12 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-6,-10,6,10)
              gtRect = rect(0,0,12,20)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-2,-10,2,10)
              gtRect = rect(13,0,16,20)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("bigChainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        end if
        
        if checkterrain then
          tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
          if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
            exit repeat
          else 
            if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
              if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
                if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                  goodStops = goodStops + 1
                  exit repeat
                end if
              end if
            else
              if solidAfaMv(tlPos, lr) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          end if
        end if
        
        
      end repeat
    end repeat
    
    
    if goodStops = 2 then
      member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:gLOProps.pals[gLOProps.pal].detCol, #ink:36})
    end if
  end if
end

on applyFungiFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  
  
  
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    rnd = 0
    if (afaMvLvlEdit(point(q2,c2+1), layer)=1) then
      rnd = gEffectProps.list[gEffectProps.listPos]
      flp = random(2)-1
      closestEdge = 1000
      repeat with a = - 5 to 5 then
        if (afaMvLvlEdit(point(q2+a,c2+1), layer)<>1) then
          if abs(a) <= abs(closestEdge) then
            flp = (a>0)
            closestEdge = a
            if a = 0 then
              flp = random(2)-1
            end if
          end if
        end if
      end repeat
      
      pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    else if (afaMvLvlEdit(point(q2+1,c2), layer)=1) then
      rnd = 1
      flp = 0
      pnt = giveMiddleOfTile(point(q,c))+point(10, -random(10))
    else if (afaMvLvlEdit(point(q2-1,c2), layer)=1) then
      rnd = 1
      flp = 1
      pnt = giveMiddleOfTile(point(q2,c2))+point(-10, -random(10))
    end if
    
    
    if rnd <> 0 then
      rct = rect(pnt, pnt) + rect(-80, -80, 80, 80)
      gtRect = rect((rnd-1)*160, 0, rnd*160, 160)+rect(1,0,1,0)
      if flp then
        rct = vertFlipRect(rct)
      end if
      member("layer"&string(lr)).image.copyPixels(member("fungiFlowersGraf").image, rct, gtRect, {#ink:36})
    end if
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [2,3,4,5]
    l2 = []
    repeat with a = 1 to 4 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 


on applyLHFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("lightHouseFlowersGraf").image, rct, gtRect, {#ink:36})
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8]
    l2 = []
    repeat with a = 1 to 8 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyBigPlant me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case gEEprops.effects[r].options[2][3] of
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
  end case
  
  mem = "fern"
  case gEEprops.effects[r].nm of
    "Fern":
    "Giant Mushroom":
      mem = "giantMushroom"
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-50, -80, 50, 20)
    gtRect = rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member(mem&"Graf").image, rct, gtRect, {#ink:36, #color:colr})
    
    pnt = depthPnt(pnt, lr-5)
    rct = rect(pnt, pnt) + rect(-50, -80, 50, 20)
    if flp then
      rct = vertFlipRect(rct)
    end if
    -- member("gradient"&gdLayer&string(giveDpFromLr(lr))).image.copyPixels(member("bigPlantBlack").image, rct, rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1), {#maskImage:member(mem&"Grad").image.createMask()})
    copyPixelsToEffectColor(gdLayer, lr, rct, mem&"Grad",rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1), 0.5)
    
    
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8]
    l2 = []
    repeat with a = 1 to 8 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 


on apply3Dsprawler me, q, c, effc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  big = 0
  if c > 1 then
    big = (gEEprops.effects[r].mtrx[q2][c2-1] > 0)
  end if
  
  lr = 1
  case gEEprops.effects[r].options[2][3] of
    "1":
      layer = 1
    "2":
      layer = 2
      lrRange = [6, 29]
    "3":
      
      layer = 3
      lrRange = [6, 29]
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  
  if layer = 1 then
    if lr < 5 then
      lrRange = [0, 5] 
    else 
      lrRange = [6, 29] 
    end if
  end if
  
  case effc of
    "sprawlBush":
      sts = [#branches:10+random(10)+15*big, #expectedBranchLife:[#small:20, #big:35, #smallRandom:30, #bigRandom:70], #startTired:0, #avoidWalls:1.0, #generalDir:0.6, #randomDir:1.2, #step:6.0]
    "featherFern":
      sts = [#branches:3+random(3)+3*big, #expectedBranchLife:[#small:130, #big:200, #smallRandom:50, #bigRandom:100], #startTired:-77 - (77*big), #avoidWalls:0.6, #generalDir:1.2, #randomDir:0.6, #step:2.0, #featherCounter:0, #airRoots:0]
    "Fungus Tree":
      sts = [#branches:10+random(10)+15*big, #expectedBranchLife:[#small:30, #big:60, #smallRandom:15, #bigRandom:30], #startTired:0, #avoidWalls:0.8, #generalDir:0.8, #randomDir:1.0, #step:3.0, thickness:(6+random(3))*(1+big*0.4), #branchPoints:[]]
      
  end case
  
  
  if (afaMvLvlEdit(point(q2,c2), layer)=0)and(afaMvLvlEdit(point(q2,c2+1), layer)=1) then
    
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    case effc of
      "Fungus Tree":
        
        if big then
          expectedLife = sts.expectedBranchLife.big+random(sts.expectedBranchLife.bigRandom)
        else
          expectedLife = sts.expectedBranchLife.small+random(sts.expectedBranchLife.smallRandom)
        end if
        sts.branchPoints = [[#pos:pnt, #dir:point(0,-1), #thickness:sts.thickness, #layer:lr, #lifeLeft:expectedLife, #tired:sts.startTired]]
        
    end case
    
    repeat with branches = 1 to sts.branches then
      pos = point(pnt.loch, pnt.locv)
      lstPos = point(pnt.loch, pnt.locv)
      generalDir = degToVec(-60+random(120))
      lstAimPnt = generalDir
      brLr = lr
      
      brLrDir = 101 + random(201)
      avoidWalls = 2.0
      
      tiredNess = sts.startTired
      
      if big then
        expectedLife = sts.expectedBranchLife.big+random(sts.expectedBranchLife.bigRandom)
      else
        expectedLife = sts.expectedBranchLife.small+random(sts.expectedBranchLife.smallRandom)
      end if
      
      case effc of
        "featherFern":
          sts.airRoots = 25+15*big
        "Fungus Tree":
          branch = sts.branchPoints[random(sts.branchPoints.count)]
          sts.branchPoints.deleteOne(branch)
          
          baseThickness = branch.thickness
          pos = branch.pos
          lstPos = branch.pos
          brLr = branch.layer
          generalDir = branch.dir
          lstAimPnt = branch.dir
          tiredNess = branch.tired
          expectedLife = restrict(branch.lifeLeft - 11 + random(21), 5, 200)
          startLifeTime = expectedLife
      end case
      
      repeat with step = 1 to expectedLife then
        lstPos = pos
        
        case effc of
          "featherFern":
            tiredNess = tiredNess + 0.5 + abs(tiredNess*0.05) - 0.3*big
          "Fungus Tree":
            tiredNess = -90*(1.0-((startLifeTime-step)/startLifeTime.float))
        end case
        
        aimPnt = generalDir*sts.generalDir+degToVec(random(360))*sts.randomDir + point(0, tiredNess*0.01)
        
        repeat with dir in [point(-1,0), point(-1,-1), point(0,-1), point(1,-1), point(1,0), point(1,1), point(0,1), point(-1,1)] then
          if (afaMvLvlEdit(giveGridPos(lstPos)+dir+gRenderCameraTilePos, ((brLr/10.0)-0.4999).integer+1)=1) then
            aimPnt = aimPnt - dir*avoidWalls
            avoidWalls = restrict(avoidWalls - 0.06, 0.2, 2)
            step = step + (effc <> "Fungus Tree")
          else
            aimPnt = aimPnt + dir*0.1
          end if
        end repeat
        
        avoidWalls = restrict(avoidWalls + 0.03, 0.2, 2)
        
        lstLayer = brLr
        
        
        brLr = brLr + brLrDir*0.01
        
        smllst = lrRange[1]
        if ((lstLayer/10.0)-0.4999).integer+1 > 1 then
          if (afaMvLvlEdit(giveGridPos(pos)+gRenderCameraTilePos, ((lstLayer/10.0)-0.4999).integer+1-1)=1) then
            wall = ((lstLayer/10.0)-0.4999).integer*10
            if wall > 0 then
              wall = wall - 1 
            end if
            smllst = restrict(smllst, wall, 0)
          end if
        end if
        
        bggst = lrRange[2]
        if ((lstLayer/10.0)-0.4999).integer+1 < 3 then
          if (afaMvLvlEdit(giveGridPos(pos)+gRenderCameraTilePos, ((lstLayer/10.0)-0.4999).integer+1+1)=1) then
            wall = ((restrict(lstLayer, 1, 29)/10.0)+0.4999).integer*10 -1
            bggst = restrict(bggst, 0, wall)
          end if
        end if
        
        if brLr < smllst then
          brLr = smllst
          brLrDir = random(41)
        end if
        if brLr > bggst then
          brLr = bggst
          brLrDir = -random(41)
        end if
        
        
        -- aimPnt = aimPnt + point(0, tiredNess*0.01)
        
        aimPnt = (aimPnt + lstAimPnt + lstAimPnt)/3.0
        
        lstAimPnt = aimPnt
        
        pos = pos + moveToPoint(point(0,0), aimPnt, sts.step)
        
        pstColor = 0
        
        case effc of 
          "featherFern":
            if sts.airRoots > 0 then
              sts.featherCounter = 20
              sts.airRoots = sts.airRoots - 1
            end if
            
            
            sts.featherCounter = sts.featherCounter + diag(pos, lstPos)*0.5 + abs(pos.locH - lstPos.locH) + abs(lstLayer-brLr)
            if sts.featherCounter > 8 + ((expectedLife-step)/expectedLife.float)*12 then
              sts.featherCounter = sts.featherCounter - (8 + ((expectedLife-step)/expectedLife.float)*12)
              
              fc = ((expectedLife-step)/expectedLife.float)
              fc = 1.0-fc
              fc = fc*fc
              fc = 1.0-fc
              
              lngth = sin(fc*PI)*  (abs(pos.locV-pnt.locV) + 120)/3.0
              
              
              repeat with cntr = 1 to sts.airRoots then
                lngth = (lngth*6.0 + (abs(pos.locV-pnt.locV)+4))/7.0
              end repeat
              -- put (expectedLife-step)/expectedLife.float && lngth
              
              repeat with rct in [rect(pos, pos) + rect(0, 0, 1, lngth), rect(pos, pos) + rect(1, 0, 2, lngth-random(random(random(lngth.integer+1))))] then
                member("layer"&string(brLr.integer)).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {#ink:36, #color:colr})
              end repeat
              
              copyPixelsToEffectColor(gdLayer, brLr, rect(pos, pos) + rect(-6, 0, 6, lngth+2), "featherFernGradient", member("featherFernGradient").rect, 0.5)
              
              pstColor = 1
            end if
            
            fc = ((expectedLife-step)/expectedLife.float)
            fc = fc*fc
            
            ftness = sin(fc*PI)*(4+1*big)
            rct = rect(pos, pos) + rect(-1, -3, 1, 3)+rect(-ftness, -ftness, ftness, ftness)
            
            
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            
            brLrDir = brLrDir -4 + random(7)
          "sprawlBush":
            rct = rect(pos, pos) + rect(-2, -5, 2, 5)
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            brLrDir = brLrDir -11 + random(21)
            
            pstColor = 1
            
          "Fungus Tree":
            
            thickness = ((startLifeTime-step)/startLifeTime.float)*baseThickness
            
            sts.branchPoints.add([#pos:pos, #dir:moveToPoint(point(0,0), aimPnt, 1.0), #thickness:thickness, #layer:brLr, #lifeLeft:startLifeTime-step, #tired:tiredNess])
            
            
            if step = expectedLife then
              rnd = random(5)
              rct = rect(pos, pos)+rect(-5, -19, 5, 1)
              if random(2)=1 then
                rct = vertFlipRect(rct)
              end if
              member("layer"&string(brLr.integer)).image.copyPixels(member("fungusTreeTops").image, rct, rect((rnd-1)*10, 1, rnd*10, 21), {#ink:36, #color:colr})
              copyPixelsToEffectColor(gdLayer, brLr, rect(pos, pos)+rect(-7, -11, 7, 3), "softBrush1", member("softBrush1").rect, 0.5)
            end if
            
            rct = rect(pos, pos) + rect(-1, -3, 1, 3)+rect(-thickness, -thickness, thickness, thickness)
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            brLrDir = brLrDir -11 + random(21)
            
            pstColor = 1
            
            
        end case
        
        
        
        
        
        member("layer"&string(brLr.integer)).image.copyPixels(member("blob").image, rct, member("blob").image.rect, {#ink:36, #color:colr})
        member("layer"&string(lstLayer.integer)).image.copyPixels(member("blob").image, rct, member("blob").image.rect, {#ink:36, #color:colr})
        
        if pstColor then
          blnd = (1.0-((expectedLife - step)/expectedLife.float))*25 + random((1.0-((expectedLife - step)/expectedLife.float))*75)
          if effc = "Fungus Tree" then
            blnd = (1.0-((expectedLife - step)/expectedLife.float))*100
          end if
          member("softbrush2").image.copypixels(member("pxl").image, member("softbrush2").image.rect, rect(0,0,1,1), {#color:color(255,255,255)})
          member("softbrush2").image.copypixels(member("softbrush1").image, member("softbrush2").image.rect, member("softbrush1").image.rect, {#blend:blnd})
          copyPixelsToEffectColor(gdLayer, brLr, rotateToQuad(rect(pos, pos) + rect(-17, -25, 17, 25),lookAtPoint(pos, lstPos)), "softBrush2", member("softBrush1").rect, 0.5)
        end if
        
      end repeat
    end repeat
    
    
  end if
end


on applyBlackGoo me, q, c, eftc
  sPnt = giveMiddleOfTile(point(q,c))+point(-10,-10)
  rct = member("blob").image.rect
  repeat with d = 1 to 10 then
    repeat with e = 1 to 10 then
      ps = point(sPnt.locH + d*2, sPnt.locV + e*2)
      if member("layer0").image.getPixel(ps) = color(255, 255, 255) then
        member("blackOutImg1").image.copyPixels(member("blob").image, rect(ps.locH-6-random(random(11)),ps.locV-6-random(random(11)),ps.locH+6+random(random(11)),ps.locV+6+random(random(11))), rct, {#color:0, #ink:36})
        member("blackOutImg2").image.copyPixels(member("blob").image, rect(ps.locH-7-random(random(14)),ps.locV-7-random(random(14)),ps.locH+7+random(random(14)),ps.locV+7+random(random(14))), rct, {#color:0, #ink:36})
      end if 
    end repeat
  end repeat
end

on applyRestoreEffect me, q, c, q2, c2, eftc
  
  case gEEprops.effects[r].options[2][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      layers = [1,2,3]
    "1":
      layers = [1]
    "2":
      layers = [2]
    "3":
      layers = [3]
    "1:st and 2:nd":
      layers = [1,2]
    "2:nd and 3:rd":
      layers = [2,3]
  end case
  
  repeat with layer in layers then
    if(afaMvLvlEdit(point(q2, c2), layer)=1)then
      mdPoint = giveMiddleOfTile(point(q,c))
      tlRct = rect(mdPoint+point(-10, -10), mdPoint+point(10,10))
      
      --        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint-point(10, 10), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      --    
      
      A = 2
      B = 1
      
      U = A
      if(me.isTileSolidAndAffected(point(q2-1, c2), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, -10), mdPoint+point(-10+U,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [1,4], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2+1, c2), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(10-U, -10), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [2,3], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2, c2-1), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, -10), mdPoint+point(10,-10+U)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [1,2], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2, c2+1), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, 10-U), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [3,4], U)
      
    end if
    reDrawPoles(point(q2,c2), layer, q, c, ((layer-1)*10) + 4)
  end repeat
end

on draw3DBeams me, q2, c2, layer, tlRct, crnrs, U
  if(layer > 1) then
    if(me.isTileSolidAndAffected(point(q2, c2), layer-1) = 1)then
      repeat with crnr in crnrs then
        rct = CornerRect(tlRct, crnr, U)
        repeat with lr = ((layer-1)*10) - 5 to ((layer-1)*10) + 5 then
          member("layer" & lr).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255, 0, 0)})
        end repeat
      end repeat
    end if
  end if
  if(layer < 3) then
    if(me.isTileSolidAndAffected(point(q2, c2), layer+1) = 1)then
      rct = CornerRect(tlRct, crnr, U)
      repeat with crnr in crnrs then
        repeat with lr = ((layer-1)*10) + 5 to ((layer-1)*10) + 15 then
          member("layer" & lr).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255, 0, 0)})
        end repeat
      end repeat
    end if
  end if
end


on CornerRect(tlRct, crnr, U)
  -- tlRct = tlRct+rect(1,1,-1,-1)
  case crnr of
    1:
      return rect(tlRct.left, tlRct.top, tlRct.left+U, tlRct.top+U)
    2:
      return rect(tlRct.right-U, tlRct.top, tlRct.right, tlRct.top+U)
    3:
      return rect(tlRct.right-U, tlRct.bottom-U, tlRct.right, tlRct.bottom)
    4:
      return rect(tlRct.left, tlRct.bottom-U, tlRct.left+U, tlRct.bottom)
  end case
end

on isTileSolidAndAffected me, tl, layer
  if(afaMvLvlEdit(point(tl.locH, tl.locV), layer)<>1)or(tl.locH<1)or(tl.locV<1)or(tl.locH > gLOprops.size.locH)or(tl.locV > gLOprops.size.locV)then
    return 0
  else if (gEEprops.effects[r].mtrx[tl.locH][tl.locV] > 0)then
    return 1
  else
    return 0
  end if
end



on reDrawPoles(pos, layer, q, c, drawLayer)
  global gLEProps, gLOprops
  if pos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
    repeat with t in gLEProps.matrix[pos.locH][pos.locV][layer][2] then
      case t of
        1:
          rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(0, 8, 0, -8)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
           member("layer" & drawLayer).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 0, 0)})
        2:
          rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(8, 0, -8, 0)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
           member("layer" & drawLayer).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 0, 0)})
      end case
    end repeat
  end if
end



on closestCamera me, pos
  global gCameraProps
  closest = 1000
  bestCam = 0
  repeat with camNum = 1 to gCameraProps.cameras.count then
    if(me.seenByCamera(camNum, pos) = 1)and(diag(pos, gCameraProps.cameras[camNum]+point(1400/2, 800/2)) < closest )then
      closest = diag(pos, gCameraProps.cameras[camNum]+point(1400/2, 800/2))
      bestCam = camNum
    end if
  end repeat
  
  return bestCam
end

on seenByCamera me, camNum, pos
  global gCameraProps
  
  cameraPos = gCameraProps.cameras[camNum]
  
  if pos.inside(rect(cameraPos.locH, cameraPos.locV, cameraPos.locH+1400, cameraPos.locV+800)+(rect(-15, -10, 15, 10)*20))then
    return 1
  else
    return 0
  end if
  
end























