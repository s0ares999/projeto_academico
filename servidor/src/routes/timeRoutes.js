const express = require('express');
const router = express.Router();
const timesController = require('../controllers/TimeController'); // Ajuste o caminho conforme necessário

// Rota para obter todos os times
router.get('/', timesController.getAllTimes);

// Rota para criar um novo time
router.post('/', timesController.createTime);

// Rota para mostrar um time pelo ID
router.get('/:id', timesController.getTimeById);

// Rota para editar um time
router.put('/:id', timesController.updateTime);

// Rota para deletar um time
router.delete('/:id', timesController.deleteTime);

// Rota para aprovar um time (opcional)
router.put('/:id/aprovar', timesController.approveTime);

// Rota para rejeitar um time (opcional)
router.put('/:id/rejeitar', timesController.rejectTime);

// Rota para desativar um time (opcional)
router.put('/:id/desativar', timesController.deactivateTime);

// Rota para recuperar os jogadores de um time específico
router.get('/:timeId/jogadores', timesController.getJogadoresByTimeId);

module.exports = router;
