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

  console.log  Mongo.Collection.get('checkins').find().count()
  
  # Meteor.subscribe "checkins",
  # onReady: ->
  #   console.log 'coll re fetched', this, cc, a, b, c

  c = Mongo.Collection.get('checkins')
  cc = c.find()
  console.log cc.count()

  cc.observe
    changed: (a, b, c)->
      console.log 'changed', a, b, c

  GoogleMaps.load()
  GoogleMaps.ready 'map', (map)->
    console.log("I'm ready!")
    console.log cc.count()
    setTimeout ->
      console.log cc.count()
    , 1000