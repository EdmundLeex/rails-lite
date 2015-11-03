# Todo List App Built on Rails Lite
Rails Lite is a custom backend framework that mimic rails framework.
It consists of two parts, Active Record Lite and Rails Lite Controller.

## ActiveRecord Lite
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