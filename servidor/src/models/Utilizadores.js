const Sequelize = require('sequelize');
const sequelize = require('../database');


// Define o modelo Utilizadores
const Utilizadores = sequelize.define('utilizadores', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    nome: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
    },
    senha: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    role: {
        type: Sequelize.ENUM('Admin', 'Scout', 'Consultor'),
        allowNull: false,
    },
    status: {
        type: Sequelize.STRING,
        defaultValue: 'pendente',
    },
}, {
    timestamps: true,
});



// Exporta o modelo
module.exports = Utilizadores;
