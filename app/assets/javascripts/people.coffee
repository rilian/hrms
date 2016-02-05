$(document).on 'ready page:load', ->
  $("#person-tags").select2(
    theme: "bootstrap"
    tags: true
  )
