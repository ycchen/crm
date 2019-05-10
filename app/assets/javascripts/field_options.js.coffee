
window.saveOptionsSort = (id) ->
  order = $('table#options_' + id + ' tbody').sortable('serialize')
  $.ajax
    method: 'post'
    url: '/custom_fields/' + id + '/field_options/save_sort'
    data: order: order
    success: (result) ->
  return


window.setupSortable = (id) ->
  $('table#options_' + id + ' tbody').sortable
    cursor: 'move'
    opacity: 0.7
    update: (e, ui) ->
      saveOptionsSort(id)
      return

# $ ->

  # $('table#options tbody').sortable
  #   cursor: 'move'
  #   opacity: 0.7
  #   update: (e, ui) ->
  #     saveOptionsSort()
  #     return
