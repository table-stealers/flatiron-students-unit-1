require_relative '../../config/environment.rb'
require 'pry'
class StudentSiteScraper
  attr_accessor :index, :index_link

  @@index_link = "http://students.flatironschool.com/"

  def initialize(url)
    @url = url
  end

    def call_scrape 
    self.set_index

    student_url = scrape_student_links
    student_info = scrape_student_index_info

    student_url.zip(student_info).each do |student_link, student_info| 
      student_scraper = StudentScraper.new(student_link, student_info)
      student_scraper.scrape_student_profile
    end
  end 

#======== Scrape set up ========#
  def set_index
    @index = Nokogiri::HTML(open(@url))
  end

  def scrape_student_index_info
    @index.css('li.home-blog-post').collect do |student_root|
      {}.tap do |hash|
        hash[:index_pic] = student_root.css('img.prof-image').attr('src').value
        hash[:tag_line] = student_root.css('p.home-blog-post-meta').text
        hash[:excerpt] = student_root.css('div.excerpt p').text
      end
    end
  end

  def scrape_student_links
    @student_url = @index.css("div.home-blog a").collect do |link|
      "http://students.flatironschool.com/" + "#{link.attr("href")}"
    end
    @student_url.uniq!
  end

end

