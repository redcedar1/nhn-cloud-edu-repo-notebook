const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('❌ dough-mixer v2 오류 발생!');
});

app.listen(PORT, () => {
  console.log('dough-mixer v2 running on port ' + PORT);
});
