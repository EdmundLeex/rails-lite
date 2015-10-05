class Task < SQLObject
  belongs_to :humans

  finalize!
end