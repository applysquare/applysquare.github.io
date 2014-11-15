(($) ->
  'use strict'

  strip_scheme_and_hostname = (url) ->
    base = window.location.protocol + '//' + window.location.host
    url = url.substr(base.length) if url.substr(0, base.length) is base
    return url

  construct_url = (url, data) ->
    debug.assert url.substr(0, 5) is 'http:' or url.substr(0, 6) is 'https:' or url.substr(0, 1) is '/'
    url = window.location.protocol + '//' + window.location.host + url if url.substr(0, 1) is '/'
    return url

  $.fn.pjax = (options) ->

    @livequery 'click', (event) ->
      # don't actually invoke pjax if browser does not support it.
      return unless $.support.pjax

      element = $(@)
      href = element.attr('href')
      return if href is undefined

      # quick skip #
      return event.preventDefault() if href is '#'

      # skip link that are not within the same base
      href = strip_scheme_and_hostname href
      return if href.substr(0, 1) != '/'

      # skip link that does not require page refresh
      fragment = href.indexOf('#')
      return if fragment is 0
      return if fragment > 0 and window.location.pathname + window.location.search is href.substr(0, fragment)

      # skip link that has a target
      return unless element.attr('target') is undefined

      # skip link that has a rel
      return unless element.attr('rel') is undefined

      # skip link marked as no-pjax
      return if element.data('pjax') is false

      # middle click, cmd click, and ctrl click should open
      # links in a new tab as normal.
      return if event.which > 1 or event.metaKey or event.shiftKey or event.ctrlKey

      event.preventDefault()

      defaults =
        url: href
        containers: element.data('pjax')

      # invoke pjax finally
      $.pjax $.extend {}, defaults, options

  pjax = $.pjax = (options) ->

    options = options or {}
    options.url = if $.isFunction(options.url) then options.url() else options.url
    options.url = options.url or window.location.pathname + window.location.search
    options.url = strip_scheme_and_hostname options.url

    # skip url that are not within the same base
    return window.location.replace(options.url) if options.url.substr(0, 1) != '/'

    # fall back if pjax is not supported
    return window.location.replace(options.url) unless $.support.pjax or options.force

    # default to body container.
    options.containers = ['body'] if not options.containers

    options = $.extend(true, {}, pjax.defaults, options)
    options.context = $(document.body)

    # We don't want to let anyone override our success handler.
    success = options.success or $.noop
    delete options.success
    options.success = (data) ->
      html = $('<div/>').html data

      # title
      title = $.trim html.find('title').text() or ''
      if title
        setTimeout ->
          $('title').text title
          document.title = title
        , 1

      # update each container
      $.each options.containers, (index, container) ->
        source = html.find(container)
        return window.location.replace(options.url) unless source.length > 0

        target = $(container)
        source.insertAfter target
        target.remove()

      href = construct_url(options.url, options.data)
      debug.assert window.location.href is href if options.pop

      # save new state
      if not options.pop and $.support.pjax
        state =
          containers: options.containers

        # if location changed, push state, otherwise just replace
        if window.location.href != href
          window.history.pushState state, title, href
          debug.debug 'pjax.pushstate', title, href
        else
          window.history.replaceState state, title, href
          debug.debug 'pjax.replacestate', title, href

      # if the URL has a hash in it, make sure the browser
      # knows to navigate to the hash.
      hash = window.location.hash.toString()
      if hash isnt '' and options.top is undefined
        window.location.href = hash
        setTimeout ->
          window.location.href = hash
          $(window).trigger 'scroll'
        , 1

      # otherwise, scroll to top
      else if options.top isnt undefined
        $('html, body').scrollTop options.top or 0
        setTimeout ->
          $('html, body').scrollTop options.top or 0
          $(window).trigger 'scroll'
        , 1

      success.apply @, arguments
      @trigger 'pjax:complete'
      return

    # replace the state to save top
    if not options.pop and $.support.pjax
      state =
        containers: options.containers
        top: $(window).scrollTop()

      window.history.replaceState state, document.title, window.location.href
      debug.debug 'pjax.replacestate', document.title, window.location.href

    # cancel the current request if we're already pjaxing
    xhr = pjax.xhr
    if xhr and xhr.readyState < 4
      xhr.onreadystatechange = $.noop
      xhr.abort()

    pjax.options = options
    pjax.xhr = $.ajax(options)
    return pjax.xhr

  pjax.defaults =
    timeout: 21000
    force: false
    pop: false
    top: 0
    type: 'GET'
    data: {}
    dataType: 'html'
    containers: ['body']
    url: -> window.location.pathname + window.location.search
    beforeSend: (xhr) -> @trigger 'pjax:start', [ xhr, pjax.options ]
    error: (xhr, text_status, error) -> window.location = pjax.options.url if text_status isnt 'abort'
    complete: (xhr) -> @trigger 'pjax:end', [ xhr, pjax.options ]

  # used to detect initial (useless) popstate.
  # If history.state exists, assume browser isn't going to fire initial popstate.
  pjax.initial = if 'state' of window.history then false else true

  # popstate handler takes care of the back and forward buttons
  # you probably shouldn't use pjax on pages with other pushstate
  # stuff yet.
  $(window).bind 'popstate', (e) ->
    # ignore inital popstate that some browsers fire on page load
    return pjax.initial = false if pjax.initial

    return if not e.state
    debug.debug 'pjax.popstate', window.location.href, e.state

    $.pjax
      url: window.location.href
      containers: e.state.containers
      top: e.state.top
      pop: true

  # add the state property to jQuery's event object so we can use it in
  # $(window).bind('popstate')
  $.event.props.push 'state' if $.inArray('state', $.event.props) < 0

  # is pjax supported by this browser?
  # pushState isn't reliable on iOS until 5
  $.support.pjax = window.history and window.history.pushState and window.history.replaceState and \
                   not navigator.userAgent.match /((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/

) jQuery
