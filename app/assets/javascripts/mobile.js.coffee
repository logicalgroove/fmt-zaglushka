$ ->
  Pace.on 'done', ->
    $('.main').fadeIn()

  $('.invite_me').click ->
    $("html, body").animate
      scrollTop: $(document).height()
    , "slow"
    $('.email_form').show()
    $('.invite_final').hide()
