window.Todolist =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Todolist.Routers.Todos
    Backbone.history.start()

$(document).ready ->
  Todolist.initialize()
