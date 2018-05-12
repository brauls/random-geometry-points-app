import express from "express";
const app = express();

if (process.env.NODE_ENV === 'production') {
  app.use('/', express.static(__dirname + '/../client/build'));
}

app.get('/hello', (req, res) => {
  res.send('Hello world!')
});

app.listen(5000, () => {
  console.log('App listening on port 5000');
});
