// src/routes/formacaoRoutes.js
const express = require('express');
const router = express.Router();
const formacaoController = require('../controllers/FormacaoController');

// Rota para criar uma nova formação
router.post('/', formacaoController.createFormacao);

// Rota para obter todas as formações
router.get('/', formacaoController.getAllFormacoes);

// Rota para obter uma formação pelo ID
router.get('/:id', formacaoController.getFormacaoById);

// Rota para editar uma formação
router.put('/:id', formacaoController.updateFormacao);

// Rota para apagar uma formação
router.delete('/:id', formacaoController.deleteFormacao);

module.exports = router;
