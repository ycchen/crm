$ ->
  $('#sale_contact').autocomplete({
    serviceUrl: '/contacts/autocomplete',
    onSelect: (suggestion) ->
      $('#contact_id').val(suggestion.data)
  });
