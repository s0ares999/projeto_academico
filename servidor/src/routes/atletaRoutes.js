const express = require('express');
const router = express.Router();
const atletaController = require('../controllers/AtletaController');

// Rota para criar atleta
router.post('/', atletaController.createAtleta);

// Rota para obter todos os atletas
router.get('/', atletaController.getAllAtletas);

// Rota para obter um atleta por ID
router.get('/:id', atletaController.getAtletaById);

// Rota para atualizar um atleta
router.put('/:id', atletaController.updateAtleta);

// Rota para deletar um atleta
router.delete('/:id', atletaController.deleteAtleta);

// Rota para aprovar um atleta
router.put('/:id/aprovar', atletaController.aprovarAtleta);

// Rota para rejeitar um atleta
router.put('/:id/rejeitar', atletaController.rejeitarAtleta);

// Rota para marcar o status como pendente
router.put('/:id/pendente', atletaController.pendenteAtleta);

router.put('/:id/desativar', atletaController.desativarAtleta);

module.exports = router;
