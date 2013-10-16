class StudentSiteScraper
  attr_accessor :index, :index_link

  @@index_link = "http://students.flatironschool.com/"

  def initialize(url)
    @url = url
  end

    def call_scrape 
    self.set_index
    scrape_student_links
    scrape_student_profile
    @profiles
  end 

#======== Scrape set up ========#
  def set_index
    @index = Nokogiri::HTML(open(@url))
  end

  def scrape_student_links
    @student_url = @index.css("div.home-blog a").collect do |link|
      "http://students.flatironschool.com/" + "#{link.attr("href")}"
    end
    @student_url.uniq!
  end

end

