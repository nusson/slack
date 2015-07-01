Template.map.helpers
  mapOptions: ->
    console.log 'MAP ...'
    # Make sure the maps API has loaded
    if GoogleMaps.loaded()
      console.log 'MAP LOADED'
      # Map initialization options
      return {
        center: new google.maps.LatLng(-37.8136, 144.9631)
        zoom: 8
      }

Template.map.onCreated ->
  GoogleMaps.load()
  GoogleMaps.ready 'map', (map)->
     console.log("I'm ready!")