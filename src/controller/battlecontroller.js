const Battle = require('../model/Battle');
const database = require('../database/database');

module.exports = {
    async getAllBattle (req, res) {
        const { id } = req.params;
        const data = await Battle.findAll({
            where: {
                user_id: id
            }
        });
        res.send({
            'status': data.length > 0 ? 302 : 404,
            'data': data.length > 0 ? data : {}
        });
    },
    async getBattleStatistics(req, res) {
        const { id } = req.params;
        let data = { };
        const options = {
            replacements: { id: id }
        }
        await database.query(
            'CALL BattleStatistics(:id)', 
            options
        )
        .then( v => {
            data = JSON.parse(JSON.stringify(v[0]));
        });
        res.send({
            'status': Object.keys(data).length > 0 ? 302 : 404,
            'data': Object.keys(data).length > 0 ? data : {}
        });
    }
}