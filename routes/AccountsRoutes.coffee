AccountsTemplates.configure
  forbidClientAccountCreation:  false
  showForgotPasswordLink:       true

AccountsTemplates.configureRoute 'signIn',
  # name: 'signin'
  # path: '/login'
  redirect: ->
    user = Meteor.user()
    if (user)
      Router.go('/user/' + user._id)

AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'
AccountsTemplates.configureRoute 'resendVerificationEmail'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'
AccountsTemplates.configureRoute 'forgotPwd'

AccountsTemplates.configureRoute 'ensureSignedIn',
  template: 'user-only'
  layoutTemplate: 'basicLayout'

    
ServiceConfiguration.configurations.upsert
  service: 'facebook',
    $set:
      appId:      '793433544088803'
      loginStyle: 'popup'
      secret:     'ed61a2f63ceda6f48406a90d5df1e890'
