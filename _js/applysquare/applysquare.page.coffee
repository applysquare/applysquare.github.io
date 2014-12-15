applysquare.namespace 'applysquare.page', (exports) ->
  'use strict'

  on_jobs_init = ->
    jobs = $(@)
    jobs.find('tbody > tr.js-jobs').on 'click', ->
      title = $(@).data('job-title')
      jobs.find('tbody > tr.js-jobs-details[data-job-title="' + title + '"]').toggleClass('hide')

  on_page_init = ->
    post = $(@)
    content = post.find('section.js-page-content')

    # make links open new window
    $.each content.find('a'), ->
      $(@).attr
        target: '_blank'

  applysquare.init ->
    $('article.js-page').each on_page_init
    $('table.js-jobs').each on_jobs_init

