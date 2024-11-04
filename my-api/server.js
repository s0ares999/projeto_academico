const express = require('express');
const { Sequelize } = require('sequelize');
const app = express();
const PORT = process.env.PORT || 3000;
const db = require('./models'); // Importa os models e associações
require('./models/associations'); // Configura as associações

require('dotenv').config();

// Middleware
app.use(express.json());

// Conexão com o PostgreSQL
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
});

// Testar a conexão
sequelize.authenticate()
  .then(() => console.log('Conectado ao PostgreSQL'))
  .catch(err => console.error('Erro ao conectar ao PostgreSQL:', err));

// Rotas
app.get('/', (req, res) => {
  res.send('API funcionando!');
});

// Criar um atleta (exemplo)
app.post('/atletas', async (req, res) => {
  try {
    const atleta = await db.Atleta.create(req.body);
    res.status(201).json(atleta);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
