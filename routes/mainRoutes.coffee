Router.route '/', ->
  this.render 'home'
  SEO.set { title: "Home - #{Meteor.App.NAME}" }


Router.route '/map', ->
  this.render 'map'
  SEO.set { title: "Map - #{Meteor.App.NAME}" }
