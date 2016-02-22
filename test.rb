require 'minitest/autorun'
require 'minitest/pride'
require 'active_record'
require './employee'
require './department'
require './migration'
require 'byebug'


ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.sqlite3'
)


class ReviewTest < Minitest::Test

  def setup
  	begin EmployeeMigration.migrate(:up); rescue; end
  end

  def teardown
    EmployeeMigration.migrate(:down)
  end

  def test_truth
    assert true
  end

  def test_classes_exist
    assert Department
    assert Employee
  end

  def test_create_new_department
    d = Department.new(name: "Engineering")
    assert d
    assert_equal "Engineering", d.name
  end

  def test_create_new_employee
    e = Employee.new(name: "John Doe", email: "jdoe@gmail.com", phone: "123.456.7890", salary: 120000)
    assert e
    assert_equal "John Doe", e.name
    assert_equal "jdoe@gmail.com", e.email
    assert_equal "123.456.7890", e.phone
    assert_equal 120000, e.salary
  end

  def test_add_employee_to_department
    d = Department.new(name: "Engineering")
    new_employee = Employee.new(name: "John Doe", email: "jdoe@gmail.com", phone: "123.456.7890", salary: 120000)
    d.employees << new_employee
    assert_equal [new_employee], d.employees
  end

  def test_get_an_employees_name
    en = Employee.new(name: "Fred")
    assert_equal "Fred", en.name
  end

  def test_get_an_employees_salary
    es = Employee.new(salary: 125000)
    assert_equal 125000, es.salary
  end

  def test_can_get_a_department_name
    new_dept = Department.new(name: "Production")
    assert_equal "Production", new_dept.name
  end

  def test_get_total_salary_for_a_department
    d1 = Department.new(name: "Engineering")
    e1 = Employee.new(salary: 100000)
    e2 = Employee.new(salary: 125000)
    e3 = Employee.new(salary: 75000)
    d1.employees << e1
    d1.employees << e2
    d1.employees << e3
    a = []
    d1.employees.each do |i|
      a << i.salary
    end
    salary_sum = a.inject { |sum, n| sum + n }
    assert_equal 300000, salary_sum
  end

  def test_add_review_text_to_employee
    er = Employee.new(review: "Xavier is a huge asset to SciMed and is a pleasure to work with.
      He quickly knocks out tasks assigned to him, implements code that rarely needs to be revisited,
      and is always willing to help others despite his heavy workload.  When Xavier leaves on vacation,
      everyone wishes he didn't have to go.
      Last year, the only concerns with Xavier performance were around ownership.  In the past twelve months,
      he has successfully taken full ownership of both Acme and Bricks, Inc.  Aside from some false starts with estimates on Acme,
      clients are happy with his work and responsiveness, which is everything that his managers could ask for.")
    assert er.review
  end

  def test_emp_satisfactory_or_not_satisfactory
    es = Employee.new(satisfactory: true)
    assert_equal true, es.satisfactory
  end

  def test_give_indiviual_raise
    er = Employee.new(name: "Johne Doe", salary: 100000)
    raise_percentage = 0.10
    assert_equal 110000, ((er.salary * raise_percentage) + er.salary)
  end

  def test_raises_to_one_departments_employees
    dr = Department.new(name: "Engineering")
    de1 = Employee.new(name: "John Doe", salary: 100000)
    de2 = Employee.new(name: "John Smith", salary: 125000)
    de3 = Employee.new(name: "John Wick", salary: 250000)
    department_raise_percentage = 0.10
    dr.employees << de1
    dr.employees << de2
    dr.employees << de3
    a = []
    dr.employees.each do |i|
      a << i.salary
    end
    assert_equal 110000, ((de1.salary * department_raise_percentage) + de1.salary)
    assert_equal 137500, ((de2.salary * department_raise_percentage) + de2.salary)
    assert_equal 275000, ((de3.salary * department_raise_percentage) + de3.salary)
  end

  def test_distribute_department_raise_sum_amount_reasonably_among_employees
    d = Department.new(name: "Engineering")
    de1 = Employee.new(name: "John Doe", salary: 100000)
    de2 = Employee.new(name: "John Smith", salary: 125000)
    de3 = Employee.new(name: "John Wick", salary: 250000)
    d.employees << de1
    d.employees << de2
    d.employees << de3
    a = []
    d.employees.each do |i|
      a << i.salary
    end
    salary_sum = a.inject { |sum, n| sum + n }
    dept_raise_sum = salary_sum * 0.10
    de1_dept_salary_ratio = de1.salary / salary_sum
    de2_dept_salary_ratio = de2.salary / salary_sum
    de3_dept_salary_ratio = de3.salary / salary_sum
    de1_raise_amt = de1_dept_salary_ratio * dept_raise_sum
    de2_raise_amt = de2_dept_salary_ratio * dept_raise_sum
    de3_raise_amt = de3_dept_salary_ratio * dept_raise_sum
    de1.salary = de1.salary + de1_raise_amt
    de2.salary = de2.salary + de2_raise_amt
    de3.salary = de3.salary + de3_raise_amt
    assert_equal 110000, de1.salary
    assert_equal 137500, de2.salary
    assert_equal 275000, de3.salary
  end

  def test_employee_performance_satisfactory_raises
    d = Department.new(name: "Engineering")
    e1 = Employee.new(name: "John Doe", salary: 100000, satisfactory: true)
    e2 = Employee.new(name: "John Smith", salary: 125000, satisfactory: false)
    e3 = Employee.new(name: "John Wick", salary: 250000, satisfactory: true)
    emp_satifactory_performance_raise = 0.10


    # if e1.satisfactory == true
    #   e1.salary = ((e1.salary * emp_satifactory_performance_raise) + e1.salary)
    # elsif
    #   e2.satisfactory == true
    #   e2.salary = ((e2.salary * emp_satifactory_performance_raise) + e2.salary)
    # elsif
    #   e3.satisfactory == true
    #   e3.salary = ((e3.satisfactory * emp_satifactory_performance_raise) + e3.salary)
    # end
    # puts e1.salary
    # puts e2.salary
    # puts e3.salary

  end
end
