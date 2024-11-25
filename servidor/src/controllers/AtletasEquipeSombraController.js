// src/controllers/AtletasEquipeSombraController.js
const AtletasEquipeSombra = require('../models/AtletasEquipeSombra');
const Atleta = require('../models/Atleta'); // Ajuste o caminho conforme necessário
const EquipeSombra = require('../models/EquipeSombra'); // Ajuste o caminho conforme necessário

// Criar uma associação entre atleta e equipe sombra
exports.createAtletaEquipeSombra = async (req, res) => {
    const { atletaId, equipeSombraId } = req.body;

    try {
        const atleta = await Atleta.findByPk(atletaId);
        const equipeSombra = await EquipeSombra.findByPk(equipeSombraId);

        if (!atleta) {
            return res.status(404).json({ error: 'Atleta não encontrado.' });
        }

        if (!equipeSombra) {
            return res.status(404).json({ error: 'Equipe Sombra não encontrada.' });
        }

        const novaAssociacao = await AtletasEquipeSombra.create({ atletaId, equipeSombraId });
        res.status(201).json(novaAssociacao);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao criar associação entre atleta e equipe sombra.' });
    }
};

// Listar todas as associações
exports.getAllAtletasEquipeSombra = async (req, res) => {
    try {
        const atletasEquipeSombra = await AtletasEquipeSombra.findAll({
            include: [
                { model: Atleta, as: 'atleta' }, // Certifique-se de que o alias está correto
                { model: EquipeSombra, as: 'equipeSombra' } // Alias correto para EquipeSombra
            ]
        });
        res.json(atletasEquipeSombra);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar associações.' });
    }
};

// Deletar uma associação
exports.deleteAtletaEquipeSombra = async (req, res) => {
    const { id } = req.params;

    try {
        const atletaEquipeSombra = await AtletasEquipeSombra.findByPk(id);
        if (atletaEquipeSombra) {
            await atletaEquipeSombra.destroy();
            res.status(204).send(); // Status 204 No Content
        } else {
            res.status(404).json({ error: 'Associação não encontrada.' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao deletar associação.' });
    }
};
