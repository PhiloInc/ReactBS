sub init()
  m.components = {}
  m.props = {}
  m.state = {}
  m.virtualTree = {}

  m.top.observeField("itemContent", "reactComponentOnChangeItemContent")
  m.top.observeField("props", "reactComponentOnChangeProps")
end sub

' React Component Lifecycle

function render() as object
  return {}
end function

sub componentDidUpdate(prevProps as object, prevState as object)
  ' NOOP unless overridden
end sub

sub componentWillUnmount()
  ' NOOP unless overridden
end sub

function shouldComponentUpdate(nextProps = {} as object) as boolean
  return true
end function

' Public

sub unmountComponent(params = {} as object)
  for each child in m.top.getChildren(m.top.getChildCount(), 0)
    if child.isReactComponent = true then
      child.callFunc("unmountComponent", {})
    end if
  end for
  componentWillUnmount()
end sub

' Private

sub mapFieldsToProps(props = [] as object)
  for each prop in props
    m.props[prop] = m.top[prop]
    m.top.observeField(prop, "reactComponentOnChangeField")
  end for
end sub

sub setState(state = {} as object)
  prevState = m.state
  m.state = reactSetData(m.state, state)
  reactRender()
  componentDidUpdate(m.props, prevState)
end sub

' Internal

sub reactComponentOnChangeField(event as object)
  propName = event.getField()
  propValue = event.getData()
  newProps = {}
  newProps[propName] = propValue
  reactSetProps(newProps)
end sub

sub reactComponentOnChangeItemContent(event = {} as object)
  eventData = event.getData()
  if eventData = invalid
    reactSetProps()
    return
  end if
  reactSetProps(eventData)
end sub

sub reactComponentOnChangeProps(event = {} as object)
  eventData = event.getData()
  reactSetProps(eventData)
end sub

function reactGetComponent(componentID = "" as string) as dynamic
  component = invalid
  if componentID = "top"
    component = m.top
  else if m.components[componentID] <> invalid
    component = m.components[componentID]
  else
    component = m.top.findNode(componentID)
  end if
  ' Cache component
  if component <> invalid then m.components[componentID] = component
  return component
end function

sub reactRender()
  virtualTree = render()
  if virtualTree = invalid
    ' Rendered exclusively by side effect
    return
  end if
  m.virtualTree = virtualTree
  for each componentID in virtualTree
    componentProps = virtualTree[componentID]
    component = reactGetComponent(componentID)
    if component = invalid
      print "React", "ERROR", "React.reactSetData()", "Invalid component: "; componentID
    else
      component.setFields(componentProps)
    end if
  end for
end sub

function reactSetData(prevData = {} as object, data = invalid as dynamic)
  if data = invalid then return {}

  newData = {}
  newData.append(prevData)

  if type(data) = "roSGNode" then
    for each item in data.items()
      newData[item.key] = data[item.key]
    end for
  else if type(data) = "roAssociativeArray" then
    newData.append(data)
  else
    print "React", "ERROR", "React.reactSetData()", "Unsupported data type: "; type(data), data
  end if

  return newData
end function

sub reactSetProps(props = {} as object)
  nextProps = reactSetData(m.props, props)
  prevProps = m.props
  m.props = nextProps
  if shouldComponentUpdate(nextProps)
    reactRender()
    componentDidUpdate(prevProps, m.state)
  end if
end sub
