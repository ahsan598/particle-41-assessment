// SimpleTimeService: Returns current timestamp and client IP address
// Express.js microservice

import express from "express";

const app = express();

// Trust proxy for correct client IP detection (important for Docker / K8s / Load balancers)
app.set("trust proxy", true);

// Endpoint to get current timestamp and client IP
app.get("/", (req, res) => {
  const ip =
    req.headers["x-forwarded-for"]?.split(",")[0].trim() ||
    req.headers["x-real-ip"] ||
    req.socket.remoteAddress;

// Respond with JSON containing timestamp and IP address
  res.json({
    timestamp: new Date().toISOString(),
    ip
  });
});

// Health check endpoint (recommended for Kubernetes / Docker)
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// Graceful shutdown handling
const server = app.listen(process.env.PORT || 8080, () => {
  console.log(`SimpleTimeService running on port ${process.env.PORT || 8080}`);
});

process.on("SIGTERM", () => {
  console.log("Shutting down gracefully...");
  server.close(() => process.exit(0));
});
