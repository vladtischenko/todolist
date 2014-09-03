class Todolist.Models.Task extends Backbone.Model

  setFromFile: (file) ->
    reader = new FileReader()
    self = @
    reader.onload = (
      (e) ->
        self.save({file_for_task: e.target.result, name: file.name})
      )
    reader.readAsDataURL(file)

  changePriority: (todo_id, model_id) ->
    tasks = new Todolist.Collections.Tasks
    @collection.models.filter (model) ->
      tasks.add(model) if todo_id == model.get('todo_id')
    
    current_task = tasks.findWhere(id: model_id)
    current_priority = current_task.get('priority')

    task_priorities = []
    tasks.each (task) =>
      task_priorities.push(task.get('priority'))

    tasks_to_change_priority = []
    tasks_to_change_priority = _.filter(task_priorities, (priority) ->
      priority > current_priority)

    current_tasks = new Todolist.Collections.Tasks
    for priority in tasks_to_change_priority
      current_tasks.add(tasks.findWhere(priority: priority))

    current_tasks.each (task) =>
      task.set({priority: task.get('priority') - 1}).save()


  drag: (todo_id, first_id, second_id) ->
    tasks = new Todolist.Collections.Tasks
    @collection.models.filter (model) ->
      tasks.add(model) if todo_id == model.get('todo_id')

    first_task = @collection.findWhere(id: first_id)
    second_task = @collection.findWhere(id: second_id)

    priority_first = first_task.get 'priority'
    priority_second = second_task.get 'priority'

    return if priority_first == priority_second

    task_priorities = []
    tasks.each (task) =>
      task_priorities.push(task.get('priority'))

    middle_task_priorities = []
    if priority_first < priority_second 
      middle_task_priorities = _.filter(task_priorities, (priority) -> 
        priority > priority_first && priority < priority_second
        )
    else
      middle_task_priorities = _.filter(task_priorities, (priority) ->
        priority < priority_first && priority > priority_second
        )

    current_tasks = new Todolist.Collections.Tasks
    for priority in middle_task_priorities
      current_tasks.add(tasks.findWhere(priority: priority), {sort: false})

    if priority_first < priority_second
      current_tasks.each (task) =>
        task.set({priority: task.get('priority') - 1}).save()
      first_task.set({priority: second_task.get('priority')}).save()
      second_task.set({priority: second_task.get('priority') - 1}).save()
    else
      current_tasks.each (task) =>
        task.set({priority: task.get('priority') + 1}).save()
      first_task.set({priority: second_task.get('priority')}).save()
      second_task.set({priority: second_task.get('priority') + 1}).save()
