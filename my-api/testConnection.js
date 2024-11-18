// testConnection.js
require('dotenv').config();  // Carregar variáveis do .env
const { Client } = require('pg');

// Configuração da conexão com o banco de dados usando a URL do ambiente
const client = new Client({
  connectionString: process.env.DATABASE_URL
});

// Tentar conectar ao banco de dados
client.connect()
  .then(() => console.log('Conectado ao banco de dados com sucesso!'))
  .catch((err) => console.error('Erro ao conectar ao banco de dados', err.stack))
  .finally(() => client.end());  // Fecha a conexão após o teste
