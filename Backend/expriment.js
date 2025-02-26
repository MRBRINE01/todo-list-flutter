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


var  listName = "trip";

const taskSchema = new mongoose.Schema({
    _id: Number,  
    [listName]: [
      {
        id: Number, 
        task: String,
        status: {type: Boolean, default: false},
        date: {type: Date, default: Date.now}
      }
    ]
});


 
const Task = mongoose.model("Tasks", taskSchema);


// const listSchema = new mongoose.Schema({
//     [listName]: [taskSchema] 
//   });

//   const listModel = mongoose.model(listName , listSchema);

Task.create({
    _id : 2,
    [listName]: [
      { id: 4, task: "brush"},
      { id: 5, task: "pen"},
      { id: 6, task: "coffee"}
    ]
  }).then(() => console.log("Homework added"))
    .catch(err => console.error(err));