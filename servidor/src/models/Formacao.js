// src/models/Formacao.js
const Sequelize = require('sequelize');
const sequelize = require('../database');

const Formacao = sequelize.define('formacao', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    nome: {
        type: Sequelize.STRING,
        allowNull: false,
    }
}, {
    timestamps: false,
});

module.exports = Formacao;
