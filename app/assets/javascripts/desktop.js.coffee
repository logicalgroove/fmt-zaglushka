$ ->
  geocoder = undefined
  map = undefined
  been_there = false

  $('.icon.down').center('left')
  $(window).resize ->
    $('.dialog').center()
    $('.icon.down').center('left')

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


  root.initializeMainMap = ->
    geocoder = new google.maps.Geocoder()
    mainMapOptions =
      zoom: 3
      center: new google.maps.LatLng(33, -10)
      disableDefaultUI: true
      scrollwheel: false
      navigationControl: false
      mapTypeControl: false
      scaleControl: false
      draggable: false
      disableDoubleClickZoom: true
      panControl: false
      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER }
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map-canvas-main"), mainMapOptions)
    map.setOptions styles: styles

  styles = [
    { featureType: "water", stylers: [ { color: '#309eb5' }, { visibility: "simplified" } ] },
    { featureType: 'landscape', stylers: [ { color: '#444444' } ] },
    { featureType: 'transit', stylers: [ { visibility: "off" } ] },
    { featureType: 'poi', stylers: [ { visibility: "off" } ] },
    { featureType: "road", stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative', elementType: 'geometry', stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative.country', elementType: 'geometry', stylers: [ { visibility: "on"  } ] },
    { featureType: 'administrative.country', elementType: 'geometry.stroke', stylers: [ { weight: 1 }, { color: '#2e2e2e' } ] },
    { featureType: 'administrative.country', elementType: 'labels', stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative.neighborhood', stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative.province', elementType: "labels", stylers: [ { visibility: "off" } ] }
    { featureType: 'administrative.land_parcel', elementType: "geometry", stylers: [ { visibility: "off" } ] },
  ]

  show_city_in_maps = (address, latitude, longitude) ->

    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = new google.maps.Marker(
      map: map
      icon: pinImage
      position: new google.maps.LatLng(latitude, longitude)
    )
    marker.setAnimation(google.maps.Animation.DROP)

  $('.main').onepage_scroll
    sectionContainer: 'section'
    easing: 'ease'
    animationTime: 1000
    afterMove: (index) ->
      if (index == 3 or index == 4) and not been_there
        city_counter = 0
        add_city = ->
          if city_counter < cities.length
            show_city_in_maps(cities[city_counter].name, cities[city_counter].latitude, cities[city_counter].longitude, map)
            city_counter++
          else
            clearInterval city_timer
        city_timer = setInterval(add_city, 300)
        been_there = true


  if $('#map-canvas-main').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initializeMainMap()

  $('.md1, .md2, .md3').click ->
    $(".main").moveDown()



root = exports ? this
