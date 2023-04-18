const { listBucketContents, uploadFile4EverLand } = require('../scripts/util/4everland')

const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Message Data Storage', function () {
  // variables declaration
  let messageData
  let deployer

  beforeEach(async () => {
    // Setup accounts - to get signers use `const signers = await ethers.getSigners()`
    [deployer] = await ethers.getSigners()
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

  it('4everland interaction.', async () => {
    await uploadFile4EverLand()
    const result = await listBucketContents()
    expect(result.Contents.length).to.not.equal(0)
  })
})
