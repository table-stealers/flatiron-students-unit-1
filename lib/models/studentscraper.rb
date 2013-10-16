require_relative '../../config/environment.rb'
class StudentScraper

  def initialize(url)
    @url = url 
  end

  def scrape_student_profile
    begin
      scrape_result = Nokogiri::HTML(open(@url))
    rescue 
    #want to rescue specific errors as much as possible, so we know what's breaking 
    #rescue OpenURI::HTTPError
      return nil
    end
    s = {
      "name" => scrape_name(scrape_result),
      "website" => @url,
      "twitter" => scrape_twitter(scrape_result), 
      "linkedin" => scrape_linkedin(scrape_result), 
      "github" => scrape_github(scrape_result)
    }
    student = Student.new(s)
    student.save
  end

#======== Parse Methods ========#

  def scrape_name(scrape_result)
    scrape_result.css("div.page-title h4").text
  end

  def scrape_twitter(scrape_result)
    scrape_result.css(".page-title .icon-twitter").first.parent.attr("href")
  end

  def scrape_linkedin(scrape_result)
    begin
    scrape_result.css(".page-title .icon-linkedin-sign").first.parent.attr("href")
    rescue
      return "nil"
    end
  end

  def scrape_github(scrape_result)
    scrape_result.css('img').collect do |icon|
      if icon.attr('alt') == "GitHub"
      icon.parent.attr('href')
      end
    end.compact.first
  end

end