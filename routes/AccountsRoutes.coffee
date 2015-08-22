AccountsTemplates.configureRoute 'signIn',
  name: 'signin'
  path: '/login'
  template: 'login'
  layoutTemplate: 'basicLayout'
  redirect: ->
    user = Meteor.user()
    if (user)
      console.log(user)
      Router.go('/user/' + user._id)

AccountsTemplates.configureRoute 'ensureSignedIn',
  template: 'user-only'
  layoutTemplate: 'basicLayout'

    
ServiceConfiguration.configurations.upsert
  service: 'facebook',
    $set:
      appId:      '793433544088803'
      loginStyle: 'popup'
      secret:     'ed61a2f63ceda6f48406a90d5df1e890'
