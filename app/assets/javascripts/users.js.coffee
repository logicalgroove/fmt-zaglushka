$ ->
  options =
    types: ["(cities)"]

  input = document.getElementById("city_name")
  autocomplete = new google.maps.places.Autocomplete(input, options)

  geocoder = undefined
  map = undefined

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
    geocoder = new google.maps.Geocoder()
    mapOptions =
      zoom: 3
      center: new google.maps.LatLng(36, -10)
      #disableDefaultUI: true
      #scrollwheel: false
      #navigationControl: false
      #mapTypeControl: false
      #scaleControl: false
      #draggable: false
      #disableDoubleClickZoom: true
      panControl: false
      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER }
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    map.setOptions styles: styles

  root.show_city_in_maps = (address) ->
    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = ''
    geocoder.geocode
      address: address
    , (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        marker = new google.maps.Marker(
          map: map
          icon: pinImage
          position: results[0].geometry.location
        )
        marker.setAnimation(google.maps.Animation.DROP)
      else
        alert "Geocode was not successful for the following reason: " + status

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
      show_city_in_maps(city)
      setInterval (->
      ), 2000


  if $('#map-canvas-main').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initializeMainMap()

root = exports ? this
