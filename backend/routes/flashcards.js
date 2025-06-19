const express = require('express');
const router = express.Router();
const { getFlashcards } = require('../controllers/flashcardController');

// GET /api/flashcards
router.get('/', getFlashcards);

module.exports = router; 