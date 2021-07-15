const Sequelize = require('sequelize');
const dbConfig = require('./config');

const User = require('../model/User');
const Battle = require('../model/Battle');

const connection = new Sequelize(dbConfig);

User.init(connection);
Battle.init(connection);

module.exports = connection;