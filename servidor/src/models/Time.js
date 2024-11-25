const Sequelize = require('sequelize');
const sequelize = require('../database'); // ajuste o caminho conforme necessário

const Time = sequelize.define('time', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    nome: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    pais: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    categoria: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    descricao: {
        type: Sequelize.TEXT, // Pode ser usado para uma descrição mais longa
        allowNull: true, // Permite que o campo fique vazio
    },
    status: {
        type: Sequelize.STRING,
        defaultValue: 'pendente', // Define o status padrão como 'ativo'
    },
}, {
    timestamps: false, // Se não precisar de campos createdAt e updatedAt
});

module.exports = Time;
