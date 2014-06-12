describe "Views.Footer", ->
  view = el = tasks = {}

  beforeEach ->
    setFixtures '''
                 <div id='footer'></div>
               '''
    tasks = new Todolist.Collections.Tasks
    view = new Todolist.Views.Footer(collection: tasks)
    # el = $(view.el)

  afterEach ->
    tasks = []

  # it "is contained 'div' by default element", ->
    # expect(view.el.nodeName).toEqual('DIV')