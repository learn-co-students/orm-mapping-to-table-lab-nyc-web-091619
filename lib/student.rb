class Student
  attr_reader :id
  attr_accessor :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id

  end

  # Class Methods

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )

      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(student)
    student = self.new(student[:name], student[:grade])
    student.save
    student
  end

  # Instance Methods
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES(?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

end # End of student class
