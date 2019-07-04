class Dashing.Forecast extends Dashing.Widget

  # Overrides Dashing.Widget method in dashing.coffee
  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      timestamp = new Date(updatedAt * 1000)
      hours = timestamp.getHours()
      minutes = ("0" + timestamp.getMinutes()).slice(-2)
      "Updated at #{hours}:#{minutes}"

  constructor: ->
    super
    @forecast_icons = new Skycons({"color": "white"})
    @forecast_icons.play()

  ready: ->
    # This is fired when the widget is done being rendered
    if @get('detail')
      $(@node).find('#summary').remove()
    else
      $(@node).find('#detail').remove()
    @setIcons()

  onData: (data) ->
    # Handle incoming data
    # We want to make sure the first time they're set is after ready()
    # has been called, or the Skycons code will complain.
    if @forecast_icons.list.length
      @setIcons()

  setIcons: ->
    list = ["clear-day", "clear-night", "partly-cloudy-day","partly-cloudy-night", "cloudy", "rain", "sleet", "snow", "wind","fog"]
    i = 0
    #console.log(list.length)
    while i < list.length
      weatherType = list[i]
      @setIcon(weatherType)
      i++
    #@setIcon('current_icon')
    #@setIcon('next_icon')
    #@setIcon('later_icon')
    #@setIcon('.icon_0')
    #@setIcon('.icon_1')
    #@setIcon('icon_2')
    #@setIcon('icon_3')
    #@setIcon('icon_4')
    #@setIcon('icon_5')
    #@setIcon('icon_6')
    @forecast_icons.play()

  setIcon: (name) ->
    console.log(name)
    skycon = @toSkycon(name)
    #nodes = $(@node).find(name)
    nodes = document.getElementsByClassName(name)
    console.log(skycon)
    if nodes.length > 0
      #@forecast_icons.set(nodes, eval(skycon)) if skycon
      j = 0
      while j < nodes.length
        console.log("hello")
        console.log(nodes[j])
        @forecast_icons.set(eval(nodes[j]), eval(skycon)) if skycon
        console.log(nodes[j])
        #nodes[j]
        j++
    #@forecast_icons.set(name, eval(skycon)) if skycon

  toSkycon: (data) ->
    'Skycons.' + data.replace(/-/g, "_").toUpperCase()
    #if @get(data)
      #'Skycons.' + @get(data).replace(/-/g, "_").toUpperCase()
