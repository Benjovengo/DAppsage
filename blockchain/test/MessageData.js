const { listBucketContents, uploadFile4EverLand } = require('../scripts/util/4everland')

const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Message Data Storage', function () {
  // variables declaration
  let messageData
  let deployer, user01

  beforeEach(async () => {
    // Setup accounts - to get signers use `const signers = await ethers.getSigners()`
    [deployer, user01] = await ethers.getSigners()
    // Deploy MessageData
    const MessageData = await ethers.getContractFactory('MessageData')
    messageData = await MessageData.connect(deployer).deploy()
  })

  it('Deployment address.', async () => {
    const result = await messageData.address
    expect(result).to.not.equal(null)
    expect(result).to.not.equal('')
    expect(result).to.not.equal('0x')
    expect(result).to.not.equal(ethers.constants.AddressZero)
  })

  /* it('4everland interaction.', async () => {
    await uploadFile4EverLand()
    const result = await listBucketContents()
    expect(result.Contents.length).to.not.equal(0)
  }) */

  it('Store and retrieve a tweet message.', async () => {
    const messageStringToStore = 'Fábio Pereira Benjovengo\' first tweet'
    await messageData.storeMessage(user01.address, messageStringToStore)
    const numberOfMessages = await messageData.totalNumberOfStoredMessages()
    const messageId = 1 // Id of the message to be fetched
    const fetchedMessage = await messageData.fetchMessage(messageId)
    const textMessage = ethers.utils.toUtf8String(fetchedMessage.textMessage)
    expect(Number(numberOfMessages)).to.equal(1)
    expect(textMessage).to.equal(messageStringToStore)
    expect(fetchedMessage.composer).to.equal(user01.address)
    expect(fetchedMessage.owner).to.equal(user01.address)
  })
})
