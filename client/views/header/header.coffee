Template.header.onRendered ->

  # Hamburger menu
  $(".button-collapse").sideNav
    closeOonClick: true
  $('.side-nav a').on 'click', (event)->
    $('.button-collapse').sideNav('hide');
