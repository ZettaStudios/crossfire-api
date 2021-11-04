const express = require('express');
const app = express();
const morgan = require('morgan');
const database = require('./database/database');
const { getAllServers, getAllServersForUser, getServer } = require('./controller/servercontroller')
const { getUser, checkIfNameExists, updateNickname, getFeverOf } = require('./controller/usercontroller')
const { getAllBattle, getBattleStatistics } = require('./controller/battlecontroller')

app.use(morgan('dev'));

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header(
        'Access-Control-Allow-Header', 
        'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    );

    if(req.method === 'OPTIONS') {
        res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
        return res.status(200).send({});
    }
    next();
});

app.get('/server/unique/:id', getServer)
app.get('/server/all/', getAllServers);
app.get('/server/all/:id', getAllServersForUser);
app.get('/user/:username', getUser);
app.get('/user/fever/:id', getFeverOf)
app.get('/user/nickname/change/:id/:value', updateNickname)
app.get('/user/nickname/exists/:nickname', checkIfNameExists);
app.get('/battle/all/:id', getAllBattle)
app.get('/battle/statistics/:id', getBattleStatistics)

app.use((req, res, next) => {
    const error = new Error('Not found');
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    return res.send({
        error: {
            message: error.message
        }
    });
});

module.exports = app;