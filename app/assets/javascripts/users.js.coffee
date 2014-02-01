$ ->
  geocoder = undefined
  map = undefined

  $('.dialog').center()

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
      minZoom: 2
      center: new google.maps.LatLng(36, -10)
      scrollwheel: true
      navigationControl: false
      mapTypeControl: false
      scaleControl: false
      streetViewControl: false
      draggable: true
      disableDoubleClickZoom: false
      panControl: false
      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER, style: google.maps.ZoomControlStyle.SMALL }
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    map.setOptions styles: styles

    strictBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(-85, -180),
      new google.maps.LatLng(85, 180)
    )

    google.maps.event.addListener map, "bounds_changed", ->
      console.log 'moved'
      mapBounds = map.getBounds()
      map_SW_lat = mapBounds.getSouthWest().lat()
      map_SW_lng = mapBounds.getSouthWest().lng()
      map_NE_lat = mapBounds.getNorthEast().lat()
      map_NE_lng = mapBounds.getNorthEast().lng()
      maxX = strictBounds.getNorthEast().lng()
      maxY = strictBounds.getNorthEast().lat()
      minX = strictBounds.getSouthWest().lng()
      minY = strictBounds.getSouthWest().lat()
      return  if strictBounds.contains(mapBounds.getNorthEast()) and strictBounds.contains(mapBounds.getSouthWest())

      # We're out of bounds - Move the map back within the bounds
      map_SW_lng = minX  if map_SW_lng < minX
      map_SW_lng = maxX  if map_SW_lng > maxX
      map_NE_lng = minX  if map_NE_lng < minX
      map_NE_lng = maxX  if map_NE_lng > maxX
      map_SW_lat = minY  if map_SW_lat < minY
      map_SW_lat = maxY  if map_SW_lat > maxY
      map_NE_lat = minY  if map_NE_lat < minY
      map_NE_lat = maxY  if map_NE_lat > maxY
      map.panToBounds new google.maps.LatLngBounds(new google.maps.LatLng(map_SW_lat, map_SW_lng), new google.maps.LatLng(map_NE_lat, map_NE_lng))

  root.show_city_in_maps = (address, latitude, longitude, zoom) ->
    zoom = (if typeof zoom isnt "undefined" then zoom else false)

    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = new google.maps.Marker(
      map: map
      icon: pinImage
      position: new google.maps.LatLng(latitude, longitude)
      labelContent : 'test'
      labelAnchor: new google.maps.LatLng(latitude, longitude)
      labelClass: "labels"
    )
    marker.setAnimation(google.maps.Animation.DROP)
    iw = new google.maps.InfoWindow({content: address})

    google.maps.event.addListener marker, "mouseover", ->
      iw.open map, marker
      $(".gm-style-iw").next("div").remove()

    google.maps.event.addListener marker, "mouseout", ->
      iw.close()

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
    { featureType: 'administrative.locality', elementType: 'labels', stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative.neighborhood', stylers: [ { visibility: "off" } ] },
    { featureType: 'administrative.province', elementType: "labels", stylers: [ { visibility: "off" } ] }
    { featureType: 'administrative.land_parcel', elementType: "geometry", stylers: [ { visibility: "off" } ] },
  ]

  if $('#map-canvas').length > 0
    #google.maps.event.addDomListener window, "load", initialize
    initializeUserMap()
    for city in gon.cities
      show_city_in_maps(city.name, city.latitude, city.longitude)

  $('.invite_final').click ->
    $('.text_container').show()

  $('.finish_my_map').click ->
    $(this).hide()
    $('#city_name_auto').hide()
    $('.share_container').center().show('drop', {direction: 'up'})

  $('.instagram').click ->
    $('.overlay').show()
    $('.logo-small').hide()
    $('.counters').hide()

    img = $("<img />").attr("src", "/maps/instagram_map_#{gon.user_id}.jpg").load(->
      $('.instagram_map').html img
      $('.instagram_container').center().show('drop', {direction: 'up'})
    )

    $('.share_container').center().hide()

  $('.overlay').click ->
    $(this).hide()
    $('.instagram_container').hide()
    $('.logo-small').show()
    $('.counters').show()
    $('#city_name_auto').show()
    $('.finish_my_map').show()

root = exports ? this
