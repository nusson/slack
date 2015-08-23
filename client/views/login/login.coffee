###*
 * Add some events (like logout)
###
Template.login.events
  'click #at-facebook': (event)->
      event.preventDefault()
      Meteor.loginWithFacebook
        requestPermissions: ['email', 'public_profile', 'user_photos'], # 
          (err)->
            console.log 'fb log', this
            Session.set('errorMessage', err.reason || 'Unknown error') if (err)
      false



# # testing...
# Accounts.onCreateUser (options, user)->
#   console.log('onCreateUser', options, user)
#   if options.profile
#     options.profile.picture = getFbPicture(user.services?.facebook?.accessToken)
#     console.log('get picture and merge', user.profile, options.profile)
#     user.profile = options.profile
#   return user

# getFbPicture = (accessToken)->
#   return null if not accessToken?
#   result = Meteor.http.get "https://graph.facebook.com/me",
#     params: 
#       access_token: accessToken,
#       fields: 'picture'
#   if (result.error)
#     throw result.error
#   console.log('getFbPicture', accessToken, result)
#   return result.data.picture.data.url


Template.login.onCreated ->

  console.log 'login view'

