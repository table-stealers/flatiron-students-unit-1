 class StudentScraper

#======== Build Student Hash ========#  
 def scrape_student_profile
    @profiles = @student_url.map do |url|
      scrape_student_profile_at(url)
    end
  end

  def scrape_student_profile_at(url)
    begin
      scrape_result = Nokogiri::HTML(open(url))
    rescue 
    #want to rescue specific errors as much as possible, so we know what's breaking 
    #rescue OpenURI::HTTPError
      return nil
    end
    {
      "name" => scrape_name(scrape_result),
      "website" => url,
      "twitter" => scrape_twitter(scrape_result), 
      "linkedin" => scrape_linkedin(scrape_result), 
      "github" => scrape_github(scrape_result)
    }
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