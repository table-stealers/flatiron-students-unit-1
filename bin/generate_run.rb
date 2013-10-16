require_relative "../config/environment.rb"

scrape = StudentSiteScraper.new("http://students.flatironschool.com")
#array_of_students = scrape.call_scrape

@students = Student.all

gen = SiteGenerator.new
gen.generate