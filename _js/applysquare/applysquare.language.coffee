applysquare.namespace 'applysquare.language', (exports) ->
  'use strict'

  applysquare.init ->
    language = navigator.userLanguage or navigator.language or 'en'
    language = language.split('-')[0].toLowerCase()
    language = 'en' unless language in ['zh']
    body = $(document.body)
    $('*[lang]', body).addClass('hide')
    $('*[lang="' + language + '"]', body).removeClass('hide')
