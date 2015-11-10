# Todo List App Built on Rails Lite
Rails Lite is a custom backend framework that mimic rails framework.
It consists of two parts, Active Record Lite and Rails Lite Controller.

## What's available
### ActiveRecord Lite
An ORM that provides and API to manipluate relational database logic.
Here are the macros available:

- has_many
- belongs_to
- has_one_through

Here's an example of how to use it:
```
class Task < SQLObject
  belongs_to :user

  finalize!
end
```

There are a few methods that provides interface with the database:

- find
- find_by
- where
- all
- first
- last
- size
- each
... (Since the result returned from query is an array like object, you
may use any of the array instance methods in ruby. This is enabled by ruby
metaprogramming)
- create
- update
- destroy (coming soon)

### Rails Lite Controller
This part includes router, view rendering, flash messages, and session API.
And you can use them as if you use Rails! Here's an example of the user
controller.
```
class UsersController < ApplicationController
  def index
    @users = User.all

    render :index
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(username: params[:user][:username])
    @user.password = params[:user][:password]

    if @user.save
      redirect_to "/user/#{@user.id}"
    else
      flash.now["errors"] = "Oops... Something has gone wrong."
      render :new
    end
  end
end
```

## A peek under the hood
### Structure
```
-rails_lite
	|-app						# Todo list app
		|-assets				# Bootstrap stylesheet
		|-controllers				# Controller logics
		|-models				# Models that utilizes ActiveRecord Lite ORM
		|-views					# ERB templates
	|-bin						# Use this server script to fire up the server
	|-lib						# All the Rails Lite Logics
		|-active_record_lite			# ORM is here
			|-association			# Association logic
				|-assoc_options.rb
				|-associatable.rb
			|-relationable.rb		# Relation class that enables lazy chaining
			|-searchable.rb			# Where clause module
			|-sql_object.rb			# Core ORM logics
		|-builder.rb				# View builder that enables template yielding
		|-controller_base.rb			# Core controller logic
		|-controller_macro.rb			# helper_method macro
		|-db_connection.rb			# As it's named, this sets up connection to databse
		|-flash.rb				# Flash messages logic
		|-params.rb				# Params parser
		|-rails_lite_base.rb			# Loads all the components
		|-router.rb				# Router logic
		|-session.rb				# Session API logic
	|-Gemfile
	|-server.rb					# Router config
	|-todo_app.sql					# Sqlite database
```

## Fire up the app
- Download the repo to your local machine
- Run bundle to install gems
- In the root directory of this project, run ruby server.rb
- Go to `localhost:3000/signup` to sign up a new user
- Login, you will be good to go