const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = 5000;
app.use(express.json());

const mongoURI = "mongodb://localhost:27017/TodoDB";

mongoose.connect(mongoURI).then(()=>{
    console.log("connected to MongoDB")
}).catch((error)=>{
    console.error("Error connecting to MongoDB: ", error);
});


// var  listName = "trip";

// const taskSchema = new mongoose.Schema({
//     _id: Number,  
//     [listName]: [
//       {
//         id: Number, 
//         task: String,
//         status: {type: Boolean, default: false},
//         date: {type: Date, default: Date.now}
//       }
//     ]
// });

const taskListSchema = new mongoose.Schema({
  listId: Number,  
  listName: String, 
  tasks: [{}]
});

 
// const Task = mongoose.model("Tasks", taskSchema);
const Todo_list = mongoose.model("Todo_list", taskListSchema);

    app.post('/newList', async (req, res)=> {
      try {
        
        console.log("request body: ", req.body);

        const {listName} = req.body;

        if(!listName){
          return res.status(400).json({error: "List name is required"});
        }

        const lastList = await Todo_list.findOne().sort({listId: -1});
        const newListId = lastList ? lastList.listId + 1 : 1;

        const newList = new Todo_list({ listId: newListId, listName, tasks: [] });
        const savedTask = await newList.save();

        res.status(201).json({ message: "Task created successfully", task: savedTask });
      } catch (error) {
          res.status(500).json({ error: "Error creating task", details: error.message });
      }
    });

    // Start Server
app.listen(PORT,()=>{
  console.log("Server running on http://localhost:", PORT);
});