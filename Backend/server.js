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

const taskSchema = new mongoose.Schema({
    id: {type: Number},
    task: {type : String,
        require: true
    },
    date: {type:Date, default: Date.now},
    status: {type: Boolean, default: false},
});

const Task = mongoose.model("Tasks", taskSchema);


app.post('/tasks', async (req, res)=>{
    try{

        console.log("Request body:", req.body);

        const { task } = req.body;

        if(!task){
            return res.status(400).json({error: "Task is required"});
        }

        const newTask = new Task({ task });
        const savedTask = await newTask.save();

        res.status(201).json({ message: "Task created successfully", task: savedTask });
    } catch (error) {
        res.status(500).json({ error: "Error creating task", details: error.message });
    }
});

// Start Server
app.listen(PORT,()=>{
    console.log("Server running on http://localhost:", PORT);
});