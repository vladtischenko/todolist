describe "Views.Todos.AllComplete", ->
  view = todo = el = {}

  beforeEach ->
    setFixtures("<div id='all-complete'></div>")
    todo = new Todolist.Models.Todo
    tasks = new Todolist.Collections.Tasks
    todo.tasks = tasks
    view = new Todolist.Views.AllComplete(collection: tasks)
    el = $(view.el)

  afterEach ->
    tasks = []

  it "is contained 'div' by default element", ->
    expect(view.el.nodeName).toEqual('DIV')

  describe "display elements", ->
    it "show checkbox", ->
      view.render()
      expect(el).toContain("input#complete")    

    it "show label 'mark all complete'", ->
      view.render()
      expect(el).toContain("#mark_all")
