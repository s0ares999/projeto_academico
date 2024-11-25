require('dotenv').config(); // Carregar variáveis de ambiente do .env

const { Sequelize } = require('sequelize');

// Verificar se a aplicação está em produção ou local
const isProduction = process.env.NODE_ENV === 'production';

// Configuração do Sequelize com as variáveis de ambiente
const sequelize = new Sequelize(
  process.env.DB_NAME,     // Nome do banco de dados (exemplo: 'database_academico')
  process.env.DB_USER,     // Usuário (exemplo: 'database_academico_user')
  process.env.DB_PASSWORD, // Senha (exemplo: 'KIQiPkgYX1vbquVM0uKdp36JL5lfPltZ')
  {
    host: process.env.DB_HOST, // Host do banco (exemplo: 'dpg-cske8ki3esus73834eag-a')
    port: process.env.DB_PORT || 5432, // Porta do PostgreSQL (padrão 5432)
    dialect: 'postgres', // Dialeto do banco
    dialectOptions: {
      ssl: {
        require: true, // Conectar com SSL (necessário para Render)
        rejectUnauthorized: false, // Ignorar erros de certificado SSL
      },
    },
  }
);

module.exports = sequelize;
