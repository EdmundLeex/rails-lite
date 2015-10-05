class Task < SQLObject
  belongs_to :user

  finalize!
end