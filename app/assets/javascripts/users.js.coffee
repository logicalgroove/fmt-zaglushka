$ ->
  geocoder = undefined
  map = undefined

  root.initialize = ->
    geocoder = new google.maps.Geocoder()
    mapOptions =
      zoom: 3
      center: new google.maps.LatLng(0, 0)
      disableDefaultUI: true
      scrollwheel: false
      navigationControl: false
      mapTypeControl: false
      scaleControl: false
      draggable: false
      disableDoubleClickZoom: true
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    map.setOptions styles: styles

  root.show_city_in_maps = (address) ->
    geocoder.geocode
      address: address
    , (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        marker = new google.maps.Marker(
          map: map
          position: results[0].geometry.location
        )
      else
        alert "Geocode was not successful for the following reason: " + status


  styles = [
    featureType: "water"
    stylers: [
      color: '#555555',
      visibility: "simplified"
    ]
  ,
    featureType: 'landscape'
    stylers: [
      color: '#222222'
    ],
  ,
    featureType: 'poi'
    stylers: [visibility: "off"],
  ,
    featureType: 'administrative'
    stylers: [visibility: "off"],
  ,
    featureType: "road"
    stylers: [visibility: "off"],
  ,
    featureType: 'administrative.country'
    stylers: [visibility: 'off']
  ]

  if $('#map-canvas').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initialize()
    for city in gon.cities
      show_city_in_maps(city)

root = exports ? this
