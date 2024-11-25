// src/middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');
const config = require('../config'); // Certifique-se de que o caminho para o config está correto

let checkToken = (req, res, next) => {
    let token = req.headers['x-access-token'] || req.headers['authorization'];

    if (token && token.startsWith('Bearer ')) {
        token = token.slice(7, token.length); // Remove a palavra ‘Bearer ’
    }

    if (token) {
        jwt.verify(token, config.jwtSecret, (err, decoded) => {
            if (err) {
                return res.status(401).json({
                    success: false,
                    message: 'O token não é válido.'
                });
            } else {
                req.user = decoded; // Altera aqui para req.user
                next();
            }
        });
    } else {
        return res.status(403).json({
            success: false,
            message: 'Token indisponível.'
        });
    }
};

module.exports = {
    checkToken: checkToken
};
