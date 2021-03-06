class Todolist.Views.TodosItem extends Backbone.View

  template: JST['todos/item']
  events:
    'click #remove-todo'  : 'removeTodo'
    'click #complete'     : 'setAllComplete'
    'click #remove-all'   : 'removeAll'
    'keypress #add-task'  : 'createOnEnter'
    'click #all-complete' : 'render'
    'mousedown .todo'     : 'cut'
    'mouseup .todo'       : 'release'
    'mouseover .todo'     : 'over'
    'mouseout .todo'      : 'out'
    'dblclick #todo-title': 'editTodo'
    'keypress #edit-todo' : 'editOnEnter'
    'blur #edit-todo'     : 'render'


  initialize: ->
    @collection.bind 'add', @addTask, @
    @collection.bind 'add', @renderFooter, @
    @collection.bind 'add', @renderAllComplete, @
    @collection.bind 'remove', @render, @
    @collection.bind 'change:priority', @render, @
    @collection.bind 'change:complete', @renderFooter, @
    @collection.bind 'change:complete', @renderAllComplete, @
    @collection.bind 'change:file_for_task', @render, @
    @model.bind 'destroy', @remove, @
    @model.bind 'destroy', @render, @
    @model.bind 'change', @render, @

  model_id = null

  render: ->
    $(@el).html(@template(todo: @model))
    @getContent()
    @

  renderAllComplete: ->
    allCompleteView = new Todolist.Views.AllComplete collection: @collection
    @$('#all-complete').html(allCompleteView.render().el) 

  renderFooter: ->
    footerView = new Todolist.Views.Footer collection: @collection
    @$('#footer').html(footerView.render().el) 

  over: ->
    return unless model_id
    return if model_id == @model.get('id')
    @$el.addClass('todo-hover')

  out: ->
    @$el.removeClass('todo-hover')

  cut: (e) ->
    id = e.target.id
    return if id.substring(0, 5) == 'task_'
    return if id == 'complete' or id == 'add-task' or
      id == 'task-text' or id == 'complete-task' or
      id == 'remove-task' or id == 'remove-todo' or
      id == 'edit-todo' or id == 'remove-all'or
      id == 'title-todo' or id == 'task-complete' or
      id == 'task-remove' or id == 'edit-task' or 
      id == 'fileupload' or id == 'submit' or
      id == 'remove-image' or id == 'mini-image' or
      id == 'icon-image' or id == 'image' or
      id =='complete-icon' or id == 'remove-icon' or
      id == 'remove-todo-icon' or id == 'remove-img'
    @$el.addClass('keypress-todo')
    model_id = @model.get('id')

  release: ->
    @$el.removeClass('keypress-todo')
    return unless model_id
    if @model.get('id') == model_id
      model_id = null
      return
    @model.drag(model_id, @model.get('id'))
    model_id = null

  removeTodo: ->
    @model.changePriority(@model.get('id'))
    @model.destroy()

  removeAll: ->
    model = null
    while(model = @collection.first())
      model.destroy()

  setAllComplete: ->
    if @$('#complete').prop("checked")
      @collection.each (task) =>
        task.set({complete: true}).save()
    else
      @collection.each (task) =>
        task.set({complete: false}).save()

  createOnEnter: (event) ->
    return if event.keyCode != 13
    if @collection.length == 0
      @collection.create({text: @$('#add-task').val(), complete: false, todo_id: @model.get('id'), priority: 1})
    else
      @collection.create({text: @$('#add-task').val(), complete: false, todo_id: @model.get('id'), priority: @collection.last().get('priority') + 1})
    @$('#add-task').val('')
    @$('#add-task').attr('autofocus', true)

  addTask: (task) ->
    view = new Todolist.Views.TasksItem model: task
    @$('#tasks').prepend(view.render().el)
    @

  editTodo: ->
    $(@el).html(@template({flag: true, todo: @model}))
    @getContent()
    @$('#edit-todo').val(@model.get 'title')
    @

  editOnEnter: (event) ->
    return if event.keyCode != 13
    @model.set({title: @$('#edit-todo').val()}).save()
    $(@el).html(@template(todo: @model))

  getContent: ->
    allCompleteView = new Todolist.Views.AllComplete collection: @collection
    @$('#all-complete').html(allCompleteView.render().el)

    footerView = new Todolist.Views.Footer collection: @collection
    @$('#footer').html(footerView.render().el)

    @collection.sort()
    @collection.each (task) =>
      view = new Todolist.Views.TasksItem model: task
      @$('#tasks').prepend(view.render().el)
