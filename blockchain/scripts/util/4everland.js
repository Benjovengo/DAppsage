require('dotenv').config()
const { S3 } = require('@aws-sdk/client-s3')
const { Upload } = require('@aws-sdk/lib-storage')
const fs = require('fs')

// 4everland Credentials
const endpoint = process.env.ENDPOINT
const accessKey = process.env.FOREVERLAND_API_KEY
const secretKey = process.env.FOREVERLAND_API_SECRET
const sessionToken = process.env.TOKEN

// Init s3 client
const s3 = new S3({
  endpoint,
  signatureVersion: 'v4',
  credentials: {
    accessKeyId: accessKey,
    secretAccessKey: secretKey,
    sessionToken
  },
  region: 'us-west-2'
})

// Bucket name in 4everland
const bucketName = 'benjovengo-bucket'

const uploadFile4EverLand = async () => {
  // multipart upload
  const params = {
    Bucket: bucketName,
    Key: 'CT_LOGO.png',
    Body: fs.createReadStream('./work/CT_LOGO.png'),
    ContentType: 'image'
  }
  try {
    const task = new Upload({
      client: s3,
      queueSize: 3, // 3 MiB
      params
    })
    await task.done()
  } catch (error) {
    if (error) {
      console.log('task', error.message)
    }
  }
}

/**
 * List the contents of a bucket.
 *
 * @returns objects the objects in the bucket.
 */
const listBucketContents = async () => {
  const objects = s3.listObjectsV2({ Bucket: bucketName })
  return objects
}

module.exports = { listBucketContents, uploadFile4EverLand }
