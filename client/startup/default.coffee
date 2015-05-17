Meteor.startup ->
  setTimeout ->
    # console.clear()
    $(".button-collapse").sideNav()
  , 1000
  console.log($(".button-collapse"));