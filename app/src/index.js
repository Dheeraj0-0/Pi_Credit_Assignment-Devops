const express = require('express');
const { Pool } = require('pg');

// Initialize Express App
const app = express();
const PORT = process.env.PORT || 3000;

// Database configuration from environment variables
// These will be injected by Azure Container Apps or Terraform later
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

// --- ROUTES ---

// 1. Root route
app.get('/', (req, res) => {
  res.send('<h1>Hello! Your web application is running.</h1>');
});

// 2. Health check route (required for the load balancer)
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// 3. Data route to test database connection
app.get('/data', async (req, res) => {
  try {
    const client = await pool.connect();
    // Query the database to get the current time
    const result = await client.query('SELECT NOW()');
    res.send(`Database connection successful! Current time from DB: ${result.rows[0].now}`);
    client.release();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error connecting to the database.');
  }
});

// --- START SERVER ---
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
