(($) ->

  $.autotimestamp =
    timer: null
    options: {}

  $.autotimestamp.defaults =
    interval: 30000
    gettext: (text) -> text

  pretty_date = (timestamp, options) ->
    year = timestamp.getFullYear()
    month = timestamp.getMonth() + 1
    date = timestamp.getDate()
    month = '0' + month if month < 10
    date = '0' + date if date < 10
    if year is (new Date()).getFullYear()
      format = options.gettext('%m/%d')
    else
      format = options.gettext('%Y/%m/%d')
    return format.replace(/%Y/g, year).replace(/%m/g, month).replace(/%d/g, date)

  pretty_time = (timestamp, options) ->
    hours = timestamp.getHours()
    minutes = timestamp.getMinutes()
    hours = '0' + hours if hours < 10
    minutes = '0' + minutes if minutes < 10
    format = options.gettext('%H:%M')
    return format.replace(/%H/g, hours).replace(/%M/g, minutes)

  # pretty print timestamp
  pretty_timestamp = (timestamp, options) ->
    now = new Date()
    diff = Math.floor((now.getTime() - timestamp.getTime()) / (1000 * 60))
    if diff < -10
      return pretty_date(timestamp, options)
    if diff < 1
      return options.gettext('Just now')
    if diff < 5
      return options.gettext('Few minutes ago')
    if diff < 60
      return options.gettext('%d minutes ago').replace(/%d/g, diff)

    diff = Math.floor(diff / 60)
    if diff is 1
      return options.gettext('An hour ago')
    if diff < 9
      return options.gettext('%d hours ago').replace(/%d/g, diff)
    if Math.abs(diff) < 24 and now.getDay() == timestamp.getDay()
      return options.gettext('Today at %s').replace(/%s/g, pretty_time(timestamp, options))
    if Math.abs(diff) < 48 and now.getDay() == (timestamp.getDay() + 1) % 7
      return options.gettext('Yesterday at %s').replace(/%s/g, pretty_time(timestamp, options))

    return pretty_date(timestamp, options)

  # update a given timestamp span
  update = (element) ->
    options = $.extend {}, $.autotimestamp.defaults, $.autotimestamp.options
    timestamp = new Date(parseInt(element.data('timestamp')) * 1000)
    element.find('span').text pretty_timestamp timestamp, options
    element.data('autotimestamp', true).attr('data-autotimestamp', 'true')

    return if $.autotimestamp.timer
    $.autotimestamp.timer = setInterval ->
      $('*[data-autotimestamp]').each -> update $(this)
    , options.interval

  $.fn.autotimestamp = (options) ->
    $.autotimestamp.options = options or {}

    @livequery ->
      element = $(@)
      update element
      timestamp = new Date(parseInt($(this).data('timestamp')) * 1000)
      element.attr 'title', timestamp.toLocaleDateString() + ' ' + timestamp.toLocaleTimeString()

)(jQuery)
