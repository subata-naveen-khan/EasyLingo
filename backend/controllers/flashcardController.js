const { executeQuery } = require('../utils/database');

const getFlashcards = async (req, res) => {
  console.log('Received request for flashcards');
  try {
    console.log('Executing database query...');
    const result = await executeQuery(
      `SELECT * 
       FROM flashcards`
    );
    console.log('Query successful, rows returned:', result.rows.length);
    res.json(result.rows);
  } catch (err) {
    console.error('Error in getFlashcards:', err);
    console.error('Error stack:', err.stack);
    res.status(500).json({ 
      error: "Failed to fetch flashcards",
      details: err.message 
    });
  }
};

module.exports = {
  getFlashcards
}; 