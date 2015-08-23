###*
 * Override click to add permissions
###
Template.atForm.events
  'click #at-facebook': (event)->
    event.preventDefault()
    console.log 'click'
    Meteor.loginWithFacebook
      requestPermissions: ['email', 'public_profile', 'user_photos'], # 
        (err)-> Session.set('errorMessage', err.reason || 'Unknown error') if (err)
    false
