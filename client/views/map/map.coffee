Template.map.helpers
  mapOptions: ->
    # Make sure the maps API has loaded
    if GoogleMaps.loaded()
      # Map initialization options
      return {
        center: new google.maps.LatLng(-37.8136, 144.9631)
        zoom: 8
      }

Template.map.onCreated ->

  @dispatcher = $({})

  console.log 'checkins', Mongo.Collection.get('checkins').find().count(), Template, this
  
  # Meteor.subscribe "checkins",
  # onReady: ->
  #   console.log 'coll re fetched', this, cc, a, b, c

  c = Mongo.Collection.get('checkins')
  cc = c.find()
  console.log cc, c

  cc.observe
    changed: (a, b, c)->
      console.log 'changed', a, b, c
  GoogleMaps.load()
  GoogleMaps.ready 'map', (map)=>
    new MapController(map)
    console.log("I'm ready!")
    # setAutoGeolocation.bind(@)()

    # @todo : create a map controller and set an instanec with `map`

  @dispatcher.on 'localisation', (event, data)->
    console.log event, data



setAutoGeolocation = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(
      (datas)=> # Success
        @dispatcher.trigger 'localisation',
          lat:  datas.coords.latitude
          lng:  datas.coords.longitude
      ()=>  # Error
        if google.loader.ClientLocation
          @dispatcher.trigger 'localisation',
            lat:  google.loader.ClientLocation.latitude
            lng:  google.loader.ClientLocation.longitude
    )
  else if(google.loader.ClientLocation)
    @dispatcher.trigger 'localisation',
      lat:  google.loader.ClientLocation.latitude
      lng:  google.loader.ClientLocation.longitude
