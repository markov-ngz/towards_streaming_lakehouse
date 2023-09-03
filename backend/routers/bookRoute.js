import { Book } from '../models/bookModel.js';
import express from 'express';

const router = express.Router();

// Add a route to save a book 
router.post('/',async(request,response) => {
    try {
        // send error msg if  missing fields
        if (
            !request.body.title ||
            !request.body.author ||
            !request.body.publishYear
        ){
            return response.status(400).send({
                message : 'Send all required fields : title, author, publishYear',
            }); 
        }
        // instantiate the book object
        const newBook = {
            title : request.body.title,
            author : request.body.author,
            publishYear : request.body.publishYear,
        };

        // from the body creates a book object and assign it to the book variable
        const book = await Book.create(newBook); 

        return response.status(201).send(book);

    }catch(error){
        console.log(error.message);
        response.status(500).send({message:error.message});
    }
});

router.get('/', async(request, response) => {
    try{
        const books = await Book.find({});

        return response.status(200).json({
            count : books.length,
            data : books
        });

    }catch(error){
        console.log(error.message);
        response.status(500).send({message:error.message});
    }
})

// route to get one book
router.get('/:id', async(request, response) => {
    
    try{

        const { id } = request.params ; 

        const book = await Book.findById(id);

        return response.status(200).json(book);

    }catch(error){
        console.log(error.message);
        response.status(500).send({message:error.message});
    }
});

// route to update a book
router.put('/:id',async(request, response) => {
    
    try{
                // send error msg if  missing fields
                if (
                    !request.body.title ||
                    !request.body.author ||
                    !request.body.publishYear
                ){
                    return response.status(400).send({
                        message : 'Send all required fields : title, author, publishYear',
                    }); 
                }

        const { id } = request.params ; 

        const result = await Book.findByIdAndUpdate(id, request.body);

        if (!result){
            return response.status(404).json({message : 'Ressource not found '});
        }

        return response.status(200).send({ message :" Updated", data : request.body});

    }catch(error){
        console.log(error.message);
        response.status(500).send({message:error.message});
    }
}

);

// route to delete a book
router.delete('/:id',async(request, response) => {
    
    try{

        const { id } = request.params ; 

        const result = await Book.findByIdAndDelete(id);

        if (!result){
            return response.status(404).json({message : 'Ressource not found '});
        }

        return response.status(200).send({ message :"Deleted"});

    }catch(error){
        console.log(error.message);
        response.status(500).send({message:error.message});
    }
}
    
);

export default router ; 