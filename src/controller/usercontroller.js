const User = require('../model/User');
const database = require('../database/database');

module.exports = {
    async updateNickname(req, res) {
        const { id, value } = req.params;
        let data = { };
        const options = {
            replacements: { id: id, value: value }
        }
        await database.query(
            'UPDATE users SET name = :value WHERE id = :id', 
            options
        )
        .then( v => {
            data = JSON.parse(JSON.stringify(v[0]));
        });
        res.send({
            result: data.affectedRows > 0 && data.changedRows > 0
        });
    },
    async checkIfNameExists(req, res) {
        const { nickname } = req.params;
        let data = { };
        const options = {
            replacements: { nickname: nickname }
        }
        await database.query(
            'CALL CheckNameExists(:nickname)', 
            options
        )
        .then( v => {
            data = JSON.parse(JSON.stringify(v[0]));
        });
        res.send(data);
    },
    async getUser (req, res) {
        const { username } = req.params;
        const user = await User.findAll({
            where: {
                username: username
            }
        });
        res.send({
            'status': user.length > 0 ? 302 : 404,
            'data': user.length > 0 ? user[0] : {}
        });
    },
    async getFeverOf(req, res) {
        // const { id } = req.params;
        res.send({
            percent: 15,
            progress: 1,
            activated: true,
            duration: 0,
            activatedAt: new Date().toJSON(),
        });
    }
}