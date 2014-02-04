$ ->
  calculate_font_size = ->
    if $(window).height() > $(window).width()
      emz = $(window).width() / 100
    else
      emz = $(window).width() / 144
    $("body").css "font-size", emz + "px"

  calculate_font_size()
  $(window).resize ->
    calculate_font_size()
