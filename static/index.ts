import 'dotenv/config'
import express from 'express';
import bodyParser from 'body-parser'

const server = express();
const port = process.env.PORT || 8080;

server.use(bodyParser.json())

server.listen(port, () => {
  return console.log(`Server is running on http://localhost:${port}/`);
});
