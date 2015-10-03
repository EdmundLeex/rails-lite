CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  -- email VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  session_token VARCHAR(255)

  -- FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES user(id)
);

INSERT INTO
  users (id, name, email, password_digest, session_token)
VALUES
  (1, "demo", 
    "$2a$10$mTIJnymjyEPYClVE0vAEQOdvkalZXHJsb2HuvFBjE0wavx7WY4HuO",
    "-NpCe9bun4RM2G6j5zcbGw");

INSERT INTO
  tasks (id, title, body, user_id)
VALUES
  (1, "Todo app bootstrapping", "Basic bootstrap for todo app", 1),
  (2, "Has many thru", "add has many relationship thru", 1),
  (3, "Validations", "add validation macro feature", 1),
  (4, "JS?", "Maybe some js polish", 1);

-- INSERT INTO
--   cats (id, name, owner_id)
-- VALUES
--   (1, "Breakfast", 1),
--   (2, "Earl", 2),
--   (3, "Haskell", 3),
--   (4, "Markov", 3),
--   (5, "Stray Cat", NULL);
