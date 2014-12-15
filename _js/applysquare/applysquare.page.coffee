applysquare.namespace 'applysquare.page', (exports) ->
  'use strict'

  on_jobs_init = ->
    jobs = $(@)
    jobs.find('tbody > tr.js-jobs').on 'click', ->
      title = $(@).data('job-title')
      jobs.find('tbody > tr.js-jobs-details[data-job-title="' + title + '"]').toggleClass('hide')

  applysquare.init ->
    $('table.js-jobs').each on_jobs_init

