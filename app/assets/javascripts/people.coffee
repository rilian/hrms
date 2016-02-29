$(document).on 'ready page:load', ->
  if $('.js-select2-select').select2(
      theme: "bootstrap"
      tags: true
      allowClear: true
    ).length
    $('.dashboard').css({ "height": "auto" })
