
@showHideRequired = () ->
  if($('#custom_field_field_type_id option:selected').text() == 'checkbox')
    $('#required').hide()
  else
    $('#required').show()

$ ->

  $('#custom_field_field_type_id').change () ->
    showHideRequired()
    return

  showHideRequired()

  return
