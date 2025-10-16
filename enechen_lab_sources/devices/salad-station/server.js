const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('✅ salad-station v1 정상 동작 중');
});

app.listen(PORT, () => {
  console.log('salad-station v1 running on port ' + PORT);
});
