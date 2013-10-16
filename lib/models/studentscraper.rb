require_relative '../../config/environment.rb'
class StudentScraper

  attr_accessor :name, :profile_pic, :excerpt, :tag_line, :quote, :bio,
    :education, :work, :website, :twitter, :linkedin, :github, :treehouse,
    :codeschool, :coderwall, :cities, :favorites

  def initialize(url)
    @url = url 
  end

  def scrape_student_profile
    begin
      scrape_result = Nokogiri::HTML(open(@url))
      scrape_result2 = scrape_result.css("li.home-blog-post")
    rescue 
    #want to rescue specific errors as much as possible, so we know what's breaking 
    #rescue OpenURI::HTTPError
      return nil
    end
    s = {
      "name" => scrape_name(scrape_result),
      "profile_pic" => scrape_profile_pic(scrape_result),
      "excerpt" => scrape_student_excerpt(scrape_result2),
      "tag_line" => scrape_student_tag_line(scrape_result2),
      "quote" => scrape_student_quote(scrape_result2),
      "bio" => scrape_student_bio(scrape_result2),
      "education" => scrape_student_education(scrape_result2),
      "work" => scrape_student_work(scrape_result2),
      "website" => @url,
      "twitter" => scrape_twitter(scrape_result), 
      "linkedin" => scrape_linkedin(scrape_result), 
      "github" => scrape_github(scrape_result),
      "treehouse" => scrape_student_treehouse(scrape_result2),
      "codeschool" => scrape_student_codeschool(scrape_result2),
      "coderwall" => scrape_student_coderwall(scrape_result2),
      "cities" => scrape_cities(scrape_result2),
      "favorites" => scrape_favorites(scrape_result2)
    }

    student = Student.new(s)
    student.save
  end

#======== Parse Methods ========#

  def scrape_name(scrape_result)
    scrape_result.css("div.page-title h4").text
  end

  def scrape_profile_pic(scrape_result)
    scrape_result.css("div.top-page-title img").attr("src").value
  end

  def scrape_student_excerpt(scrape_result2)
    scrape_result2.collect do |excerpt|
    excerpt.css("div.excerpt p").first.children.to_s.strip
    end
  end

  def scrape_student_tag_line(scrape_result2)
    scrape_result2.collect do |tag_line|
    tag_line.css("p.home-blog-post-meta").children.to_s
    end
  end

  def scrape_student_quote(scrape_result2)
    scrape_result2.css("div.textwidget h3").children.to_s.strip
  end

  def scrape_student_bio(scrape_result2)
    scrape_result2.css("div#ok-text-column-2 p").first.to_s.strip
  end

  def scrape_student_education(scrape_result2)
    scrape_result2.css("div#ok-text-column-3 ul li").collect do |x|
    x.text.to_s
    end
  end

  def scrape_student_work(scrape_result2)
    scrape_result2.css("div#ok-text-column-4 p").first.to_s.strip
  end

  def scrape_student_treehouse(scrape_result2)
    scrape_result2.css('img').collect do |icon|
      if icon.attr('alt') == "Treehouse"
        icon.parent.attr('href')
      end
    end.compact.first
  end

  def scrape_student_codeschool(scrape_result2)
    scrape_result2.css('img').collect do |icon|
      if icon.attr('alt') == "Code School"
      icon.parent.attr('href')
      end
    end.compact.first
  end 

  def scrape_student_coderwall(scrape_result2)
    scrape_result2.css('img').collect do |icon|
      if icon.attr('alt') == "Coder Wall"
      icon.parent.attr('href')
      end
    end.compact.first
  end

  def scrape_cities(scrape_result2)
    scrape_result2.css('h3').each do |header|
      if header.text.downcase.strip == "favorite cities"
        cities = header.parent.parent.css("a").collect do |city|
        city.text
        end
      end.join(", ")
    end
  end

  def scrape_favorites(scrape_result2)
    scrape_result2.css('h3').each do |header|
      if header.text.downcase.strip == "favorites"
        favorites = header.parent.parent.css("a").collect do |header|
        end
      end.join(", ")
    end
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