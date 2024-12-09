const Atleta = require('../models/Atleta');
const Time = require('../models/Time');
const { parse, isValid } = require('date-fns'); // Certifique-se de ter o pacote date-fns instalado

// Constantes para os status do atleta
const STATUSES = {
    PENDENTE: 'pendente',
    APROVADO: 'aprovado',
    REJEITADO: 'rejeitado',
    DESATIVADO: 'desativado'
};

// Função auxiliar para buscar atleta por ID
const getAtletaByIdHelper = async (id) => {
    try {
        return await Atleta.findByPk(id, { include: [Time] });
    } catch (error) {
        console.error('Erro ao buscar atleta por ID:', error);
        throw error;
    }
};

// Criar um novo atleta
exports.createAtleta = async (req, res) => {
    const { nome, dataNascimento, nacionalidade, posicao, clube, link, agente, contactoAgente } = req.body;

    // Validar e calcular o campo 'ano'
    const parsedDate = parse(dataNascimento, 'd/M/yyyy', new Date());
    if (!isValid(parsedDate)) {
        return res.status(400).json({
            error: true,
            message: 'Data de nascimento inválida. Use o formato correto (dia/mês/ano).'
        });
    }
    const ano = parsedDate.getFullYear();

    try {
        // Buscar o time pelo ID
        const time = await Time.findOne({ where: { id: clube } });

        if (!time) {
            return res.status(400).json({ error: true, message: 'Time não encontrado.' });
        }

        if (time.status.toLowerCase() !== 'aprovado') {
            return res.status(400).json({ error: true, message: 'O time não está aprovado.' });
        }

        const novoAtleta = await Atleta.create({
            nome,
            dataNascimento: parsedDate,
            ano,
            nacionalidade,
            posicao,
            clube: time.nome, // Armazena o nome do time
            link,
            agente,
            contactoAgente,
            timeId: time.id,
            status: STATUSES.PENDENTE,
        });

        res.status(201).json({
            message: 'Atleta criado com sucesso.',
            data: novoAtleta,
        });
    } catch (error) {
        console.error('Erro ao criar atleta:', error);
        res.status(500).json({ error: true, message: 'Erro ao criar atleta.' });
    }
};

// Atualizar status do atleta
const updateAtletaStatus = async (req, res, status) => {
    const { id } = req.params;
    try {
        const atleta = await getAtletaByIdHelper(id);
        if (atleta) {
            atleta.status = status;
            await atleta.save();
            res.json({ message: `Status do atleta atualizado para ${status}.`, atleta });
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar status do atleta:', error);
        res.status(500).json({ error: 'Erro ao atualizar status do atleta' });
    }
};

// Aprovar atleta
exports.aprovarAtleta = (req, res) => {
    updateAtletaStatus(req, res, STATUSES.APROVADO);
};

// Rejeitar atleta
exports.rejeitarAtleta = (req, res) => {
    updateAtletaStatus(req, res, STATUSES.REJEITADO);
};

// Colocar atleta como pendente
exports.pendenteAtleta = (req, res) => {
    updateAtletaStatus(req, res, STATUSES.PENDENTE);
};

// Desativar atleta
exports.desativarAtleta = (req, res) => {
    updateAtletaStatus(req, res, STATUSES.DESATIVADO);
};

// Mostrar todos os atletas
exports.getAllAtletas = async (req, res) => {
    try {
        const atletas = await Atleta.findAll({
            include: [Time]
        });
        res.json(atletas);
    } catch (error) {
        console.error('Erro ao buscar atletas:', error);
        res.status(500).json({ error: 'Erro ao buscar atletas' });
    }
};

// Mostrar um atleta pelo ID
exports.getAtletaById = async (req, res) => {
    const { id } = req.params;
    try {
        const atleta = await getAtletaByIdHelper(id);
        if (atleta) {
            res.json(atleta);
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao buscar atleta por ID:', error);
        res.status(500).json({ error: 'Erro ao buscar atleta' });
    }
};

// Editar um atleta
exports.updateAtleta = async (req, res) => {
    const { id } = req.params;
    const { nome, dataNascimento, ano, nacionalidade, posicao, clube, link, agente, contactoAgente, timeId } = req.body;

    try {
        const atleta = await getAtletaByIdHelper(id);
        if (atleta) {
            if (nome) atleta.nome = nome;
            if (dataNascimento) atleta.dataNascimento = parse(dataNascimento, 'd/M/yyyy', new Date());
            if (ano) atleta.ano = ano;
            if (nacionalidade) atleta.nacionalidade = nacionalidade;
            if (posicao) atleta.posicao = posicao;
            if (clube) atleta.clube = clube;
            if (link) atleta.link = link;
            if (agente) atleta.agente = agente;
            if (contactoAgente) atleta.contactoAgente = contactoAgente;
            if (timeId) atleta.timeId = timeId;

            await atleta.save();
            res.json(atleta);
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar atleta:', error);
        res.status(500).json({ error: 'Erro ao atualizar atleta' });
    }
};

// Deletar um atleta
exports.deleteAtleta = async (req, res) => {
    const { id } = req.params;
    try {
        const atleta = await getAtletaByIdHelper(id);
        if (atleta) {
            await atleta.destroy();
            res.status(204).send();
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao apagar atleta:', error);
        res.status(500).json({ error: 'Erro ao apagar atleta' });
    }
};
