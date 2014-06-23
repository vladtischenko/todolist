describe "Views.Todos.TodoItem", ->
  view = todo = el = tasks = {}

  beforeEach ->
    setFixtures("<div id='todo'></div>")
    todo = new Todolist.Models.Todo
    tasks = new Todolist.Collections.Tasks
    view = new Todolist.Views.TodosItem(model: todo, collection: tasks)

    allCompleteView = new Todolist.Views.AllComplete(collection: tasks)
    allCompleteView.render()

    footerView = new Todolist.Views.Footer(collection: tasks)
    footerView.render()

    el = $(view.el)

  afterEach ->
    tasks = []

  it "is contained 'div' by default element", ->
    expect(view.el.nodeName).toEqual('DIV')

  describe "rerender index template", ->
    it "has checkbox 'mark all as complete'", ->
      view.render()
      expect(el).toContain('input#complete')

    it "has tasks count", ->
      view.render()
      expect(el).toContain('#task-count')

    describe "when task is not present", ->
      it "does not contain task name", ->
        view.render()
        expect(el).toContain('input#add-task')
        expect(el).not.toContain('#task-text')

  describe "collection bind events", ->
    it "rerenders collection when it changes", ->
      view.render()
      expect(el).not.toContain('#task-name')
      task = new Todolist.Models.Task
      task.url = '/tasks'
      task.set({text: 'some text', complete: false, priority: 1, todo_id: todo.get('id')}).save()
      tasks.add(task)
      expect(el).toContain('#task-text')

    it "rerenders todo when model field priority changes", ->
      view.render()
      task1 = new Todolist.Models.Task
      task2 = new Todolist.Models.Task
      task1.url = '/tasks'
      task2.url = '/tasks'
      task1.set({text: 'some text1', complete: false, priority: 1, todo_id: todo.get('id')}).save()
      task2.set({text: 'some text2', complete: false, priority: 2, todo_id: todo.get('id')}).save()
      tasks.add(task1)
      tasks.add(task2)
      task1.set({priority: 2}).save()
      task2.set({priority: 1}).save()
      expect(task1.get('priority')).toEqual(2)
      expect(task2.get('priority')).toEqual(1)

    it "rerenders todo when add new task", ->
      view.render()
      expect(el).not.toContain('#task-text')
      task = new Todolist.Models.Task
      task.url = '/tasks'
      task.set({text: 'some text', complete: false, priority: 1, todo_id: todo.get('id')}).save()
      tasks.add(task)
      expect(el).toContain('#task-text')

  # describe "model bind events", ->
    # it "display edit field", ->
      # view.render()
      # $('#todo-title').dblclick()
      # expect(el).toContain('#edit-todo')
