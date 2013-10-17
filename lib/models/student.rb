require_relative '../../config/environment.rb'
require 'pry'
class Student 

    attr_accessor :name, :profile_pic, :tag_line, :quote, :bio,
    :education, :work, :website, :twitter, :linkedin, :github, :treehouse,
    :codeschool, :coderwall, :cities, :favorites, :index_pic, :excerpt, :background_img
  attr_reader :id

  @@db = SQLite3::Database.new 'db/students.db'

  @@all = []

  sql = "DROP TABLE IF EXISTS students" 
  @@db.execute(sql)

  sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, profile_pic TEXT, tag_line TEXT, quote TEXT, bio TEXT, education TEXT, work TEXT, website TEXT, twitter TEXT, linkedin TEXT, github TEXT, treehouse TEXT, codeschool TEXT, coderwall TEXT, cities TEXT, favorites TEXT, index_pic TEXT, excerpt TEXT, background_img TEXT)"
  @@db.execute(sql)

  def initialize(student_hash=nil, id=nil)
    student_hash.map do |k, v|
      k.to_s
      self.send("#{k}=".to_sym, v)
    end unless student_hash.nil?
    @id = id
    if id.nil?
      if @@all.count == 0 
        @id = 1
      else
        @id = @@all.max_by { |s| s.id}.id+1
      end
    @@all << self
    @saved = !id.nil?
    end
  end

  def self.reset_all
    @@all.clear
    @@current_id = 1
  end

  def self.all
    @@all
  end

  def self.find_by_name(name_to_find)
    @@all.find do |student| 
      student.name if student.name.downcase == name_to_find.downcase
    end
  end  

  def self.find(id_to_find)
    @@all.find do |student| 
      student.name if student.id == id_to_find
    end
  end

  def self.delete(id)
    @@all.delete_if {|student| student.id == id}
  end

#======== SQL Inserts/functions ========#
  # def self.find(id)
  #   find = "SELECT * FROM students WHERE id = ?"
  #   result = @@db.execute(find, id)
  #   Student.new(result.first)
  # end

  def self.load(id)
    sql = "SELECT () FROM students WHERE id = ?"
    result = @@db.execute(sql, id)
    Student.new_with_row(result.flatten)
  end

  def self.new_with_row(row)
    s = Student.new(nil, row[0])
    s.name = row[1]
    s
  end

  def self.load_students
    sql = "SELECT id, name, profile_pic, tag_line, quote, bio, education, work, website, twitter, linkedin, github, treehouse, codeschool, coderwall, cities, favorites FROM students LIMIT 1"
    result = @@db.execute(sql)
    p result
    binding.pry
    #(id , name, profile_pic, tag_line, quote, bio, education, work, website, twitter, linkedin, github, treehouse, codeschool, coderwall, cities, favorites)
    #Student.new_with_row(result.flatten)    
  end


  def saved!
    @saved = true
  end

  def saved?
    @saved
  end

  def insert 
    sql = "INSERT INTO students (name, profile_pic, tag_line, quote, bio, education, work, website, twitter, linkedin, github, treehouse, codeschool, coderwall, cities, favorites, index_pic, excerpt, background_img)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    @@db.execute(sql, self.name, self.profile_pic, self.tag_line, self.quote, self.bio, self.education, self.work, self.website, self.twitter, self.linkedin, self.github, self.treehouse, self.codeschool, self.coderwall, self.cities, self.favorites, self.index_pic, self.excerpt, self.background_img)
    find = "SELECT id FROM students WHERE id = ? ORDER BY id DESC LIMIT 1"
    results = @@db.execute("SELECT MAX(id) FROM students").flatten[0]
    saved! 
  end

  def save
    saved? ? update : insert
  end

  def update
    if saved? 
      sql = "UPDATE students SET name = ?, website = ?, twitter = ?, linkedin =?, github = ?, WHERE id = ?"
      @@db.execute(sql, self.name, self.website, self.twitter, self.linkedin, self.github, self.id)
      true
    end
  end


end 