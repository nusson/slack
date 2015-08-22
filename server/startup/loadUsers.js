function loadUser(user) {
  var userAlreadyExists = typeof Meteor.users.findOne({ username : user.username }) === 'object';

  if (!userAlreadyExists) {
    Accounts.createUser(user);
  }
}

Meteor.startup(function () {
  var users = YAML.eval(Assets.getText('users.yml'));

  for (key in users) if (users.hasOwnProperty(key)) {
    loadUser(users[key]);
  }

  Chekins = new Mongo.Collection('checkins');

  Chekins.allow({
    'insert': function (userId, doc) {
      /* user and doc checks ,
      return true to allow insert */
      return true; 
    }
  });
  Meteor.publish("checkins", function () {
    return Chekins.find();
  });
});