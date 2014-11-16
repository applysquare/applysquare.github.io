applysquare.namespace 'applysquare.language', (exports) ->
  'use strict'

  applysquare.init ->
    language = navigator.userLanguage or navigator.language or 'zh'
    language = language.split('-')[0].toLowerCase()
    language = 'zh' unless language in ['en']

    body = $(document.body)
    $('*[lang]', body).addClass('hide')
    $('*[lang="' + language + '"]', body).removeClass('hide')
