// imports
const express = require('express');
const createErrors = require('http-errors');
const fileController = require('../controllers/file.controller');

// endpoints
router.post('/', validateUserReq, fileController.uploadFile);


// exports
module.exports = router;