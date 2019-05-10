
@setupDateTimePicker = ->
  $('.datetimepicker').datetimepicker
      format: 'M d, yyyy H:ii P Z'
      autoclose: true
      todayHighlight: true
      minuteStep: 15
      showMeridian: true

$ ->
  setupDateTimePicker()
  return
