const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('✅ coffee-machine v1 정상 동작 중');
});

app.listen(PORT, () => {
  console.log('coffee-machine v1 running on port ' + PORT);
});
