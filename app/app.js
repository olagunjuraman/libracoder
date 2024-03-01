const express = require('express');
require("dotenv").config()
const { BlobServiceClient } = require('@azure/storage-blob');

const app = express();
const port = 3000; // You can choose any port

// Azure Blob Storage configuration
const AZURE_STORAGE_CONNECTION_STRING = process.env.AZURE_STORAGE_CONNECTION_STRING;
const containerName = 'content'; // Replace with your container name

async function listBlobs() {
  const blobServiceClient = BlobServiceClient.fromConnectionString(AZURE_STORAGE_CONNECTION_STRING);
  const containerClient = blobServiceClient.getContainerClient(containerName);
  let blobsList = [];

  for await (const blob of containerClient.listBlobsFlat()) {
    blobsList.push({
      name: blob.name,
      url: `https://${blobServiceClient.accountName}.blob.core.windows.net/${containerName}/${blob.name}`,
      properties: blob.properties
    });
  }

  return blobsList;
}

app.get('/blobs', async (req, res) => {
  try {
    const blobs = await listBlobs();
    res.json(blobs);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error retrieving blob list');
  }
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});

