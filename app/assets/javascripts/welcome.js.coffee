$ ->
  $(".main").onepage_scroll
    sectionContainer: "section"
    easing: "ease"
    animationTime: 1000

  $('.invite_me').click ->
    $('.main').moveTo(2)

