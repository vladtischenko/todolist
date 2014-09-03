class Todolist.Views.TodosIndex extends Backbone.View
  el: '#app'
  template: JST['todos/index']
  events:
    'keypress #add-todo' : 'createOnEnter'

  initialize: ->
    @collection.fetch({reset: true})
    # @collection.bind 'add', @addTodo, @
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @

  tasks_by_todo: (all_tasks, todo) ->
    tasks = new Todolist.Collections.Tasks
    # all_tasks.fetch().complete ->
    all_tasks.models.filter (model) ->
      tasks.add(model) if todo.get('id') == model.get('todo_id')
    tasks

  render: ->
    $(@el).html(@template())

    all_tasks = new Todolist.Collections.Tasks
    all_tasks.fetch({async:false})

    @collection.sort()
    @collection.each (todo) =>
      tasks = @tasks_by_todo(all_tasks, todo)
      view = new Todolist.Views.TodosItem model: todo, collection: tasks
      @$('#todos').prepend(view.render().el)

    @$('#add-todo').attr('autofocus', true) if @collection.size() == 0
    @

  createOnEnter: (event) ->
    return if event.keyCode != 13
    if @collection.length == 0
      @collection.create({title: @$('#add-todo').val(), priority: 1})
    else
      @collection.create({title: @$('#add-todo').val(), priority: @collection.last().get('priority') + 1})
    @$('#add-todo').val('')

  # addTodo: (todo) ->
    # view = new Todolist.Views.TodosItem model: todo
    # @$('#todos').prepend(view.render().el)
    # @
