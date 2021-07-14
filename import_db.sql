
PRAGMA foreign_keys = ON;

DROP TABLE if EXISTS

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
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
    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY
    body TEXT NOT NULL
    question_id INTEGER NOT NULL
    user_id INTEGER NOT NULL
    parent_replies_id INTEGER
    FOREIGN KEY (parent_replies_id) REFERENCES replies(id)
    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)


);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY
    user_id INTEGER NOT NULL
    question_id INTEGER NOT NULL
    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (question_id) REFERENCES questions(id)
);




