// imports
const express = require('express');
const createErrors = require('http-errors');
const userService = require('../services/user.service');
const { User } = require('../models/user.model');
const { isValidObjectId, trimAllObjValue } = require('../utils');
const { create } = require('domain');

const uploadFile = async(req, res, next) => {
    try {
        
        trimAllObjValue(req.body);
        let userBody = req.body;

        const savedUser = await userService.createUser(userBody)
        res.status(201).send(savedUser);

    } catch (error) {
        next(error);
    }
}

 // exports
 module.exports = {
    uploadFile
 }