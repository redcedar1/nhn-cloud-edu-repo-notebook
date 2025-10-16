const express = require('express');
const os = require('os');
const ip = require('ip');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 8080;

const podName = process.env.POD_NAME || 'Unknown Pod';
const podIP = ip.address();
const sidecars = (process.env.SIDECARS || '').split(',');

app.get('/', async (req, res) => {
  res.setHeader('Connection', 'close');

  const drinkMenu = process.env.DRINK_MENU || '비활성';
  const dessertMenu = process.env.DESSERT_MENU || '비활성';
  const coffeeRecipe = process.env.COFFEE_RECIPE || '비활성';
  const cakeRecipe = process.env.CAKE_RECIPE || '비활성';

  let deviceInfo = [];
  for (const sidecar of sidecars) {
    try {
      const response = await axios.get(`http://${sidecar}`);
      deviceInfo.push(`<li>${response.data}</li>`);
    } catch (err) {
      deviceInfo.push(`<li>${sidecar} 연결 실패</li>`);
    }
  }

  res.send(`
    <h1>🍱 ${podName} 푸드트럭</h1>
    <p>IP 주소: ${podIP}</p>
    <h3>보유 기기 목록</h3>
    <ul>${deviceInfo.join('')}</ul>
    <hr>
    <h3>📋 오늘의 메뉴</h3>
    ☕ 음료 메뉴: ${drinkMenu}<br>
    🍰 디저트 메뉴: ${dessertMenu}<br>
    <h3>📜 비밀 레시피</h3>
    ☕ 커피 레시피: ${coffeeRecipe}<br>
    🎂 케이크 레시피: ${cakeRecipe}
  `);
});

app.listen(PORT, () => {
  console.log(`foodcourt-web running on port ${PORT}`);
});
