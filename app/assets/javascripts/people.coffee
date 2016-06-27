$(document).on 'ready page:load', ->
  $('.js-select2-select').select2(
    theme: "bootstrap"
    tags: true
    allowClear: true
  )

  $('.js-show-edit-form').click ->
    $('.js-edit-form-container').show()
    $('.js-show-container').hide()

  $('.js-show-more').click ->
    $('.js-show-more-container').show()
    $(this).hide()

  $('.js-show-quick-forms').click ->
    $('.js-show-quick-forms-container').show()
    $(this).hide()
