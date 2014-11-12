// ==UserScript==
// @name        trello
// @namespace   bg-trello
// @include     https://trello.com/*
// @version     1
// @grant       none
// ==/UserScript==


$(function() {
  var body = window.document.body
  var colour = '#057'
  setInterval(function() {
    if(body.style.backgroundColor !== colour) {
      body.style.backgroundColor = colour
    }
    // console.log("setting text")
  }, 2000)
})
