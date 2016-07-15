$ ->
  $loadMoreButton = $("button.js-load-more")
  $loadMoreButton.prop("disabled", false)
  limitSize = $loadMoreButton.data('limit')
  offset = limitSize

  urlParams = ->
    pl = /\+/g
    search = /([^&=]+)=?([^&]*)/g

    decode = (s) ->
      decodeURIComponent s.replace(pl, ' ')

    query = window.location.search.substring(1)
    params = {}
    while match = search.exec(query)
      # TODO: fix for case when there is an array of values
      params[decode(match[1])] = decode(match[2])
    params

  $loadMoreButton.click ->
    $loadMoreButton.children('span').show()
    $loadMoreButton.prop("disabled", true)
    params = urlParams()
    params['page'] =
      offset: offset
      limit: limitSize
    path = if window.location.pathname == '/' then '/users' else window.location.pathname
    $.ajax(url: "#{path}.partial?#{$.param(params)}")
    .done (response)->
      $('.js-loadable-list').append(response)
      if $(response).filter('.js-page-last').length == 0
        $loadMoreButton.prop("disabled", false)
        $loadMoreButton.children('span').hide()
        offset += limitSize
      else
        $loadMoreButton.remove()
