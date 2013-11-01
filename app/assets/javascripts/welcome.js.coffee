initialize = ->
  mapOptions =
    zoom: 8
    center: new google.maps.LatLng(-34.397, 150.644)
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  map.setOptions styles: styles
map = undefined
google.maps.event.addDomListener window, "load", initialize


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
