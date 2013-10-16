require_relative "../config/environment.rb"
class SiteGenerator

  def generate
    index = ERB.new(File.open('lib/views/index.erb').read)

    File.open('_site/index.html', 'w+') do |f|
      f << index.result
    end

    student = ERB.new(File.open('lib/views/show.erb').read)

    File.open("_site/students/#{student.name.gsub(' ', '_')}.html", 'w+') do |f|
      f << student.result
    end

  end

end