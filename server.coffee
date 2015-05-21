express = require 'express'
ical = require 'ical-generator'
mustache = require 'mustache-express'
moment = require 'moment'

data = require './data.json'

app = express()

app.engine 'mustache', mustache()

app.set 'view engine', 'mustache'
app.set 'views', __dirname + '/views'

DURATION = moment.duration 3, 'hours'

eventForDate = (date) ->
  date = moment date
  id: date+0
  timestamp: date.toDate()
  start: date.toDate()
  end: date.clone().add(DURATION).toDate()
  summary: 'SydJS'
  location: '6/341 George St, Sydney NSW 2000, Australia'

cal = ical
  domain: 'whenthefuckissydjs.com'
  name: 'SydJS'
  timezone: 'Australia/Sydney'
  events: data.whenthefuckissydjs.map eventForDate

latest = moment(data.whenthefuckissydjs.slice(-1)[0])

format = (date) ->
  diff = date - moment()
  if diff > moment.duration 1, 'week'
    "The fucking #{date.format 'Do'} of #{date.format 'MMMM'}"
  else if diff > moment.duration 18, 'hours'
    "On fucking #{date.format 'dddd'}"
  else if diff > 0
    "It's fucking today!"
  else if -diff < DURATION
    "Right fucking now!"
  else
    "I don't fucking know"

app.get '/', (req, res) -> res.render 'index', when: format latest
app.get '/ical', (req, res) -> cal.serve res

app.listen(process.env.PORT or 4400)
