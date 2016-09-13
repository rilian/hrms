$(document).on 'ready page:load', ->
  $('.js-select2-select').select2(
    theme: "bootstrap"
    tags: true
    allowClear: true,
    placeholder: 'Select a tag'
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
    name = $(this).val().replace(/^\s+|\s+$/g, '');
    container = $('.js-similar-people-container')
    if name.length > 1
      query = "/people.json?q[id_not_eq]=#{$(this).data('current-id')}"
      for part in name.split(/\s+/)
        query = query + "&q[name_cont_all][]=#{part}"

      $.ajax(url: query)
        .done (response)->
          container.html('')
          if response.length > 0
            container.html("Found #{response.length} similar people")
            if response.length < 10
              container.append(": ")
              for person in response
                container.append("<a target='_blank' href='/people\/#{person["id"]}'>#{person["name"]}</a> &nbsp;")

  $('form#new_person').on 'submit', (e)->
    similar = $('.js-similar-people-container').text().replace(/^\s+|\s+$/g, '');
    if similar.length > 0
      if !confirm("There are people with similar surname.\nAre you sure you want to create one more?\n\n#{similar}")
        e.preventDefault()
