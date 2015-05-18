$ ->
  $('.page_1, .page_2, .page_3, .page_4').css('min-height', $(window).height() + 80)
  Pace.on 'done', ->
    $('.main').fadeIn()

  $('.invite_me').click ->
    $("html, body").animate
      scrollTop: $(document).height()
    , "slow", ->
      $('.email_form').show()
      $('#user_email').focus()
    $('.invite_final').hide()
