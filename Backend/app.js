const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Import Models
const taskSchema = new mongoose.Schema({
  taskId: Number,
  task: String,
  status: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
  dueDate: { type: Date }
});

const taskListSchema = new mongoose.Schema({
  listId: Number,
  listName: String,
  tasks: [taskSchema]
});

// Register models
mongoose.model("Tasks", taskSchema);
mongoose.model("Todo_list", taskListSchema);

// Import routes
const todoRoutes = require('./routes/todoRoutes');

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const mongoURI = "mongodb://localhost:27017/TodoDB";

mongoose.connect(mongoURI)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((error) => {
    console.error("Error connecting to MongoDB: ", error);
  });

// Use routes
app.use('/api/todos', todoRoutes);

// Start server
app.listen(PORT, () => {
  console.log("Server running on http://localhost:", PORT);
});