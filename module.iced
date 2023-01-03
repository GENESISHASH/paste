_ = require('wegweg')(globals:on,shelljs:on)
Browser = require('zombie')

if !which('share')
  throw new Error 'bin/share not found'

file = process.argv.pop()

if !file or !_.exists(file) or !_.is_file(file)
  throw new Error 'file_noexists', file

await exec """
  gh gist create #{file}
""", {async:yes,silent:on}, defer e,r

gist_url = false
lines = r.split '\n'
for x in lines
  if x.startsWith('http')
    gist_url = x.trim()

if !gist_url
  throw new Error 'gist_url_not_found'

b = new Browser()

b.visit gist_url, ->
  b.evaluate(_.reads(__dirname + '/inc/script.js'))
  b.wait ->
    parts = ["""
      <style>
        body{margin-top:10px!important;margin-bottom:10px!important;}
        .Box-body{border-bottom:0!important;}
      </style>
    """]
    parts.push """<style>#{_.reads(__dirname + '/inc/css.min.css')}</style>"""
    parts.push b.evaluate('window._data')

    bulk = parts.join '\n'

    _.writes (file = "/tmp/#{_.uuid()}.gist.html"), bulk

    await exec """
      #{which('share')} #{file}
    """, {async:true,silent:true}, defer e,r
    if e then throw e

    log r.trim()
    process.exit 0

