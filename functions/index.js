require('dotenv').config();
const { onRequest } = require("firebase-functions/v2/https");
const OpenAI = require("openai");
const cors = require("cors")({ origin: true });

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

exports.generateLinkedInPost = onRequest({
  timeoutSeconds: 300,
  memory: "1GiB",
  region: "us-central1",
  cors: true,
  maxInstances: 10,
  minInstances: 0,
  invoker: 'public',  // Restrict to authenticated users if needed
  concurrency: 100,   // Maximum concurrent executions
  rateLimit: {
    maxConcurrent: 50,  // Maximum concurrent requests per user/IP
    periodSeconds: 60   // Time window for rate limiting
  }
}, async (req, res) => {
  // Validate request method
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  // Validate content type
  if (!req.headers['content-type']?.includes('application/json')) {
    res.status(400).json({ error: 'Invalid content type' });
    return;
  }
  try {
    const { input, systemPrompt } = req.body;
    
    // Input validation
    if (!input || typeof input !== 'string') {
      res.status(400).json({ error: 'Invalid input' });
      return;
    }

    if (!systemPrompt || typeof systemPrompt !== 'string') {
      res.status(400).json({ error: 'Invalid system prompt' });
      return;
    }

    // Sanitize input
    const sanitizedInput = input.trim();
    const sanitizedSystemPrompt = systemPrompt.trim();

    if (!sanitizedInput || !sanitizedSystemPrompt) {
      res.status(400).json({ error: "Missing input or systemPrompt" });
      return;
    }

    // Add request timeout
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Request timeout')), 25000);
    });

    const chatCompletion = await Promise.race([
      openai.chat.completions.create({
      model: "gpt-4o",
      temperature: 1.1,
      messages: [
        {
          role: "system",
          content: systemPrompt
        },
        {
          role: "user",
          content: input
        }
      ],
      max_tokens: 250,
      user: req.headers['x-forwarded-for'] || req.ip, // Track requests by IP
      presence_penalty: 0.6,
      frequency_penalty: 0.5
    }),
    timeoutPromise
  ]);

    if (!chatCompletion.choices || chatCompletion.choices.length === 0) {
      res.status(500).json({ error: "No response from OpenAI" });
      return;
    }

    const responseText = chatCompletion.choices[0].message.content;
    res.status(200).json({
      text: responseText,
      usage: chatCompletion.usage
    });
  } catch (error) {
    console.error("Error generating post:", error);
    res.status(500).json({ error: error.message });
  }
});
