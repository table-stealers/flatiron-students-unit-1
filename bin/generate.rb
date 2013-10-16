require_relative "../config/environment.rb"
class SiteGenerator

  def generate
    scrape = StudentSiteScraper.new("http://students.flatironschool.com")
    array_of_students = scrape.call_scrape

    index = ERB.new(File.open('lib/views/index.erb').read)

    File.open('_site/index.html', 'w+') do |f|
      f << index.result
    end

    student_show = ERB.new(File.open('lib/views/show.erb').read)

    Student.all.each do |student|
      File.open("_site/#{student.rel_url}", 'w+') do |f|
        f << student_show.result(binding)
      end
    end
  end

end