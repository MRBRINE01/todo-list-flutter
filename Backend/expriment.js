const express = require('express');
const mongoose = require('mongoose');

const cors = require('cors');


const app = express();
const PORT = 5000;
app.use(cors());
app.use(express.json());

const mongoURI = "mongodb://localhost:27017/TodoDB";

mongoose.connect(mongoURI).then(()=>{
    console.log("connected to MongoDB")
}).catch((error)=>{
    console.error("Error connecting to MongoDB: ", error);
});


const taskSchema = new mongoose.Schema({
        taskId: Number, 
        task: String,
        status: {type: Boolean, default: false},
        createdAt: {type: Date, default: Date.now},
        dueDate: {type: Date, }
});

const taskListSchema = new mongoose.Schema({
  listId: Number,  
  listName: String, 
  tasks: [taskSchema]
});

 
const Task = mongoose.model("Tasks", taskSchema);
const Todo_list = mongoose.model("Todo_list", taskListSchema);

    //Add new list
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

    //Add new task
    app.post('/newTask/:listId', async (req, res) => {
      try{
        const listId = parseInt(req.params.listId, 10);

        const {task, status} = req.body;

        if(!task){
          return res.status(400).json({ error: "Task name is required" });
        }

        const list = await Todo_list.findOne({ listId: listId });
        if (!list) {
          return res.status(404).json({ error: "List not found" });
        }

        const lastTaskId = list.tasks.at(-1)?.taskId || 0;
        const newTaskId = lastTaskId + 1;


        const updatedList = await Todo_list.findOneAndUpdate(
          { listId: listId },
          { $push: { tasks: Task({taskId: newTaskId, task}) } },
        );

        res.status(200).json({ message: "Task added successfully", list: updatedList });
  } catch (error) {
    res.status(500).json({ error: "Error adding task", details: error.message });
  }
    });

    // Start Server
app.listen(PORT,()=>{
  console.log("Server running on http://localhost:", PORT);
});