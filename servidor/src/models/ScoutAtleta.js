// src/models/ScoutAtleta.js
const Sequelize = require('sequelize');
const sequelize = require('../database');
const Utilizadores = require('./Utilizadores');
const Atleta = require('./Atleta');

const ScoutAtleta = sequelize.define('ScoutAtleta', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    scoutId: {
        type: Sequelize.INTEGER,
        references: {
            model: Utilizadores,
            key: 'id'
        },
        allowNull: false
    },
    atletaId: {
        type: Sequelize.INTEGER,
        references: {
            model: Atleta,
            key: 'id'
        },
        allowNull: false
    }
}, {
    timestamps: true
});

ScoutAtleta.belongsTo(Atleta, { foreignKey: 'atletaId', as: 'atleta' }); // Associa o scoutAtleta ao atleta
ScoutAtleta.belongsTo(Utilizadores, { foreignKey: 'scoutId', as: 'scout' }); // Associa o scoutAtleta ao scout

module.exports = ScoutAtleta;
