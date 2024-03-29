$ ->

  $('#new_user').submit  ->
    regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
    email = $(this).find('#user_email')
    unless regex.test(email.val())
      email.switchClass('', 'wrong', 200)
      setTimeout (->
        email.switchClass('wrong', '', 200)
      ), 3000
      false

jQuery.fn.center = (side) ->
  side = (if typeof side isnt "undefined" then side else false)
  @css "position", "absolute"
  if side == 'left'
    @css "left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px"
  else if side == 'top'
    @css "top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px"
  else
    @css "top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px"
    @css "left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px"
  this
