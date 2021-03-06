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

class Question

    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        puts data
        data.map { |datum| Question.new(datum) }
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
        
        Question.new(questions.first)
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
            
            Question.new(titles.first)
    end

    def self.find_by_name(first_name, last_name)
        user = User.find_by_name(first_name, last_name)
        raise "#{first_name} #{last_name} not found in database" unless user
        
        questions = QuestionsDatabase.instance.execute(<<-SQL, user.id)
                SELECT
                    *
                FROM
                    questions
                WHERE
                    user_id = ?
            SQL

        questions.map { |question| Question.new(question)}
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def author
        User.find_by_id(self.user_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

end


class User

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


    def initialize(options)
        @id = options['id']
        @first_name = options['first_name']
        @last_name = options['last_name']
    end

    def authored_questions
        Question.find_by_name(self.first_name, self.last_name)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end


end


class Reply
    attr_accessor :id, :body, :question_id, :user_id, :parent_replies_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless reply.size > 0

        Reply.new(reply.first)
    end

    def self.find_by_user_id(id)
        user = User.find_by_id(id)
        raise "#{id} not in data base" unless user

        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        return nil unless reply.size > 0
        
        Reply.new(reply.first)
    end

    def self.find_by_question_id(id)
        question = Question.find_by_id(id)
        raise "#{id} not found in database" unless question

        questions = QuestionsDatabase.instance.execute(<<-SQL, question.id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        questions.map { |question| Question.new(question) }
    end
    
    def initialize(options)
        @id = options['id']
        @body = options['body']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @parent_replies_id = options['parent_replies_id']
    end

    def author
        User.find_by_id(self.user_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def parent_reply
        Reply.find_by_id(self.parent_replies_id)
    end

    def child_replies
        
    end
end


class QuestionLike
    attr_accessor :id, :user_id, :question_id

    def self.find_likes_of_user(first_name, last_name)
        user = User.find_by_name(first_name, last_name)
        raise "#{first_name} #{last_name} not found in database" unless user

        likes = QuestionsDatabase.instance.execute(<<-SQL, user.id)
            SELECT
                *
            FROM 
                questions
            WHERE 
                id = (
                    SELECT
                        question_id
                    FROM
                        question_likes
                    WHERE
                        user_id = ?
                    )
        SQL

        likes.map { |like| Question.new(like)}
    end


    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end



class QuestionFollows

    def self.find_followers_count(title)

        count = QuestionsDatabase.instance.execute(<<-SQL, title)
            SELECT 
                COUNT(user_id)
            FROM
                question_follows
            WHERE
                question_id = (
                    SELECT
                        id
                    FROM 
                        questions
                    WHERE
                        title = ?
                    )
        SQL
        count.first.values
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end
