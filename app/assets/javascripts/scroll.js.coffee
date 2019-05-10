$ ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination li.next a').attr('href')
      if url and $(window).scrollTop() > $(document).height() - $(window).height() - 200
        $('.pagination').html '<div class="col-xs-12">⌛ &nbsp;Loading.. please wait</div>'
        return $.getScript(url)
      return
    return $(window).scroll()
  return

$ ->
  $(window).scroll ->
    if $(this).scrollTop() > 50
      $('#back-to-top').fadeIn()
    else
      $('#back-to-top').fadeOut()
    return
  $('#back-to-top').click ->
    $('#back-to-top').tooltip 'hide'
    $('body,html').animate { scrollTop: 0 }, 800
    false
  $('#back-to-top').tooltip 'show'
  return
