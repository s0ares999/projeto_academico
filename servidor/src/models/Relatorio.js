// src/models/Relatorio.js
const Sequelize = require('sequelize');
const sequelize = require('../database');
const Atleta = require('./Atleta'); // Importa a model Atleta
const Utilizadores = require('./Utilizadores'); // Importa a model Utilizadores (Scout)

const Relatorio = sequelize.define('relatorio', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    tecnica: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    velocidade: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    atitudeCompetitiva: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    inteligencia: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    altura: {
        type: Sequelize.ENUM('alto', 'medio', 'baixo'),
        allowNull: false,
    },
    morfologia: {
        type: Sequelize.ENUM('ectomorfo', 'mesomorfo', 'endomorfo'),
        allowNull: false,
    },
    ratingFinal: {
        type: Sequelize.FLOAT,
        allowNull: false,
    },
    comentario: {
        type: Sequelize.TEXT,
        allowNull: true,
    },
    status: {
        type: Sequelize.ENUM('Pendente', 'Aprovado', 'Rejeitado'), // Define os possíveis status
        allowNull: false,
        defaultValue: 'Pendente', // Valor padrão ao criar um relatório
    },
    createdAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
    },
    updatedAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
    },
});

// Associações
Relatorio.belongsTo(Atleta, { foreignKey: 'atletaId', as: 'atleta' });
Relatorio.belongsTo(Utilizadores, { foreignKey: 'scoutId', as: 'utilizador' });

module.exports = Relatorio;
