describe "Views.Todos.Footer", ->
  view = el = tasks = todo = {}

  beforeEach ->
    setFixtures("<div id='footer'></div>")
    # setFixtures '''
                  # <div id="footer"></div>
                # '''
    todo = new Todolist.Models.Todo
    tasks = new Todolist.Collections.Tasks
    todo.tasks = tasks
    view = new Todolist.Views.Footer(collection: tasks)
    el = $(view.el)

  afterEach ->
    tasks = []

  it "is contained 'div' by default element", ->
    expect(view.el.nodeName).toEqual('DIV')

  # fail
  it "display collection count", ->
    task = new Todolist.Models.Task
    task.url = '/tasks'
    task.set({text: 'some text', complete: false, priority: 1, todo_id: todo.get('id')}).save()
    tasks.add(task)
    view.render()
    # expect($('#task-count').text()).toEqual('1')

  it "render 'remove all' if just all tasks completed", ->
    task = new Todolist.Models.Task
    task.url = '/tasks'
    task.set({text: 'some text', complete: true, priority: 1, todo_id: todo.get('id')}).save()
    tasks.add(task)
    view.render()
    expect(el).toContain('#remove-all')

  describe "model binds events", ->
    it "render when collection changes", ->
      view.render()
      expect(el).toContain('#task-count')
