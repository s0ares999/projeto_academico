// server.js
const express = require('express');
const db = require('./models'); // Importa os models
const app = express();
const PORT = process.env.PORT || 3000;

require('dotenv').config(); // Carrega as variáveis de ambiente

// Middleware
app.use(express.json());

// Testar a conexão com o banco de dados
db.sequelize.authenticate()
  .then(() => console.log('Conectado ao PostgreSQL'))
  .catch(err => console.error('Erro ao conectar ao PostgreSQL:', err));

// Rotas
app.get('/', (req, res) => {
  res.send('API funcionando!');
});

// Criar um atleta
app.post('/atletas', async (req, res) => {
  try {
    const atleta = await db.Atleta.create(req.body);
    res.status(201).json(atleta);
  } catch (error) {
    console.error('Erro ao criar atleta:', error); // Log do erro
    res.status(400).json({ error: error.message });
  }
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
