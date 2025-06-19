const express = require('express');
const cors = require('cors');
const app = express();
const port = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const flashcardsRouter = require('./routes/flashcards');
app.use('/api/flashcards', flashcardsRouter);

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    const { executeQuery } = require('./utils/database');
    await executeQuery(`SELECT 1 FROM DUAL`);
    res.status(200).json({ status: "OK" });
  } catch (err) {
    res.status(500).json({ status: "DB error", error: err.message });
  }
});

app.get('/test_table', async (req, res) => {
  try {
    const { executeQuery } = require('./utils/database');
    const result = await executeQuery(`SELECT * FROM test_table`);
    res.status(200).json(result.rows);
  } catch (err) {
    console.error('Error in test_table endpoint:', err);
    res.status(500).json({ 
      error: "Failed to fetch test table data",
      details: err.message 
    });
  }
});

// Listen on all network interfaces
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
  console.log(`Local: http://localhost:${port}`);
  console.log(`Emulator: http://10.0.2.2:${port}`);
});
