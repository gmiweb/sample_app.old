# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  micropost = $('#micropost_content')
  micropost.keyup ->
    used = micropost.val().length
    lbl = $('#chars_remaining')
    lbl.text(140 - used + " characters remaining.")




