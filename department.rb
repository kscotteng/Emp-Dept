require './employee'
require 'active_record'

class Department < ActiveRecord::Base
  has_many :employees


end
