$ ->
  $('.datepicker')
    .datepicker({
      format: 'dd-mm-yyyy',
      autoclose: true,
      todayBtn: true,
      todayHighlight: true,
      weekStart: 1
    })
    .on('changeDate', (e) ->
      if (e.target.id == 'dayoff_start_on')
        $('#dayoff_end_on').datepicker('setDate', $('#dayoff_start_on').datepicker('getDate'))
    )

