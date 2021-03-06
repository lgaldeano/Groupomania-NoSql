require("dotenv").config();
const Cookies = require("cookies");
const cryptojs = require("crypto-js");
const database = require("../utils/database");

/**
 * Ajout d'un nouveau commentaire
 */
exports.newComment = (req, res, next) => {
  const connection = database.connect();

  const cryptedCookie = new Cookies(req, res).get("snToken");
  const userId = JSON.parse(
    cryptojs.AES.decrypt(cryptedCookie, process.env.COOKIE_KEY).toString(
      cryptojs.enc.Utf8
    )
  ).userId;
  const postId = req.body.postId;
  const content = req.body.content;

  const sql =
    "INSERT INTO Comments (user_id, post_id, content)\
  VALUES (?, ?, ?);";
  const sqlParams = [userId, postId, content];

  connection.execute(sql, sqlParams, (error, results, fields) => {
    if (error) {
      res.status(500).json({ error: error.sqlMessage });
    } else {
      res.status(201).json({ message: "Commentaire ajoutée" });
    }
  });
  connection.end();
};

/**
 * Récupérer tous les commentaires d'un post particulier
 */
exports.getCommentsofPost = (req, res, next) => {
  const connection = database.connect();

  const postId = req.body.postId;
  //Joindre table comments et Users
  const sql =
    "SELECT Comments.id AS commentId, Comments.publication_date AS commentDate, Comments.content As commentContent, Users.id AS userId, Users.name AS userName, Users.pictureurl AS userPicture\
  FROM Comments\
  INNER JOIN Users ON Comments.user_id = Users.id\
  WHERE Comments.post_id = ?";
  const sqlParams = [postId];

  connection.execute(sql, sqlParams, (error, comments, fields) => {
    if (error) {
      res.status(500).json({ error: error.sqlMessage });
    } else {
      res.status(200).json({ comments });
    }
  });

  connection.end();
};

/**
 * Suppression d'un commentaire
 */
exports.deleteComment = (req, res, next) => {
  const connection = database.connect();
  const commentId = parseInt(req.params.id, 10);
  const sql = "DELETE FROM Comments WHERE id=?;";
  const sqlParams = [commentId];
  connection.execute(sql, sqlParams, (error, results, fields) => {
    if (error) {
      res.status(500).json({ error: error.sqlMessage });
    } else {
      res.status(201).json({ message: "Commentaire supprimée" });
    }
  });
  connection.end();
};
