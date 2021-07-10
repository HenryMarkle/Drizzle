global projects, ldPrps, gLOADPATH

on exitFrame me
  projects = []
  
  pth = the moviePath & "LevelEditorProjects\"
  repeat with f in gLOADPATH then
    pth = pth & "\" & f
  end repeat
  
  fileList = [ ]
  repeat with i = 1 to 300 then
    n = getNthFileNameInFolder(pth, i)
    if n = EMPTY then exit repeat
    if (char n.length-3 of n <> ".")then
      projects.add("#" & n)
    else
      fileList.append(n)
    end if
  end repeat
  
  
  
  
  repeat with l in fileList then
    if chars(l, l.length-3, l.length) = ".txt" then
      projects.add( chars(l, 1, l.length-4))
    end if
  end repeat
  
  txt = "Use the arrow keys to select a project. Use enter to open it."
  put RETURN after txt
  repeat with f in gLOADPATH then
    put f & "/" after txt
  end repeat
  put RETURN after txt
  put RETURN after txt
  repeat with q in projects then
    put q after txt
    put RETURN after txt
  end repeat
  
  ldPrps = [#lstUp:1, lstDwn:1, #lft:1, #rgth:1, #currProject:1, #listScrollPos:1, #listShowTotal:30]
  
  member("ProjectsL").text = txt
  
  member("PalName").text = "Press 'N' to create a new level. Use left and right arrows to step in and out of subfolders"
end