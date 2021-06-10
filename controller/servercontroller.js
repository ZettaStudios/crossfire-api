var serverList = [
    {
        "address": "127.0.0.1",
        "name": "Rookie Server",
        "port": 10001,
        "type": 1,
        "nolimit": 2,
        "minrank": 0,
        "maxrank": 4,
        "players": 100,
        "limit": 300
    },
    {
        "address": "127.0.0.1",
        "name": "Alchemist - (BETA)",
        "port": 10002,
        "type": 1,
        "nolimit": 1,
        "minrank": 0,
        "maxrank": 100,
        "players": 20,
        "limit": 300
    },
    {
        "address": "127.0.0.1",
        "name": "Alchemist - (ALPHA)",
        "port": 10003,
        "type": 1,
        "nolimit": 2,
        "minrank": 4,
        "maxrank": 100,
        "players": 25,
        "limit": 300
    },
    {
        "address": "127.0.0.1",
        "name": "Ragnarok - (Vip only)",
        "port": 10004,
        "type": 1,
        "nolimit": 1,
        "minrank": 0,
        "maxrank": 100,
        "players": 0,
        "limit": 300
    },
    {
        "address": "127.0.0.1",
        "name": "Ragnarok - (Clan Server)",
        "port": 10005,
        "type": 2,
        "nolimit": 1,
        "minrank": 13,
        "maxrank": 100,
        "players": 0,
        "limit": 300
    },
];

module.exports = {
    getAllServersForUser: (req, res) => {
        console.log(req.params);
        res.send({
            "user": {},
            "servers": serverList
        });
    },
    getAllServers: (req, res) => {
        res.send(serverList);
    }
}