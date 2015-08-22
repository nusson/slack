Router.route '/', ->
  this.render 'home'
  SEO.set { title: "Home - #{Meteor.App.NAME}" }


Router.route '/map', ->
  this.render 'map'
  SEO.set { title: "Map - #{Meteor.App.NAME}" }


Router.plugin 'ensureSignedIn',
  only: ['map']
  # except: _.pluck(AccountsTemplates.routes, 'name').concat(['home', 'contacts'])
