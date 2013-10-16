class Student 

  attr_accessor :name, :twitter, :linkedin, :facebook, :website
  attr_reader :id

  @@db = SQLite3::Database.open 'students.db'

  @@all = []

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
    @@all.select do |student| 
      student.name == name_to_find
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
    sql = "SELECT * FROM students WHERE id = ?"
    result = @@db.execute(sql, id)
    Student.new_with_row(result.flatten)
  end

  def self.new_with_row(row)
    s = Student.new(nil, row[0])
    s.name = row[1]
    s
  end


  def saved!
    @saved = true
  end

  def saved?
    @saved
  end

  def insert 
    sql = "INSERT INTO students (name, website, twitter, linkedin, facebook)
      VALUES (?, ?, ?, ?, ?)"
    @@db.execute(sql, self.name, self.website, self.twitter, self.linkedin, self.facebook)
    find = "SELECT id FROM students WHERE id = ? ORDER BY id DESC LIMIT 1"
    results = @@db.execute("SELECT MAX(id) FROM students").flatten[0]
    saved! 
  end

  def save
    saved? ? update : insert
  end

  def update
    if saved? 
      sql = "UPDATE students SET name = ?, website = ?, twitter = ?, linkedin =?, facebook = ?
        WHERE id = ?"
      @@db.execute(sql, self.name, self.website, self.twitter, self.linkedin, self.facebook, self.id)
      true
    end
  end


end 