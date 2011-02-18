Factory.define :task_type do |t|
  t.is_staff 0
  t.name "Task name"
  t.is_student 1
  t.description "Task description"
end