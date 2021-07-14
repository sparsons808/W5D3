
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_replies_id INTEGER,
    FOREIGN KEY (parent_replies_id) REFERENCES replies(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)


);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
    users (first_name, last_name)
VALUES
    ('Sydney', 'Parsons'), ('Mike', 'Amicucci');


INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Capital Question', 'What is the capital of New Jersey?', 
    (SELECT id FROM users WHERE first_name = 'Sydney')),

    ('Age', "What's your age?", (SELECT id FROM users WHERE first_name = 'Mike'));


INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE first_name = 'Sydney'), 
    (SELECT id FROM questions WHERE title = 'Capital Question')),

    ((SELECT id FROM users WHERE first_name = 'Mike'), (SELECT id FROM questions WHERE title = "Age"));


INSERT INTO
    replies (body, question_id, user_id, parent_replies_id)
VALUES
    ("My age is 25", (SELECT id FROM questions WHERE title = 'Age'), 
    (SELECT id FROM users WHERE first_name = 'Sydney'), NULL), 

    ("The capital is Trenton", (SELECT id FROM questions WHERE title = 'Capital Question'), 
    (SELECT id FROM users WHERE first_name = 'Mike'), NULL);


INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE first_name = 'Sydney'),
    (SELECT id FROM questions WHERE title = 'Age')),

    ((SELECT id FROM users WHERE first_name = 'Mike'),
    (SELECT id FROM questions WHERE title = 'Capital Question'));





