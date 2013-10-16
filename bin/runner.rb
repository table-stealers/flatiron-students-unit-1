require_relative '../config/environment.rb'

scrape = StudentSiteScraper.new("http://students.flatironschool.com")
array_of_students = scrape.call_scrape

# students = array_of_students.map do |s|
#   Student.new(s)
# end

interface = CLIStudent.new(Student.all)
interface.call
