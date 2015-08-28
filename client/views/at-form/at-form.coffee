###*
 * Override click to add permissions
###

###*
 * Hack to ask more permitions
###
Template.atForm.events
  'click #at-facebook': (event)->
    event.preventDefault()
    Meteor.loginWithFacebook
      requestPermissions: ['email', 'public_profile', 'user_photos'], # 
        (err)-> Session.set('errorMessage', err.reason || 'Unknown error') if (err)
    false
