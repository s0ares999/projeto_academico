const Atleta = require('../models/Atleta'); // ajuste o caminho conforme necessário
const Time = require('../models/Time'); // ajuste o caminho conforme necessário

// Criar um novo atleta
exports.createAtleta = async (req, res) => {
    const { nome, dataNascimento, ano, nacionalidade, posicao, clube, link, agente, contactoAgente } = req.body;
    try {
        const time = await Time.findOne({ where: { nome: clube } });
        if (!time || time.status !== 'aprovado') {
            return res.status(400).json({ error: 'Time não encontrado ou não aprovado.' });
        }
        const novoAtleta = await Atleta.create({ 
            nome, 
            dataNascimento, 
            ano, 
            nacionalidade, 
            posicao, 
            clube, 
            link, 
            agente, 
            contactoAgente, 
            timeId: time.id, 
            status: 'pendente' // Define o status inicial como 'pendente'
        });
        res.status(201).json(novoAtleta);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao criar atleta' });
    }
};

// Função para atualizar o status do atleta
const updateAtletaStatus = async (req, res, status) => {
    const { id } = req.params;
    try {
        const atleta = await Atleta.findByPk(id);
        if (atleta) {
            atleta.status = status;
            await atleta.save();
            res.json({ message: `Status do atleta atualizado para ${status}.`, atleta });
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao atualizar status do atleta' });
    }
};

// Aprovar atleta
exports.aprovarAtleta = (req, res) => {
    updateAtletaStatus(req, res, 'aprovado');
};

// Rejeitar atleta
exports.rejeitarAtleta = (req, res) => {
    updateAtletaStatus(req, res, 'rejeitado');
};

// Colocar atleta como pendente
exports.pendenteAtleta = (req, res) => {
    updateAtletaStatus(req, res, 'pendente');
};

exports.desativarAtleta = (req, res) => {
    updateAtletaStatus(req, res, 'desativado');
};

// Mostrar todos os atletas
exports.getAllAtletas = async (req, res) => {
    try {
        const atletas = await Atleta.findAll({ include: [Time] });
        res.json(atletas);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar atletas' });
    }
};

// Mostrar um atleta pelo ID
exports.getAtletaById = async (req, res) => {
    const { id } = req.params;
    try {
        const atleta = await Atleta.findByPk(id, { include: [Time] });
        if (atleta) {
            res.json(atleta);
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar atleta' });
    }
};

// Editar um atleta
exports.updateAtleta = async (req, res) => {
    const { id } = req.params;
    const { nome, dataNascimento, ano, nacionalidade, posicao, clube, link, agente, contactoAgente, timeId } = req.body;
    try {
        const atleta = await Atleta.findByPk(id);
        if (atleta) {
            atleta.nome = nome;
            atleta.dataNascimento = dataNascimento;
            atleta.ano = ano;
            atleta.nacionalidade = nacionalidade;
            atleta.posicao = posicao;
            atleta.clube = clube;
            atleta.link = link;
            atleta.agente = agente;
            atleta.contactoAgente = contactoAgente;
            atleta.timeId = timeId;
            await atleta.save();
            res.json(atleta);
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao atualizar atleta' });
    }
};

// Deletar um atleta
exports.deleteAtleta = async (req, res) => {
    const { id } = req.params;
    try {
        const atleta = await Atleta.findByPk(id);
        if (atleta) {
            await atleta.destroy();
            res.status(204).send();
        } else {
            res.status(404).json({ error: 'Atleta não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao apagar atleta' });
    }
};
