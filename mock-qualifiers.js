const jsonServer = require('json-server');

const server = jsonServer.create();
const middlewares = jsonServer.defaults();

// Set default middlewares (logger, static, cors and no-cache)
server.use(middlewares);
server.use(jsonServer.bodyParser);

// Add custom routes before JSON Server router
server.post('/abuse-q', (req, res) => {
  if (req.body.status.indexOf('bad') >= 0) {
    res.json({ result: true });
  }
  else {
    res.json({ result: false });
  }
});
server.post('/soccer-q', (req, res) => {
  console.log(req.body);
  if (req.body.status.indexOf('soc') >= 0) {
    res.json({ result: true });
  }
  else {
    res.json({ result: false });
  }
});

server.get('/echo', (req, res) => {
  res.jsonp(req.query);
});

server.listen(4001, () => {
  console.log('JSON Server is running');
});
