require './migration'
require './employee'
require './department'

EmployeeMigration.migrate(:up)
