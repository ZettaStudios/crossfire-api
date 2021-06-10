var oreki = {
    "id": 10521506,
    "nickname": "Gotrax",
    "password": "$2y$12$.eCm/D/7Ba2OaDVTPjcFfuinAvy4QVj1y0TmBwR3wzbNY4QcnNX2q",
    "kills": 27,
    "deaths": 33,
    "rank": 1
};
module.exports = {
    getUser: (req, res) => {
        const { login } = req.params;
        res.send({
            'status': login.toLowerCase() == 'oreki' ? 302 : 404,
            'data': login.toLowerCase() == 'oreki' ? oreki : {}
        });
    }
}