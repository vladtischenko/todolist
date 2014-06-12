class Todolist.Collections.Tasks extends Backbone.Collection
  url: '/tasks'
  model: Todolist.Models.Task

  comparator: (task) ->
    task.get('priority')
