$ ->
  $('#sale_item_product').autocomplete({
    serviceUrl: '/products/autocomplete',
    onSelect: (suggestion) ->
      $('#sale_item_product_id').val(suggestion.data)
      $('#sale_item_price').val(suggestion.price)
  });
