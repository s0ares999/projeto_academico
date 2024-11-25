const express = require('express');
const router = express.Router();
const utilizadoresController = require('../controllers/UtilizadoresController'); // ajuste o caminho conforme necessário

// Rota para obter todos os utilizadores
router.get('/', utilizadoresController.getAllUtilizadores);

// Rota para criar um novo utilizador
router.post('/', utilizadoresController.createUtilizador);

// Rota para mostrar um utilizador pelo ID
router.get('/:id', utilizadoresController.getUtilizadorById);

// Rota para editar um utilizador
router.put('/:id', utilizadoresController.updateUtilizador);

// Rota para apagar um utilizador
router.delete('/:id', utilizadoresController.deleteUtilizador);

// Rota para aprovar um utilizador
router.put('/:id/aprovar', utilizadoresController.approveUtilizador);

// Rota para rejeitar um utilizador
router.put('/:id/rejeitar', utilizadoresController.rejectUtilizador);

// Rota para desativar um utilizador
router.put('/:id/desativar', utilizadoresController.deactivateUtilizador);

module.exports = router;
