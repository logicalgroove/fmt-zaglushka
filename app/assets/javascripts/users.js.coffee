$ ->
  geocoder = undefined
  map = undefined
  if typeof gon isnt "undefined"
    gon.markers = []
    gon.iw = []

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

    google.maps.event.addListener map, "bounds_changed", ->
      if map.zoom == 2
        strictBounds = new google.maps.LatLngBounds(
          new google.maps.LatLng(-30, -180),
          new google.maps.LatLng(30, 180)
        )
      else
        strictBounds = new google.maps.LatLngBounds(
          new google.maps.LatLng(-70, -180),
          new google.maps.LatLng(70, 180)
        )

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
        for mk in gon.markers
          mk.labelVisible = true
      else
        for mk in gon.markers
          mk.labelVisible = false

  root.show_city_in_maps = (id, address, latitude, longitude, zoom) ->
    zoom = (if typeof zoom isnt "undefined" then zoom else false)

    pinImage = new google.maps.MarkerImage("/assets/pin.png", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))

    marker = new MarkerWithLabel(
      map: map
      icon: pinImage
      position: new google.maps.LatLng(latitude, longitude)
      labelAnchor: new google.maps.Point(50, 0)
      labelContent: address.split(',')[0]
      labelClass: "labels"
      labelVisible: false
    )
    marker.set("id", "marker_#{id}")
    gon.markers.push(marker)
    marker.setAnimation(google.maps.Animation.DROP)

    if gon.is_logged_in
      content = "<h1 class='iw_h1 left'>#{address}</h1><a href='/users/#{gon.user_id}/delete_city?city_id=#{id}' class='icon city-delete left' data-remote=true><img src='/assets/icon-trash.png' /></a><div class='clear'></div><p>Этот город посетили #{gon.cities[id].user_percentage}% наших пользователей!</p>"
    else
      content = "<h1 class='iw_h1 left'>#{address}</h1><div class='clear'></div><p>этот город посетили #{gon.cities[id].user_percentage}% наших пользователей!</p>"
    iw = new google.maps.InfoWindow({content: content})

    google.maps.event.addListener marker, "mouseover", ->
      #iw.open map, marker
      $(marker.label.labelDiv_).fadeIn()

    google.maps.event.addListener marker, "mouseout", ->
      if map.zoom <= 3
        $(marker.label.labelDiv_).hide()

    google.maps.event.addListener marker, "click", ->
      gon.iw.push(iw)
      for iwo in gon.iw
        iwo.close()
      iw.open map, marker

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
      for city_id, city of gon.cities
        show_city_in_maps(city_id, city.name, city.latitude, city.longitude)

  $('.invite_final').click ->
    $('.text_container').show()

  $('.finish_my_map').click ->
    $(this).hide()
    $('#city_name_auto').hide()
    $('.share_container').show('drop', {direction: 'up'})

  $('.instagram').click ->
    $('.overlay').show()
    $('.logo-small').hide()
    $('.counters').hide()

    $.get "/users/#{gon.user_id}/shared_to?service=instagram"
    img = $("<img />").attr("src", "/maps/instagram_map_#{gon.user_id}.jpg").load(->
      $('.instagram_map').html img
      $('.instagram_container').show('drop', {direction: 'up'})
    )

    $('.share_container').hide()

  $('.instagram_container').click (e) ->
    $('.overlay').hide()
    $('.instagram_container').hide()
    $('.logo-small').show()
    $('.counters').show()
    $('#city_name_auto').show()
    $('.finish_my_map').show()

  $('.instagram_container').on 'click', 'img', (e) ->
    e.stopPropagation()

  $('.twitter').click ->
    $.get "/users/#{gon.user_id}/shared_to?service=twitter"

  $('.vk').click ->
    $.get "/users/#{gon.user_id}/shared_to?service=vk"


root = exports ? this
