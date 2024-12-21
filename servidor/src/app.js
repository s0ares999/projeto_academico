const express = require('express');
const app = express();
const sequelize = require('./database'); // ajuste o caminho conforme necessário

// Importação de rotas
const utilizadoresRoutes = require('./routes/utilizadoresRoutes'); // ajuste o caminho conforme necessário
const timeRoutes = require('./routes/timeRoutes'); // ajuste o caminho conforme necessário
const atletaRoutes = require('./routes/atletaRoutes'); // ajuste o caminho conforme necessário
const scoutAtletaRoutes = require('./routes/scoutAtletaRoutes'); // Rota de associações entre scout e atleta
const relatorioRoutes = require('./routes/relatorioRoutes'); // Rota de relatórios
const authRoute = require('./routes/authRoutes'); // Rota de login
const equipeSombraRoutes = require('./routes/equipeSombraRoutes'); // Rota de equipes sombra
const formacaoRoutes = require('./routes/formacaoRoutes'); // Rota de formações
const atletasEquipeSombraRoutes = require('./routes/atletasEquipeSombraRoutes'); // ajuste o caminho conforme necessário
const partidaRoutes = require('./routes/partidaRoutes'); // ajuste o caminho conforme necessário


// Configurações
app.set('port', process.env.PORT || 3000);

// Middlewares
app.use(express.json());

// Configurar CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});

// Usar as rotas
app.use('/utilizadores', utilizadoresRoutes); // Define o prefixo da rota para utilizadores
app.use('/times', timeRoutes); // Define o prefixo da rota para times
app.use('/atletas', atletaRoutes); // Define o prefixo da rota para atletas
app.use('/scoutsAtletas', scoutAtletaRoutes); // Rota para associações entre scout e atleta
app.use('/relatorios', relatorioRoutes); // Adicione isso para usar as rotas de relatório
app.use('/auth', authRoute); // Rota de login
app.use('/equipeSombra', equipeSombraRoutes); // Rota para equipes sombra
app.use('/formacao', formacaoRoutes); // Rota para formações
app.use('/atletasEquipeSombra', atletasEquipeSombraRoutes);
app.use('/partidas', partidaRoutes); // Define o prefixo da rota para partidas


// Sincroniza os modelos com o banco de dados
sequelize.sync()
    .then(() => {
        console.log('Tabelas sincronizadas com o banco de dados.');
    })
    .catch((error) => {
        console.error('Erro ao sincronizar as tabelas:', error);
    });

// Iniciar o servidor
app.listen(app.get('port'), () => {
    console.log("Start server on port " + app.get('port'));
});
