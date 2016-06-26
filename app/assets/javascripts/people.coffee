$(document).on 'ready page:load', ->
  $('.js-select2-select').select2(
      theme: "bootstrap"
      tags: true
      allowClear: true
    ).length > 0 && $('.dashboard').css({ "height": "auto" })

  $('.js-show-more').click ->
    $('.js-show-more-container').show()
    $(this).hide()

  $('.js-show-quick-forms').click ->
    $('.js-show-quick-forms-container').show()
    $(this).hide()
