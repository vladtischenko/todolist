class Todolist.Views.TasksItem extends Backbone.View

  template: JST['tasks/item']
  events:
    'click #remove-task'   : 'removeTask'
    'click #complete-task' : 'toggleComplete'
    'click #remove-image'  : 'removeImage'
    'dblclick #task-text'  : 'editTask'
    'keypress #edit-task'  : 'editOnEnter'
    'blur #edit-task'      : 'render'
    'mousedown #task'      : 'cut'
    'mouseup #task'        : 'release'
    'mouseover #task'      : 'over'
    'mouseout #task'       : 'out'
    'click #image'         : 'showImage'
    'click #open-file-area': 'toggleOpenFileArea'
    'change #fileupload'   : 'dispatchUpdatePreview'
    'click #small-text'    : 'showFullText'

  model_id = null
  todo_id = null

  initizlize: ->
    @model.bind 'destroy', @remove, @
    @model.bind 'change', @render, @

  render: ->
    # if @model.get('file_for_task')
      # file_url = @model.get('file_for_task').url if @model.get('file_for_task').url
    # if file
      # tmp = _.last(@model.get('file').url, 3)
      # extension = tmp.toString().replace(/,/, '').replace(',', '')
    # $(@el).html(@template(task: @model, file: file, ext: extension))
    $(@el).html(@template(task: @model))
    @
  
  toggleOpenFileArea: ->
    if @$('#file-area').hasClass('hide')
      @$('#file-area').removeClass('hide')
      @$('#icon-image').removeClass('icon-arrow-down')
      @$('#icon-image').addClass('icon-arrow-up')
    else
      @$('#file-area').addClass('hide')
      @$('#icon-image').removeClass('icon-arrow-up')
      @$('#icon-image').addClass('icon-arrow-down')

  showImage: (e) ->
    @$('#image').magnificPopup({
        items: {src: @model.get('file_for_task').url },
        type:'image'
      })    

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
      id == 'upload_photos' or id == 'task-remove' or
      id == 'remove-task' or id == 'edit-task' or
      id == 'task-text' or id == 'fileupload' or
      id == 'submit' or id == 'remove-image' or
      id == 'mini-image' or id == 'icon-image' or 
      id == 'image' or id =='complete-icon' or
      id == 'remove-icon' or id == 'remove-todo-icon' or id == 'remove-img'
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

  dispatchUpdatePreview: (e) ->
    @model.setFromFile(e.target.files[0])
    $(@el).html(@template(task: @model))
    @

  removeTask: ->
    @model.changePriority(@model.get('todo_id'), @model.get('id'))
    @model.destroy()

  removeImage: ->
    @model.set({file_for_task: null}).save()
    $(@el).html(@template(task: @model))
    @

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
    @
