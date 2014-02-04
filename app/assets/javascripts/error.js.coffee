$ ->
  center_text = ->
    $(".container").css "top", Math.max(0, (($(window).height() - $(".container").outerHeight()) / 2.5) + $(window).scrollTop()) + "px"
  center_text()
  $(window).resize ->
    center_text()
