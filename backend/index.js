import express, { request, response } from "express";
import { PORT, mongoDBURL } from "./config.js";
import mongoose from 'mongoose';
import bookRoute from './routers/bookRoute.js';
import cors from 'cors';


const app = express();

// middleware to parse json request body
app.use(express.json());

// middle to handle CORS policy
// Option 1 : allow all origins with default of cors(*)
app.use(cors());
// Option 2 : custom origins
// app.use(cors({
//     origin: 'http://localhost:3000',
//     methods:['GET','POST','PUT','DELETE'],
//     allowHeaders: ['Content-Type'],
// }))

// hello world route
app.get('/',(request,response)=>{
    console.log(request);
    return response.status(234).send('Irashaimasen');
})

app.use('/books', bookRoute);

mongoose
    .connect(mongoDBURL)
    .then(() => {
        console.log('App connected to database');
        app.listen(PORT, ()=> {
            console.log(`App is listening to port : ${PORT}`);
        });
    })
    .catch((error) => {
        console.log(error);
    });

