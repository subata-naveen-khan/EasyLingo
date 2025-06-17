const express = require('express');
const oracledb = require('oracledb');
const app = express();
const port = 3001;

app.use(express.json());

const dbConfig = {
  user: "c##easylingo",
  password: "123",
  connectString: "localhost:1521/orcl", 
};

app.get('/test_table', async (req, res) => {
  let conn;
  try {
    conn = await oracledb.getConnection(dbConfig);
    const result = await conn.execute(`SELECT * FROM test_table`, [], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("DB error");
  } finally {
    if (conn) await conn.close();
  }
});

app.get('/flashcards', async (req, res) => {
  let conn;
  try {
    conn = await oracledb.getConnection(dbConfig);
    const result = await conn.execute(
      `SELECT id, front_text, back_text, category, difficulty_level 
       FROM flashcards 
       ORDER BY id`,
      [],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch flashcards" });
  } finally {
    if (conn) await conn.close();
  }
});

app.listen(port, () => console.log(`Server running on port ${port}`));

app.get('/health', async (req, res) => {
  try {
    const conn = await oracledb.getConnection(dbConfig);
    await conn.execute(`SELECT 1 FROM DUAL`);
    await conn.close();
    res.status(200).json({ status: "OK" });
  } catch (err) {
    res.status(500).json({ status: "DB error", error: err.message });
  }
});
