const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

// Import models (assuming they're defined in separate files)
const Task = mongoose.model("Tasks");
const Todo_list = mongoose.model("Todo_list");

// Add new list
router.post('/newList', async (req, res) => {
  try {
    console.log("request body: ", req.body);

    const { listName } = req.body;

    if (!listName) {
      return res.status(400).json({ error: "List name is required" });
    }

    const lastList = await Todo_list.findOne().sort({ listId: -1 });
    const newListId = lastList ? lastList.listId + 1 : 1;

    const newList = new Todo_list({ listId: newListId, listName, tasks: [] });
    const savedTask = await newList.save();

    res.status(201).json({ message: "Task created successfully", task: savedTask });
  } catch (error) {
    res.status(500).json({ error: "Error creating task", details: error.message });
  }
});

// Add new task
router.post('/newTask/:listId', async (req, res) => {
  try {
    const listId = parseInt(req.params.listId, 10);

    const { task, status } = req.body;

    if (!task) {
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
      { $push: { tasks: { taskId: newTaskId, task } } },
      { new: true }
    );

    res.status(200).json({ message: "Task added successfully", list: updatedList });
  } catch (error) {
    res.status(500).json({ error: "Error adding task", details: error.message });
  }
});

// Delete a list
router.delete('/list/:listId', async (req,res) => {
    try{
    const listId = parseInt(req.params.listId, 10);

    const result = await Todo_list.findOneAndDelete({listId: listId});
    
    if(!result){
        return res.status(404).json({error: "List not found"});
    }

    return res.status(200).json({message: "List deleted successfully"});
    }
    catch(err){
        return res.status(500).json({error: "Error deleting the list", details: err.message})
    }
});

// Delete a task from a list
router.delete('/task/:listId/:taskId', async (req, res) => {
    try {
      const listId = parseInt(req.params.listId, 10);
      const taskId = parseInt(req.params.taskId, 10);
      
      // Find the list and remove the task from the tasks array
      const updatedList = await Todo_list.findOneAndUpdate(
        { listId: listId },
        { $pull: { tasks: { taskId: taskId } } },
        { new: true }
      );
      
      if (!updatedList) {
        return res.status(404).json({ error: "List not found" });
      }
      
      res.status(200).json({ 
        message: "Task deleted successfully", 
        list: updatedList 
      });
    } catch (error) {
      res.status(500).json({ error: "Error deleting task", details: error.message });
    }
  });


  //Edit list name
  

module.exports = router;