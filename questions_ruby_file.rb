require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database

    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Questions

    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end

    def self.find_by_id(id)

        questions = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless questions.size > 0
        
        Questions.new(questions.first)
    end

    def self.find_by_title(title)
        titles = QuestionsDatabase.instance.execute(<<-SQL, title)
                SELECT
                    *
                FROM
                    questions
                WHERE
                    title = ?
            SQL
            return nil unless titles.size > 0
            
            Questions.new(titles.first)
    end

    # def self.find_by_name(name)
    #     user = User.find_by_name(name)
    #     raise "#{name} not found in database" unless user
        
    #     questions = QuestionsDatabase.instance.execute(<<-SQL user_id)
    #                 SELECT
    #                     *
    #                 FROM
    #                     questions
    #                 WHERE
    #                     user_id = ?
    #             SQL

    #     questions.map { |question| Question.new(question)}
    # end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

end


class User

    def initialize(options)
        @id = options['id']
        @first_name = options['first_name']
        @last_name = options['last_name']
    end

    attr_accessor :id, :first_name, :last_name

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    def self.find_by_id(id)

        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil unless user.size > 0
        
        User.new(user.first)
    end

    def self.find_by_name(first_name, last_name)
        name = QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name)
            SELECT
                *
            FROM
                users
            WHERE
                first_name = ? AND last_name = ?
        SQL
        return nil unless name.size > 0
        
        User.new(name.first)
    end


end


class Reply

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @parent_replies_id = options['parent_replies_id']
    end

end


class QuestionLike

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end



class QuestionFollows

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end
