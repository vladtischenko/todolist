class Todolist.Collections.Todos extends Backbone.Collection
  url: '/todos'
  model: Todolist.Models.Todo

  comparator: (todo) ->
    todo.get('priority')
