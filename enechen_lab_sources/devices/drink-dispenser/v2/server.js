const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('❌ drink-dispenser v2 오류 발생!');
});

app.listen(PORT, () => {
  console.log('drink-dispenser v2 running on port ' + PORT);
});
