$ ->
  cities = [
    {name: 'Madrid', latitude: '40.4167754', longitude: '-3.7037901999999576'},
    {name: 'New York', latitude: '40.7143528', longitude: '-74.0059731'},
    {name: 'Havana', latitude: '23.1168', longitude: '-82.38855699999999'},
    {name: 'Mumbai', latitude: '19.0759837', longitude: '72.87765590000004'},
    {name: 'Odessa', latitude: '46.482526', longitude: '30.723309500000028'},
    {name: 'Moscow', latitude: '55.755826', longitude: '37.6173'},
    {name: 'Paris', latitude: '48.856614', longitude: '2.3522219000000177'},
    {name: 'Los Angeles', latitude: '34.0522342', longitude: '-118.2436849'},
    {name: 'Mexico City', latitude: '19.4326077', longitude: '-99.13320799999997'},
    {name: 'Bali', latitude: '29.0620317', longitude: '76.73581650000006'},
    {name: 'Budapest', latitude: '47.497912', longitude: '19.04023499999994'},
    {name: 'Lagos', latitude: '6.441158', longitude: '3.4179770000000644'},
    {name: 'Luanda', latitude: '-8.8383333', longitude: '13.23444440000003'},
    {name: 'Cairo', latitude: '30.0444196', longitude: '31.23571160000006'},
    {name: 'Montevideo', latitude: '-34.8836111', longitude: '-56.18194440000002'}]

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
            cities[city_counter].name
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
