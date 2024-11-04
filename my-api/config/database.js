// config/database.js
const { Sequelize } = require('sequelize');
require('dotenv').config(); // Carrega as variáveis de ambiente do arquivo .env

// Criação da instância do Sequelize usando a URL do banco de dados
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
  // Habilite o logging se precisar de mais informações durante a depuração
  logging: false,
});

// Testar a conexão (opcional, mas recomendado para depuração)
sequelize.authenticate()
  .then(() => {
    console.log('Conectado ao banco de dados com sucesso!');
  })
  .catch(err => {
    console.error('Não foi possível conectar ao banco de dados:', err);
  });

// Exporte a instância do Sequelize para ser usada em outros arquivos
module.exports = sequelize;
