###*
 * Add some events (like logout)
###
Template.header.events
  'click .logout': (event)->
      event.preventDefault()
      Meteor.logout()
      Router.go('/')
  'click .side-nav a': (event)->
    $('.button-collapse').sideNav('hide')


###*
 * Initialisation
###
Template.header.onRendered ->

  # Hamburger menu
  $(".button-collapse").sideNav
    closeOonClick: true
