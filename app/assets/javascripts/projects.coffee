$(document).on 'ready page:load', ->
  $('.js-show-edit-form').click ->
    $('.js-edit-form-container').show()
    $('.js-show-container').hide()

  $('.js-show-quick-forms').click ->
    $('.js-show-quick-forms-container').show()
    $(this).hide()
