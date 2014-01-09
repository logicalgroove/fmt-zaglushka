$ ->
  calculate_font_size = ->
    emz = $(window).width() / 144
    $('body').css('font-size', "#{emz}px")

  calculate_font_size()

  $(window).resize ->
    calculate_font_size()

  $('.invite_me').click ->
    $('.main').moveTo(4)
    $('.email_form').show()
    $('.invite_final').hide()

  $('.invite_final').click ->
    $(this).hide()
    $('.email_form').show()
    false

  $('#new_user').submit  ->
    regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
    email = $(this).find('#user_email')
    unless regex.test(email.val())
      email.switchClass('', 'wrong', 200)
      setTimeout (->
        email.switchClass('wrong', '', 200)
      ), 3000
      false

jQuery.fn.center = ->
  @css "position", "absolute"
  @css "top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px"
  @css "left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px"
  this
