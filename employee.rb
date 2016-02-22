require 'active_record'
require './department'

class Employee < ActiveRecord::Base
  belongs_to :department

end
