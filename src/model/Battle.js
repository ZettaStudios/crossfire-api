const { Model, DataTypes } = require('sequelize');
class Battle extends Model {
    static init(connection) {
        super.init({
            gamemode: DataTypes.INTEGER,
            map: DataTypes.SMALLINT,
            won: DataTypes.INTEGER,
            assists: DataTypes.INTEGER,
            desertion: DataTypes.INTEGER,
            granade: DataTypes.INTEGER,
            headshot: DataTypes.INTEGER,
            knife: DataTypes.INTEGER,
            totaldeaths: DataTypes.INTEGER,
            totalkills: DataTypes.INTEGER
        }, {
            sequelize: connection
        })
    }
}

module.exports = Battle;