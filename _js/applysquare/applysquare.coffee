((window) ->
  'use strict'

  namespace = (target, name, block) ->
    [target, name, block] = [window, arguments...] if arguments.length < 3
    top = target
    target = target[item] or= {} for item in name.split '.'
    block target, top

  namespace 'applysquare', (exports, top) ->
    exports.namespace = namespace

    callbacks = []
    exports.init = (callback) ->
      callbacks.push callback

    exports.run = ->
      callback() for callback in callbacks

)(window)

$ ->
  debug.setLevel(9) if window.location.search is '?debug'
  applysquare.run()

applysquare.namespace 'applysquare.settings', (exports) ->
  'use strict'

  applysquare.init ->
    $('div.js-settings div').each ->
      key = $(@).data('key')
      value =  $(@).data('value')
      return if not key
      exports[key] = value
      debug.setLevel(9) if key is 'DEBUG' and value
      debug.info 'applysquare.settings.' + key, value
    $('div.js-settings').remove()

$ ->

  $.pjax.defaults.success = -> applysquare.run()
  $('a').pjax
    containers: ['#base', '#navbar']

  $('.js-autotimestamp').autotimestamp()

  loading_timer = null

  $(document.body).bind 'pjax:start', ->
    clearTimeout loading_timer
    loading_timer = setTimeout ->
      clearTimeout loading_timer
      loading_timer = null
      $('div.js-loading').addClass('progress-striped active')
    , 1

  $(document.body).bind 'pjax:end', ->
    clearTimeout loading_timer
    loading_timer = setTimeout ->
      clearTimeout loading_timer
      loading_timer = null
      $('div.js-loading').removeClass('progress-striped active')
    , 1000

