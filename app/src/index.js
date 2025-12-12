// SimpleTimeService: Returns current timestamp and client IP address

// Usage of Express.js framework, listens on port 8080 by default
const express = require("express");
const app = express();

// Trust proxy for correct IP detection
app.set('trust proxy', true);

// Endpoint to get current timestamp and client IP
app.get("/", (req, res) => {
  const ip =
    req.headers["x-forwarded-for"]?.split(",")[0].trim() ||
    req.headers["x-real-ip"] ||
    req.socket.remoteAddress;

// Respond with JSON containing timestamp and IP address
  res.json({
    timestamp: new Date().toISOString(),
    ip: ip
  });
});

// Start the server on specified port
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`SimpleTimeService running on port ${PORT}`);
});
