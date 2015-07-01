

Meteor.startup ->
  console.log('startup')

  new Mongo.Collection('checkins')
  Meteor.subscribe "checkins",
  onReady: ->
    console.log 'checkins fetched'
