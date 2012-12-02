# Values to be used if not provided by instance config
default_confing =
  rows        : 1
  cols        : 1
  transSpeed  : 500
  index       : 0
  data        : []
  controls    : true
  focusedClass: 'focused'
  orientation : 'horizontal'
  onChange    : (elem)->
  onExit      : (direction)->
  selectors   :
    container: 'ul'
    wrapper  : '.wrapper'
    content  : '.content'
    focused  : '.focused'
    elem     : 'li',
    page     : '.page'
    tpl      : 'script[type="text/tpl"]'

# Content block CSS styles
content_css =
  position: 'relative'
  height  : '100%'

# Wrapper block CSS styles
wrapper_css =
  overflow: 'hidden'
  margin  : 0
  padding : 0

# Page block CSS styles
page_css =
  margin : 0
  padding: 0
  float  : 'left'

# Element block CSS styles
elem_css =
  float       : 'left'
  'list-style': 'none'

# Splitting array into pages
paginate = (arr, size) ->
  size = size or arr.length
  copy_arr = arr.slice(0)
  copy_arr.splice(0, size)  while copy_arr.length

# Simple loggers.
log = (o) -> console?.log o
dir = (o) -> console?.dir o

# Interntal templating function, can be replaced in config
tpl = (str) ->
  str = str.replace('data-src', 'src')
  (data) ->
    res = ''
    for val in data
      res += str.replace(/\{(\w*)\}/g, (s, p) -> val[p] or s)
    res

# Selector function
sel = (elem, sel)  -> elem.querySelector(sel)

# Select function for multiple elements
selAll = (elem, sel)  ->
  elements = []
  all = elem.querySelectorAll(sel)
  for val in all
    elements.push val if val instanceof Element
  elements

# Getting "total" height of element
heightOf = (elem) ->
  top = getComputedStyle(elem, null).getPropertyValue('margin-top')
  bottom = getComputedStyle(elem, null).getPropertyValue('margin-bottom')
  elem.offsetHeight + parseFloat(top) + parseFloat(bottom)

# Getting "total" width of element
widthOf = (elem) ->
  right = getComputedStyle(elem, null).getPropertyValue('margin-right')
  left = getComputedStyle(elem, null).getPropertyValue('margin-left')
  elem.offsetWidth + parseFloat(left) + parseFloat(right)

# Setting CSS style attribute
css = (elem, styles) ->
  style = []
  if elem instanceof Element
    for key, val of styles
      style.push "#{key}: #{val}"
    elem.setAttribute 'style', style.join ';'
  elem

# Gridy.js class definition goes here
class @Gridy

  constructor: (component_sel, options = {}) ->
    @options = {}
    # Merging passed options with default
    for key, val of default_confing
      @options[key] = val
    for key, val of options
      @options[key] = val

    @el = sel(document, component_sel)
    if not @el
      throw new Error "DOM element with selector #{component_sel} is not found"

    @wrapper = sel @el, @options.selectors.wrapper
    @content = sel @el, @options.selectors.content

    tpl_str = sel @el, @options.selectors.tpl

    #Using intertal templating factory if not provided in config
    unless @options.tpl
      @options.tpl = tpl tpl_str.innerHTML

    # Guessing what prefix to use for internal transition
    transition = ''
    for trans in ['WebkitT', 'MozT', 'OT', 'MsT', 't']
      if typeof document.body.style[trans + 'ransition'] == 'string'
        transition = trans + 'ransition'

    #Using intertal animation function if not provided in config
    unless @options.animate
      @options.animate = (direction, val, speed) =>
        @content.style[transition] = "#{speed}ms ease-in-out #{direction}"
        @content.style[direction] = "#{val}px"

    # Inserting data from config
    @insert @options.data if @options.data

    # Setting up controls if required by config
    if options.controls
      controls = []

      if options.cols > 1 or options.rows is 1
        controls.push 'left'
        controls.push 'right'
      if options.rows > 1
        controls.push 'up'
        controls.push 'down'

      for val in controls
        c = document.createElement('span')
        c.className = "#{val} control"
        c.innerHTML = val
        c.direction = val
        c.addEventListener 'click', (e)=> @move e.currentTarget.direction
        @el.appendChild c


    return this

  # Method in charge of DOM build process from data array
  insert     : (data)->
    if data.length
      # Paging data
      page_size = @options.cols * @options.rows
      paged = ''
      #Building pages DOM
      for val in paginate data, page_size
        paged += '<ul class="page">' + (@options.tpl val) + '</ul>'

      @content.innerHTML = paged if paged

      @elements = selAll @content, @options.selectors.elem
      @pages = selAll @content, @options.selectors.page

      first_page = @pages[0]
      first_elem = @elements[0]

      #Setting up styles for content and wrapper
      css @content, content_css
      css @wrapper, wrapper_css

      #Setting up styles for elements
      if @elements
        for val in @elements
          css val, elem_css

      row_height = heightOf first_elem
      col_width = widthOf first_elem

      #Setting up page dimentions
      if @pages
        for val in @pages
          css val, page_css
          val.style.height = "#{row_height * @options.rows}px"
          val.style.width = "#{col_width * @options.cols}px"

      @wrapper.style.width = "#{widthOf first_page}px"
      @wrapper.style.height = "#{heightOf first_page}px"

      if @options.orientation is 'horizontal'
        @content.style.width = "#{@pages.length * widthOf first_page}px"
      else
        @content.style.height = "#{@pages.length * heightOf first_page}px"

      # Setting data-c and data-r attributes,
      # based on element physical "natural" position.
      # So we are able to navigate between elements as we see them
      rows = {}
      cols = {}
      r = 0
      c = 0
      # Mapping elements into rows and columns based on their offset coords.
      for val in @elements
        rows[val.offsetTop] = []  unless rows[val.offsetTop]
        cols[val.offsetLeft] = []  unless cols[val.offsetLeft]
        cols[val.offsetLeft].push val
        rows[val.offsetTop].push val

      #Setting up attributes
      for key, val of rows
        for key, el_val of val
          el_val.setAttribute "data-r", r
        r += 1

      for key, val of cols
        for key, el_val of val
          el_val.setAttribute "data-c", c
        c += 1

      #Initial focus, without animation
      @focus @elements[@options.index], 0
    return @

  # Changing active position using direction param
  move       : (direction)->
    focused = sel @content, @options.selectors.focused
    if focused
      r = parseInt focused.getAttribute "data-r"
      c = parseInt focused.getAttribute "data-c"

      switch direction
        when "left"
          c -= 1
        when "right"
          c += 1
        when "up"
          r -= 1
        when "down"
          r += 1
        else

      next = sel @content, "[data-r='#{r}'][data-c='#{c}']"

      # If destinatin element is avaliable then do focus on it.
      if next
        next.classList.add @options.focusedClass
        focused.classList.remove @options.focusedClass
        @focus next, @options.transSpeed
      else
        # If not then triggring callback.
        # For instance we can foucs another control in this situation
        @options.onExit direction

    return @

  # Changing active element's focus

  focus: (focused, speed = 0)->
    focused.classList.add @options.focusedClass
    page = focused.parentElement

    if @options.orientation is "horizontal"
      @options.animate 'left', -page.offsetLeft, speed
    else
      @options.animate 'top', -page.offsetTop, speed

    #Triggering onChange callback and passing focused param
    @options.onChange focused
    return @