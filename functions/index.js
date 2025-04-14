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
  maxInstances: 10
}, async (req, res) => {
  try {
    const { input, systemPrompt } = req.body;
    
    if (!input || !systemPrompt) {
      res.status(400).json({ error: "Missing input or systemPrompt" });
      return;
    }

    const chatCompletion = await openai.chat.completions.create({
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
      max_tokens: 250
    });

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
