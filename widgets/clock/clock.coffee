class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()

    h = (today.getHours() + 24) % 12 || 12
    m = today.getMinutes()
    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m + ":" + s)
    @set('weekday', @formatDay(today.getDay()))
    @set('date', @formatMonth(today.getMonth()) + " " + today.getDate() + ", " + today.getFullYear())

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatDay: (i) ->
    weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    weekdays[i]

  formatMonth: (i) ->
    months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    months[i]