require('dotenv').config()
const { S3 } = require("@aws-sdk/client-s3")
const { Upload } = require("@aws-sdk/lib-storage")


// 4everland Credentials
const endpoint = process.env.ENDPOINT
const accessKey = process.env.FOREVERLAND_API_KEY
const secretKey = process.env.FOREVERLAND_API_SECRET
const sessionToken = process.env.TOKEN

// Init s3 client
const s3 = new S3({
  endpoint,
  signatureVersion: "v4",
  credentials: {
    accessKeyId: accessKey,
    secretAccessKey: secretKey,
    sessionToken,
  },
  region: "us-west-2",
});


/**
 * List the contents of a bucket.
 * 
 * @returns objects the objects in the bucket.
 */
const listBucketContents = async () => {
  const bucketName = "benjovengo-bucket"
  const objects = s3.listObjectsV2({ Bucket: bucketName });
  
  return objects
}

module.exports = listBucketContents

