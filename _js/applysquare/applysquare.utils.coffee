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
      window.ga 'create', account, 'blog.applysquare.com'
      load '//www.google-analytics.com/analytics.js'

    window.ga 'send', 'pageview',
      page: location.pathname + location.search + location.hash
      location: location.href

  applysquare.init ->
    analytics(applysquare.settings.ANALYTICS)
