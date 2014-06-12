class Todolist.Views.AllComplete extends Backbone.View

  template: JST['todos/all_complete']

  initialize: ->

  render: ->
    count = @collection.where({complete: true}).length
    if count == @collection.length
      $(@el).html(@template({all: true}))
      @
    else
      $(@el).html(@template({all: false}))
      @