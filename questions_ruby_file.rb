require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database

    include Singletion

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Questions

    def self.find_by_id(id)

        questions = QuestionsDatabase.instance.execute(<<-SQL id)
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

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

end
