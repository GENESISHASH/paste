_ = require('wegweg')(globals:on)
Browser = require('zombie')

b = new Browser()

url = 'https://gist.github.com/GENESISHASH/16474a00bc4daa06b56ea5c4eb50b7b7'
url = 'https://gist.github.com/BilboTheGreedy/dcd1f0d687095cb9e31f25faa6614145'

b.visit url, ->
  b.evaluate(_.reads(__dirname + '/inc/script.js'))
  b.wait (window) ->
    parts = []
    parts.push """<style>body{margin-top:10px!important;margin-bottom:10px!important;}</syle>"""
    parts.push """<style>.Box-body{border-bottom:0!important;}</syle>"""
    parts.push """<style>#{_.reads(__dirname + '/inc/css.min.css')}</syle>"""
    parts.push b.evaluate('window._data')

    bulk = parts.join '\n'
    console.log bulk

