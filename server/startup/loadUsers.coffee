loadUser = (user) ->
  userAlreadyExists = typeof Meteor.users.findOne(username: user.username) == 'object'
  if !userAlreadyExists
    Accounts.createUser user
  return

Meteor.startup ->
  users = YAML.eval(Assets.getText('users.yml'))
  for key of users
    if users.hasOwnProperty(key)
      loadUser(users[key])
  Chekins = new (Mongo.Collection)('checkins')
  Chekins.allow 'insert': (userId, doc) ->

    ### user and doc checks ,
    return true to allow insert 
    ###

    true
  Meteor.publish 'checkins', ->
    Chekins.find()
  return


Accounts.onCreateUser (options, user)->
  # Checkout https://github.com/meteor-utilities/avatar
  picture = 'http://api.adorable.io/avatars/200/'+user._id+'.png'
  if user.services?.facebook?.id
    # getFbPicture user.services?.facebook?.accessToken
    picture = "http://graph.facebook.com/" + user.services.facebook.id + "/picture/?type=large"

  user.profile = _.extend {}, options?.profile,
    picture:  picture
    services: user.services

  # user.username = user.username or user.name.toLowerCase()


  return user

getFbPicture = (accessToken)->
  return null if not accessToken?
  result = Meteor.http.get "https://graph.facebook.com/me",
    params: 
      access_token: accessToken,
      fields: 'picture'
  if (result.error)
    throw result.error
  console.log('getFbPicture', accessToken, result)
  return result.data.picture.data.url
