class Todolist.Models.Todo extends Backbone.Model

  changePriority: (model_id) ->
    current_todo = @collection.findWhere(id: model_id)
    current_priority = current_todo.get('priority')

    todo_priorities = []
    @collection.each (todo) =>
      todo_priorities.push(todo.get('priority'))

    todos_to_change_priority = []
    todos_to_change_priority = _.filter(todo_priorities, (priority) ->
      priority > current_priority)

    todos = new Todolist.Collections.Todos
    for priority in todos_to_change_priority
      todos.add(@collection.findWhere(priority: priority))

    todos.each (todo) =>
      todo.set({priority: todo.get('priority') - 1}).save()

  drag: (first_id, second_id) ->
    first_todo = @collection.findWhere(id: first_id)
    second_todo = @collection.findWhere(id: second_id)

    priority_first = first_todo.get 'priority'
    priority_second = second_todo.get 'priority'

    return if priority_first == priority_second

    todo_priorities = []
    @collection.each (todo) =>
      todo_priorities.push(todo.get('priority'))

    middle_todo_priorities = []
    if priority_first < priority_second 
      middle_todo_priorities = _.filter(todo_priorities, (priority) -> 
        priority > priority_first && priority < priority_second
        )
    else
      middle_todo_priorities = _.filter(todo_priorities, (priority) ->
        priority < priority_first && priority > priority_second
        )

    todos = new Todolist.Collections.Todos
    for priority in middle_todo_priorities
      todos.add(@collection.findWhere(priority: priority), {sort: false})

    if priority_first < priority_second
      todos.each (todo) =>
        todo.set({priority: todo.get('priority') - 1}).save()
      first_todo.set({priority: second_todo.get('priority')}).save()
      second_todo.set({priority: second_todo.get('priority') - 1}).save()
    else
      todos.each (todo) =>
        todo.set({priority: todo.get('priority') + 1}).save()
      first_todo.set({priority: second_todo.get('priority')}).save()
      second_todo.set({priority: second_todo.get('priority') + 1}).save()
