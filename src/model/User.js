const { Model, DataTypes } = require('sequelize');
class User extends Model {
    static init(connection) {
        super.init({
            username: DataTypes.STRING,
            password: DataTypes.STRING,
            type: DataTypes.INTEGER,
            name: DataTypes.STRING,
            exp: DataTypes.INTEGER,
            level: DataTypes.INTEGER,
            gp: DataTypes.INTEGER,
            zp: DataTypes.INTEGER,
            tutorial_done: DataTypes.INTEGER,
            coupons_owned: DataTypes.INTEGER,
            lastip: DataTypes.STRING,
            lastguid: DataTypes.STRING,
            kills: DataTypes.INTEGER,
            deaths: DataTypes.INTEGER,
        }, {
            sequelize: connection
        })
    }
}

module.exports = User;