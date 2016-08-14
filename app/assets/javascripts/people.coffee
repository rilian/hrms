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

  $('.js-person-name').on 'keyup', ->
    if $(this).val().length > 1
      $.ajax(url: "/people.json?q[name_cont]=#{$(this).val()}")
        .done (response)->
          $('.js-similar-people-container').html('').append("Found #{response.length} similar people")
          if response.length < 10
            $('.js-similar-people-container').append(": ")
            for person in response
              $('.js-similar-people-container').append("<a target='_blank' href='/people\/#{person["id"]}'>#{person["name"]}</a> &nbsp;")
