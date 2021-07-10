global c, keepLooping, afterEffects, gLastImported, gRenderTrashProps, gCurrentlyRenderingTrash, softProp, propsToRender, gPEprops


on exitFrame me
  c = 1
  keepLooping = 1
  afterEffects = (_movie.frame > 51)
  gLastImported = ""
  gCurrentlyRenderingTrash = false
  if(gRenderTrashProps.count > 0)and(afterEffects=0)then
    gCurrentlyRenderingTrash = true
  end if
  
  repeat with q = 0 to 29 then
    sprite(50-q).loc = point((1024/2)-q, (768/2)-q)
    val = (q.float+1.0)/30.0
    sprite(50-q).color = color(val*255, val*255, val*255)
  end repeat
  
  propsToRender = []
  repeat with a = 1 to gPEprops.props.count then
    propsToRender.add(gPEprops.props[a])
    propsToRender[propsToRender.count].addAt(1, propsToRender[propsToRender.count][5].settings.renderOrder)
  end repeat
  propsToRender.sort()
  repeat with a = 1 to propsToRender.count then
    propsToRender[a].deleteAt(1)
  end repeat
  
  softProp = void
end