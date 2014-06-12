class Todolist.Views.Footer extends Backbone.View
  
  template: JST['todos/footer']
  
  initialize: ->

  render: ->
    remaining = @collection.where({complete: false}).length
    $(@el).html(@template({remaining: remaining, size: @collection.length}))
    @