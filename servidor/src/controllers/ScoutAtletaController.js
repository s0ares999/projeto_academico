// src/controllers/scoutAtletaController.js
const ScoutAtleta = require('../models/ScoutAtleta');
const Atleta = require('../models/Atleta');
const Utilizadores = require('../models/Utilizadores');
const Time = require('../models/Time'); // Importa o modelo Time

// Criar uma nova associação entre um scout e um atleta usando nomes
exports.createScoutAtleta = async (req, res) => {
    const { scoutNome, atletaNome } = req.body; // Recebe os nomes

    try {
        // Verifica se o scout existe pelo nome
        const scout = await Utilizadores.findOne({ where: { nome: scoutNome } });
        // Verifica se o atleta existe pelo nome
        const atleta = await Atleta.findOne({ where: { nome: atletaNome } });

        if (!scout) {
            return res.status(404).json({ error: 'Scout não encontrado.' });
        }

        if (!atleta) {
            return res.status(404).json({ error: 'Atleta não encontrado.' });
        }

        // Cria a nova associação
        const novaAssociacao = await ScoutAtleta.create({ scoutId: scout.id, atletaId: atleta.id });
        res.status(201).json(novaAssociacao);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao criar associação entre scout e atleta.' });
    }
};

exports.getAllScoutAtletas = async (req, res) => {
    try {
        const scoutAtletas = await ScoutAtleta.findAll({
            include: [
                {
                    model: Atleta,
                    as: 'atleta', // Certifique-se de que o alias esteja correto
                    include: [
                        {
                            model: Time,
                            as: 'time', // Certifique-se de que o alias esteja correto
                        }
                    ]
                },
                {
                    model: Utilizadores,
                    as: 'scout' // Certifique-se de que o alias esteja correto
                }
            ]
        });

        // Formatar a resposta para incluir apenas os campos desejados
        const resultado = scoutAtletas.map(sa => ({
            scoutNome: sa.scout.nome,
            atletaNome: sa.atleta.nome,
            timeNome: sa.atleta.time.nome, // Nome do time
        }));

        res.json(resultado);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar associações de scout e atleta.' });
    }
};

// Remover uma associação entre um scout e um atleta
exports.deleteScoutAtleta = async (req, res) => {
    const { id } = req.params;

    try {
        const scoutAtleta = await ScoutAtleta.findByPk(id);

        if (!scoutAtleta) {
            return res.status(404).json({ error: 'Associação não encontrada.' });
        }

        await scoutAtleta.destroy();
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao remover associação entre scout e atleta.' });
    }
};
