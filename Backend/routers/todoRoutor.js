const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

// Import models (assuming they're defined in separate files)
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
router.delete('/deleteList/:listId', async (req,res) => {
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
router.delete('/deleteTask/:listId/:taskId', async (req, res) => {
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
  router.put('/editList/:listId', async (req,res) => {
    try{
    const listId = parseInt(req.params.listId, 10);

    const { listName } = req.body;

    if (!listName) {
      return res.status(400).json({ error: "List name is required" });
    }

    const updatedListName = await Todo_list.findOneAndUpdate(
      {listId: listId},
      {$set : {listName: listName}},
    );

    if(!updatedListName){
      return res.status(404).json({error: "List not found"});
    }

    res.status(200).json({
      message: "List name updated successfully",
      list: updatedListName
    });
  }
    catch(err){
      res.status(500).json({ error: "Error editing the name", details: err.message});
    }
  });


  //Edit Task
  router.put('/editTask/:listId/:taskId', async (req,res) => {
    try{
    const listId = parseInt(req.params.listId, 10);
    const taskId = parseInt(req.params.taskId, 10);

    const { task } = req.body;
    const { status } = req.body;
    const { dueDate } = req.body;

    if (!task) {
      return res.status(400).json({ error: "Task name is required" });
    }
    if (!status) {
      return res.status(400).json({ error: "Status is required" });
    }

    const updatedTask = await Todo_list.findOneAndUpdate(
      {listId: listId, "tasks.taskId": taskId},
      {$set : {"tasks.$.task": task, "tasks.$.status": status, "tasks.$.dueDate": dueDate}},
      {new: true}
    );

    if(!updatedTask){
      return res.status(404).json({error: "List or task not found not found"});
    }

    res.status(200).json({
      message: "Task updated successfully",
      list: updatedTask
    });
  }
    catch(err){
      res.status(500).json({ error: "Error editing Task", details: err.message});
    }
  });

  //get list
  router.get('/lists', async (req, res) => {
    try {
      const lists = await Todo_list.find();
      res.status(200).json({ message: 'Lists retrieved successfully', lists });
    } catch (error) {
      res.status(500).json({ error: 'Error retrieving lists', details: error.message });
    }
  });

module.exports = router;