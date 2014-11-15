applysquare.namespace 'applysquare.utils', (exports) ->
  'use strict'

  load = (src, options) ->
    options = $.extend
      url: src
      dataType: 'script'
      cache: true
    , options
    $.ajax options

  analytics = (account) ->
    return unless account

    unless window.ga
      window['GoogleAnalyticsObject'] = 'ga'
      window.ga = window.ga or -> (window.ga.q = window.ga.q or []).push arguments
      window.ga.l = 1 * new Date()
      window.ga 'create', account, 'applysquare.net'
      load '//www.google-analytics.com/analytics.js'

    window.ga 'send', 'pageview',
      page: location.pathname + location.search + location.hash
      location: location.href

  on_disqus_init = ->
    disqus = $(@)
    window.disqus_shortname = 'applysquare'
    window.disqus_identifier = disqus.data('id')
    window.disqus_url = disqus.data('url')
    window.disqus_title = disqus.data('title')
    window.disqus_config = ->
      @language = disqus.data('language')

    if window.DISQUS
      window.DISQUS.reset
        reload: true
      return

    load '//applysquare.disqus.com/embed.js'

  document_write = null
  document_writeln = null
  on_gist_init = ->
    return if document_write or document_writeln

    element = $(@)
    id = element.data('id')
    file = element.data('file')

    document_write = document.write
    document_writeln = document.writeln
    document.write = (html) ->
      element.append(html)
    document.writeln = (html) ->
      element.append(html + '\n')

    load 'https://gist.github.com/' + id + '.js',
      data:
        file: file
      complete: ->
        document.write = document_write
        document.writeln = document_writeln
        document_write = null
        document_writeln = null

  applysquare.init ->
    analytics(applysquare.settings.ANALYTICS)

    $('div.js-disqus').each on_disqus_init
    $('div.js-gist').each on_gist_init
