###*
 * Add some events (like logout)
###
Template.login.events
  'click #at-facebook': (event)->
      event.preventDefault()
      Meteor.loginWithFacebook
        requestPermissions: ['email', 'public_profile', 'user_photos'], # 
          (err)-> Session.set('errorMessage', err.reason || 'Unknown error') if (err)
      false

Template.login.onCreated ->

  console.log 'login view'

