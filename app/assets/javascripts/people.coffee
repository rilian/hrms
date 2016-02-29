$(document).on 'ready page:load', ->
  $('.js-select2-select').select2(
      theme: "bootstrap"
      tags: true
      allowClear: true
    ).length > 0 && $('.dashboard').css({ "height": "auto" })
