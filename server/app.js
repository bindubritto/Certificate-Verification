// imports
const express = require('express');
const createErrors = require('http-errors');
const cors = require('cors');

// imporitng routes
const userRoute = require('./routes/user.route');

// constants
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
    origin: '*'
  }));

// defining routes
app.get('/', (req, res) => {
    res.send({msg: 'Hello from backend'});
});

app.use('/api/v1/user', userRoute);

// handle wildcard route
app.use(async(req, res, next) => {
    next(createErrors.NotFound('This route does not exists!'));
});

// handle errors
app.use((err, req, res, next) => {

    if( err.name == "ValidationError" ) {
        err.status = 400;
    }

    res.status(err.status || 500);
    res.send({
        error: {
            status: err.status || 500,
            message: err.message || 'Internal server error'
        }
    });
});

module.exports = app;