$ ->
  $(".main").onepage_scroll
    sectionContainer: "section"
    easing: "ease"
    animationTime: 1000

  $('.invite_me').click ->
    $('.main').moveTo(2)


initialize = ->
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
