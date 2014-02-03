$ ->
  geocoder = undefined
  map = undefined
  markers = []

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
      maxZoom: 11
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
      new google.maps.LatLng(-70, -180),
      new google.maps.LatLng(70, 180)
    )

    google.maps.event.addListener map, "bounds_changed", ->
      c = map.getCenter()
      x = c.lng()
      y = c.lat()
      maxX = strictBounds.getNorthEast().lng()
      maxY = strictBounds.getNorthEast().lat()
      minX = strictBounds.getSouthWest().lng()
      minY = strictBounds.getSouthWest().lat()
      x = minX  if x < minX
      x = maxX  if x > maxX
      y = minY  if y < minY
      y = maxY  if y > maxY
      map.setCenter new google.maps.LatLng(y, x)

    google.maps.event.addListener map, "zoom_changed", ->
      if map.zoom >= 4
        for mk in markers
          mk.labelVisible = true
      else
        for mk in markers
          mk.labelVisible = false

  root.show_city_in_maps = (address, latitude, longitude, zoom) ->
    zoom = (if typeof zoom isnt "undefined" then zoom else false)

    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = new MarkerWithLabel(
      map: map
      icon: pinImage
      position: new google.maps.LatLng(latitude, longitude)
      labelAnchor: new google.maps.Point(40, 0)
      labelContent: address.split(',')[0]
      labelClass: "labels"
      labelVisible: false
    )
    markers.push(marker)
    marker.setAnimation(google.maps.Animation.DROP)
    iw = new google.maps.InfoWindow({content: address})

    google.maps.event.addListener marker, "mouseover", ->
      #iw.open map, marker
      $(".gm-style-iw").next("div").remove()
      $(marker.label.labelDiv_).show()

    google.maps.event.addListener marker, "mouseout", ->
      #iw.close()
      if map.zoom <= 3
        $(marker.label.labelDiv_).hide()

    if zoom
      map.panTo(marker.getPosition())
      map.setZoom(3)

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

  Pace.on 'done', ->
    if $('#map-canvas').length > 0
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
