require_relative '../../config/environment.rb'

class StudentScraper
  @@images = []

  attr_accessor :name, :profile_pic, :excerpt, :tag_line, :quote, :bio,
    :education, :work, :website, :twitter, :linkedin, :github, :treehouse,
    :codeschool, :coderwall, :cities, :favorites

  def initialize(url, info = {})
    @url = url
    @index_info = info
  end

  def scrape_images(scrape_result)
    scrape_result.css('img').each do |img|
      @@images << img.attr('src')
    end
  end

  def scrape_bg_image(scrape_result)
    @@images << scrape_result.css('head').css('style').to_s.match(/url\((.*)\)/).to_a.last
  end

  def download_images
    @@images.uniq.each do |image_path|
      next if image_path.match(/http|com/)
      begin
        open("_site/img/#{image_path.sub(/^\.\.\/img\/(?:students\/)/, '')}", 'wb') do |file|
          file << open("http://students.flatironschool.com/students/#{image_path}").read
        end
      end
    end
  end

  def scrape_student_profile
    begin
      scrape_result = Nokogiri::HTML(open(@url))
    rescue 
    #want to rescue specific errors as much as possible, so we know what's breaking 
    #rescue OpenURI::HTTPError
      return nil
    end

    #scrape_images(scrape_result)
    #scrape_bg_image(scrape_result)
    download_images

    s = {
      "name" => Sanitize.clean(scrape_name(scrape_result)),
      "profile_pic" => Sanitize.clean(scrape_profile_pic(scrape_result)),
      "tag_line" => @tag_line,
      "quote" => Sanitize.clean(scrape_student_quote(scrape_result)),
      "bio" => scrape_student_bio(scrape_result),
      "education" => Sanitize.clean(scrape_student_education(scrape_result)),
      "work" => scrape_student_work(scrape_result),
      "website" => @url,
      "twitter" => Sanitize.clean(scrape_twitter(scrape_result)), 
      "linkedin" => Sanitize.clean(scrape_linkedin(scrape_result)), 
      "github" => Sanitize.clean(scrape_github(scrape_result)),
      "treehouse" => Sanitize.clean(scrape_student_treehouse(scrape_result)),
      "codeschool" => Sanitize.clean(scrape_student_codeschool(scrape_result)),
      "coderwall" => Sanitize.clean(scrape_student_coderwall(scrape_result)),
      "cities" => "We all love New York",
      "favorites" => "We all love coding",
      "background_img" => Sanitize.clean(scrape_student_bg_pic(scrape_result))
    }.merge(@index_info)

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

  # def scrape_student_tag_line(scrape_result)
  #   "This is a tag line"
  # end

  def scrape_student_quote(scrape_result)
    scrape_result.css("div.textwidget h3").children.to_s.strip.gsub(/\s+/, " ")
  end

  def scrape_student_bio(scrape_result)
    (Sanitize.clean(scrape_result.css("div#ok-text-column-2 p").first.to_s)).squish
  end

  def scrape_student_education(scrape_result)
    scrape_result.css("div#ok-text-column-3 ul li").collect do |x|
    x.text.to_s
    end.join(", ")
  end

  def scrape_student_work(scrape_result)
    (Sanitize.clean(scrape_result.css("div#ok-text-column-4 p").first.to_s)).squish
  end

  def scrape_student_treehouse(scrape_result)
    scrape_result.css('img').collect do |icon|
      if icon.attr('alt') == "Treehouse"
        icon.parent.attr('href')
      end
    end.compact.first
  end

  def scrape_student_codeschool(scrape_result)
    scrape_result.css('img').collect do |icon|
      if icon.attr('alt') == "Code School"
      icon.parent.attr('href')
      end
    end.compact.first
  end 

  def scrape_student_coderwall(scrape_result)
    scrape_result.css('img').collect do |icon|
      if icon.attr('alt') == "Coder Wall"
      icon.parent.attr('href')
      end
    end.compact.first
  end

  # def scrape_cities(scrape_result)

  #   scrape_result.css("div#ok-text-column-2.column div.services p br").first
  #   # .each do |header|
  #   #   if header.text.downcase.strip == "favorite cities"
  #   #     cities = header.parent.parent.css("a").collect do |city|
  #   #     city.text
  #   #     end.join(", ")
  #   #   end
  #   # end
  # end

  # def scrape_favorites(scrape_result)
  #   scrape_result.css('h3').each do |header|
  #     if header.text.downcase.strip == "favorites"
  #       favorites = header.parent.parent.css("a").collect do |header|
  #       end.join(", ")
  #     end
  #   end
  # end

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

  def scrape_student_bg_pic(scrape_result)
    scrape_result.css('head').css('style').to_s.match(/url\((.*)\)/).to_a.last
  end

end