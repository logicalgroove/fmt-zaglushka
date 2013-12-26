$ ->
  geocoder = undefined
  map = undefined

  $('.dialog').center()
  $(window).resize ->
    $('.dialog').center()

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

  root.initializeUserMap = ->
    options =
      types: ["(cities)"]

    if $("#city_name_auto").length > 0
      input = document.getElementById("city_name_auto")
      autocomplete = new google.maps.places.Autocomplete(input, options)

      google.maps.event.addListener autocomplete, 'place_changed', ->
        place = autocomplete.getPlace()
        country = ''
        for addr in place.address_components
          for type in addr.types
            if type == 'country'
              country = addr.long_name
        $.ajax
          context: this
          url: '/cities'
          type: 'POST'
          data: {city: {name: place.name, latitude: place.geometry.location.lat(), longitude: place.geometry.location.lng(), g_id: place.id, country: country}, user_id: gon.user_id}

    geocoder = new google.maps.Geocoder()
    mapOptions =
      zoom: 3
      center: new google.maps.LatLng(36, -10)
      scrollwheel: true
      navigationControl: false
      mapTypeControl: false
      scaleControl: false
      streetViewControl: false
      draggable: true
      disableDoubleClickZoom: false
      panControl: false
      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER }
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    map.setOptions styles: styles

  root.show_city_in_maps = (address, latitude, longitude, zoom) ->
    zoom = (if typeof zoom isnt "undefined" then zoom else false)

    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = new google.maps.Marker(
      map: map
      icon: pinImage
      position: new google.maps.LatLng(latitude, longitude)
    )
    marker.setAnimation(google.maps.Animation.DROP)
    if zoom
      map.panTo(marker.getPosition())

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

  if $('#map-canvas').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initializeUserMap()
    for city in gon.cities
      show_city_in_maps(city.name, city.latitude, city.longitude)

  if $('#map-canvas-main').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initializeMainMap()

  $('.invite_final').click ->
    $('.text_container').show()

root = exports ? this
