const User = require('../model/User');

module.exports = {
    async store(req, res) {
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
    }
}