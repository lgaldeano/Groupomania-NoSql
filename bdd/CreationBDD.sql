SET NAMES utf8;

-- Suppression des tables déjà existantes (le cas échéant)
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Likes;


-- Création de la table Utilisateurs
CREATE TABLE Users (
  id SMALLINT unsigned NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  pictureurl VARCHAR(255) DEFAULT NULL,
  outline VARCHAR(255) DEFAULT NULL,
  isadmin TINYINT NOT NULL,
  PRIMARY KEY(id),
  UNIQUE KEY ind_uni_email (email)
) ENGINE=InnoDB;


-- Création de la table des publications
CREATE TABLE Posts (
  id MEDIUMINT unsigned NOT NULL AUTO_INCREMENT,
  publication_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user_id SMALLINT unsigned,
  imageurl VARCHAR(255),
  content TEXT,
  PRIMARY KEY(id)
) ENGINE=InnoDB;


-- Création de la table des commentaires
CREATE TABLE Comments (
  id INT unsigned NOT NULL AUTO_INCREMENT,
  publication_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  content TEXT NOT NULL,
  user_id SMALLINT unsigned,
  post_id MEDIUMINT unsigned NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB;


-- Création de la table des likes/dislikes
CREATE TABLE Likes (
  id INT unsigned NOT NULL AUTO_INCREMENT,
  rate TINYINT NOT NULL,
  user_id SMALLINT unsigned NOT NULL,
  post_id MEDIUMINT unsigned NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB;



-- Création des clés étrangères qui lient les différentes tables
ALTER TABLE Posts ADD CONSTRAINT fk_Posts_Users_id FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Comments ADD CONSTRAINT fk_Comments_Users_id FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Comments ADD CONSTRAINT fk_Comments_Posts_id FOREIGN KEY (post_id) REFERENCES Posts (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Likes ADD CONSTRAINT fk_Likes_Users_id FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Likes ADD CONSTRAINT fk_Likes_Posts_id FOREIGN KEY (post_id) REFERENCES Posts (id) ON DELETE CASCADE ON UPDATE CASCADE;