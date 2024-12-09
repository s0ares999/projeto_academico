const Relatorio = require('../models/Relatorio');
const Atleta = require('../models/Atleta');
const Utilizador = require('../models/Utilizadores'); // Modelo de Utilizador

// Listar todos os relatórios com os dados do atleta e do utilizador (scoutId)
exports.getAllRelatorios = async (req, res) => {
    try {
        const relatorios = await Relatorio.findAll({
            include: [
                { model: Atleta, as: 'atleta' }, // Relacionamento com Atleta
                { model: Utilizador, as: 'utilizador' }, // Relacionamento com Utilizador (scoutId)
            ],
        });
        res.json(relatorios);
    } catch (error) {
        console.error('Erro ao buscar relatórios:', error);
        res.status(500).json({ error: 'Erro ao buscar relatórios.' });
    }
};

// Criar um novo relatório e associar ao atleta
exports.createRelatorio = async (req, res) => {
    const { tecnica, velocidade, atitudeCompetitiva, inteligencia, altura, morfologia, ratingFinal, comentario, atletaId, scoutId, status } = req.body;

    try {
        // Verifica se o atleta existe
        const atleta = await Atleta.findByPk(atletaId);
        if (!atleta) {
            return res.status(404).json({ error: 'Atleta não encontrado.' });
        }

        // Cria o relatório usando o ID do atleta e o scoutId
        const novoRelatorio = await Relatorio.create({
            tecnica,
            velocidade,
            atitudeCompetitiva,
            inteligencia,
            altura,
            morfologia,
            ratingFinal,
            comentario,
            atletaId,
            scoutId,
            status: status || 'Pendente',
        });

        res.status(201).json(novoRelatorio);
    } catch (error) {
        console.error('Erro ao criar relatório:', error);
        res.status(500).json({ error: 'Erro ao criar relatório.' });
    }
};

// Obter um relatório por ID com os dados do atleta
exports.getRelatorioById = async (req, res) => {
    const { id } = req.params;

    try {
        const relatorio = await Relatorio.findByPk(id, {
            include: [
                { model: Atleta, as: 'atleta' }, // Inclui os dados do Atleta
                { model: Utilizador, as: 'utilizador' }, // Inclui os dados do Utilizador (scoutId)
            ],
        });

        if (!relatorio) {
            return res.status(404).json({ error: 'Relatório não encontrado.' });
        }

        res.json(relatorio);
    } catch (error) {
        console.error('Erro ao buscar relatório:', error);
        res.status(500).json({ error: 'Erro ao buscar relatório.' });
    }
};

// Atualizar um relatório
exports.updateRelatorio = async (req, res) => {
    const { id } = req.params;
    const { tecnica, velocidade, atitudeCompetitiva, inteligencia, altura, morfologia, ratingFinal, comentario, status } = req.body;

    try {
        const relatorio = await Relatorio.findByPk(id);
        if (!relatorio) {
            return res.status(404).json({ error: 'Relatório não encontrado.' });
        }

        await relatorio.update({
            tecnica,
            velocidade,
            atitudeCompetitiva,
            inteligencia,
            altura,
            morfologia,
            ratingFinal,
            comentario,
            status,
        });

        res.json(relatorio);
    } catch (error) {
        console.error('Erro ao atualizar relatório:', error);
        res.status(500).json({ error: 'Erro ao atualizar relatório.' });
    }
};

// Deletar um relatório
exports.deleteRelatorio = async (req, res) => {
    const { id } = req.params;

    try {
        const relatorio = await Relatorio.findByPk(id);
        if (!relatorio) {
            return res.status(404).json({ error: 'Relatório não encontrado.' });
        }

        await relatorio.destroy();
        res.status(204).send();
    } catch (error) {
        console.error('Erro ao deletar relatório:', error);
        res.status(500).json({ error: 'Erro ao deletar relatório.' });
    }
};

// Listar relatórios pendentes
exports.getRelatoriosPendentes = async (req, res) => {
    try {
        const relatoriosPendentes = await Relatorio.findAll({
            where: { status: 'Pendente' },
            include: [{ model: Atleta, as: 'atleta' }],
        });

        res.json(relatoriosPendentes);
    } catch (error) {
        console.error('Erro ao buscar relatórios pendentes:', error);
        res.status(500).json({ error: 'Erro ao buscar relatórios pendentes.' });
    }
};

// Listar relatórios por atletaId
exports.getRelatoriosByAtletaId = async (req, res) => {
    const { atletaId } = req.params;

    try {
        const relatorios = await Relatorio.findAll({
            where: { atletaId },
            include: [
                { model: Atleta, as: 'atleta' },
                { model: Utilizador, as: 'utilizador' },
            ],
        });

        if (relatorios.length === 0) {
            return res.status(404).json({ error: 'Nenhum relatório encontrado para este atleta.' });
        }

        res.json(relatorios);
    } catch (error) {
        console.error('Erro ao buscar relatórios do atleta:', error);
        res.status(500).json({ error: 'Erro ao buscar relatórios do atleta.' });
    }
};
