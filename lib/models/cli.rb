require_relative './student_class.rb'
require_relative './student_scrape_class.rb'


class CLIStudent

    attr_reader :students

    APPROVED_COMMANDS = [:list, :show, :help, :exit]


    def initialize(student_array)
        @students = student_array
        @on = true

    end

    def call
        system("clear")
        puts
        puts "****************************************************************"
        puts "* ------------------------------------------------------------ *"
        puts "* Welcome to the Flatiron School student command line browser. *"
        puts "* ------------------------------------------------------------ *"
        puts "*                    presented by...                           *"
        puts "*                          Team Middle                         *"
        puts "****************************************************************"
        system("say welcome to the flatiron school student command line browser")
        puts

        puts "                .--.                  Try not.
                    ::\\`--._,'.::.`._.--'/::     Do or do not.
                    ::::.  ` __::__ '  .::::    There is no try.
                    ::::::-:.`'..`'.:-::::::
                    ::::::::\\ `--' /::::::::              -Yoda"

        system(" say try not. ")
        system(" say do. or do not")
        system(" say there is no try.")
        while self.on?
            self.help
        end
    end

    def on?
        @on
    end

    def exit
        puts "Shutting down..."
        system("say goodbye")
        puts "Goodbye!"
        @on = false
    end

    def command(input)
        if APPROVED_COMMANDS.include?(input.strip.downcase.to_sym)
            self.send(input)
        elsif input.start_with?("show")
            show
        else
            puts "Invalid command! Try again"
            system ("say oops")
        end

    end
    
    def help
        puts
        puts "Here are some things you can do "
        puts " ------------------------------ "
        puts "  *  Type 'list' to list all the students in the class"
        puts "  *  Type 'show,' and then when prompted, enter a "
        puts "     student's name or ID number to browse their info"
        puts "  *  Type exit to quit"
        input = gets.downcase.strip
        command(input)
    end

    def list
        self.students.each_with_index do |student,idx|
            if idx.even?
                print "#{student.name}".ljust(10)
            else
                puts "#{student.name}".rjust(50)
            end
        end
        puts
        system("say by the way you are super cool and everyone likes you")
    end

    def show
        puts "Enter a name or ID number"
        input = gets.strip.downcase
        if input.to_i > 0
            output = Student.find(input.to_i)
            print_student_info(output)
            return
        else
            output = Student.find_by_name(input)
            output.each do |thing|
                print_student_info(thing)
            end

            return
        end
            puts "Oh no!"
            system("say mistakes")
    end

    def print_student_info(student)
        puts "-------------------------------------------------"
        puts "Student name: #{student.name}"
        puts "Website link: #{student.website}"
        puts "Twitter page: #{student.twitter}"
        puts "LinkedIn page: #{student.linkedin}"
        puts "-------------------------------------------------"
        system("say #{student.name}")
    end
    
end







