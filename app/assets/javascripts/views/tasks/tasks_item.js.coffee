class Todolist.Views.TasksItem extends Backbone.View

  template: JST['tasks/item']
  events:
    'click #remove-task'  : 'removeTask'
    'click #complete-task': 'toggleComplete'
    'dblclick #task-text' : 'editTask'
    'keypress #edit-task' : 'editOnEnter'
    'blur #edit-task'     : 'render'
    'mousedown #task'     : 'cut'
    'mouseup #task'       : 'release'
    'mouseover #task'     : 'over'
    'mouseout #task'      : 'out'


  model_id = null
  todo_id = null
    
  initizlize: ->
    @model.bind 'destroy', @remove, @
    @model.bind 'change', @render, @

  render: ->
    $(@el).html(@template(task: @model))
    @

  over: ->
    unless model_id and todo_id
      @$el.addClass('over-task')
    else
      # return unless model_id and todo_id
      return if model_id == @model.get('id')
      return unless todo_id == @model.get('todo_id')
      @$el.addClass('task-hover')

  out: ->
    @$el.removeClass('over-task')
    @$el.removeClass('task-hover')

  cut: (e) ->
    id = e.target.id
    return if id == 'task-complete' or id == 'complete-task' or
      id == 'task-remove' or id == 'remove-task' or id == 'edit-task' or id == 'task-text'
    @$el.removeClass('over-task')
    @$el.addClass('keypress-task')
    model_id = @model.get('id')
    todo_id = @model.get('todo_id')

  release: ->
    @$el.removeClass('keypress-task')
    unless @model.get('todo_id') == todo_id
      model_id = todo_id = null
      return
    if model_id == @model.get('id')
      model_id = todo_id = null
      return 
    @model.drag(@model.get('todo_id'), model_id, @model.get('id'))
    model_id = todo_id = null

  removeTask: ->
    @model.changePriority(@model.get('todo_id'), @model.get('id'))
    @model.destroy()

  toggleComplete: ->
    @model.set({complete: !@model.get('complete')}).save()
    $(@el).html(@template(task: @model))
    @

  editTask: ->
    $(@el).html(@template({flag: true, task: @model}))
    @$('#edit-task').val(@model.get 'text')
    @

  editOnEnter: (event) ->
    return if event.keyCode != 13
    @model.set({text: @$('#edit-task').val()}).save()
    $(@el).html(@template(task: @model))
