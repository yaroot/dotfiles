// ==UserScript==
// @name        trello
// @namespace   bg-trello
// @include     https://trello.com/*
// @version     1
// @grant       none
// ==/UserScript==


$(function() {
  var body = $('body')[0]
  var bgColor = '#068'
  setInterval(function() {
    if (body.style.backgroundColor != bgColor) {
      body.style.backgroundColor = bgColor
    }
  }, 2000)
})
