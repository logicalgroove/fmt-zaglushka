$ ->
  cities = ['Madrid', 'New York', 'Havan', 'Mumbai', 'Odessa', 'Moscow', 'Paris', 'Los Angeles', 'Mexico City', 'Bali', 'Hong Kong', 'Lagos', 'Luanda', 'Cairo', 'Montevideo']
  been_there = false


  $('.page_1 .btn').hide()
  $('.page_1 h1').hide().wait(2000).show 'drop', ->
    $('.page_1 .btn').show 'drop', {direction: 'down'}

  $('.main').onepage_scroll
    sectionContainer: 'section'
    easing: 'ease'
    animationTime: 1000
    afterMove: (index) ->
      if (index == 3 or index == 4) and not been_there
        city_counter = 0
        add_city = ->
          if city_counter < cities.length
            show_city_in_maps(cities[city_counter])
            city_counter++
          else
            clearInterval city_timer
        city_timer = setInterval(add_city, 300)
        been_there = true

  $('.invite_me').click ->
    $('.main').moveTo(4)

  $('.invite_final').click ->
    $(this).hide()
    $('.email_form').show()
