Router.route '/', ->
  this.render 'home'
  SEO.set { title: "Home - #{Meteor.App.NAME}" }


Router.route '/map', ->
  this.render 'map'
  SEO.set { title: "Map - #{Meteor.App.NAME}" }

Router.route '/user/:_id', ->
  this.render 'user',
    data:->
      # user  = Meteor.user() # you
      user  = Meteor.users.findOne this.params._id
      # Here can lock access to others or not
      console.log 'user : ', user
      user
  SEO.set { title: "User - #{Meteor.App.NAME}" }


Router.plugin 'ensureSignedIn',
  only: ['map']
  # except: _.pluck(AccountsTemplates.routes, 'name').concat(['home', 'contacts'])
