class Todolist.Routers.Todos extends Backbone.Router
  routes:
    '': 'index'

  index: ->
    todos = new Todolist.Collections.Todos
    new Todolist.Views.TodosIndex collection: todos
    todos.fetch()
    