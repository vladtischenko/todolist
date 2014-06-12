class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :new, Todo
    can :create, Todo
    can :index, Todo, user_id: user.id
    can :update, Todo, user_id: user.id
    can :destroy, Todo, user_id: user.id

    cannot :index, Todo, user_id: user.id + 1
    cannot :update, Todo, user_id: user.id + 1
    cannot :destroy, Todo, user_id: user.id + 1
    
    todo = Todo.new(priority: 0, title: 'new todo')
    user.todos << todo

    can :new, Task
    can :create, Task
    can :index, Task, todo_id: todo.id
    can :update, Task, todo_id: todo.id
    can :destroy, Task, todo_id: todo.id

    cannot :index, Task, todo_id: todo.id + 1
    cannot :update, Task, todo_id: todo.id + 1
    cannot :destroy, Task, todo_id: todo.id + 1

    todo.destroy

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
