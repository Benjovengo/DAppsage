//const listBucketContents = require("../scripts/util/4everland")
const { listBucketContents, uploadFile4EverLand } = require("../scripts/util/4everland")


const { expect } = require("chai");
const { ethers } = require('hardhat')


describe("Message Data Storage", function () {
    // variables declaration
    let messagesData
    
    
    beforeEach(async () => {
        // Setup accounts - to get signers use `const signers = await ethers.getSigners()`
        [deployer, account01] = await ethers.getSigners()
        
        // Deploy MessagesData
        const MessagesData = await ethers.getContractFactory('MessagesData')
        messagesData = await MessagesData.connect(deployer).deploy()
    })
    
    
    it('Deployment address.', async () => {
        const result = await messagesData.address
        expect(result).to.not.equal(null)
        expect(result).to.not.equal('')
        expect(result).to.not.equal('0x')
        expect(result).to.not.equal(ethers.constants.AddressZero)
    })

    it('4everland interaction.', async () => {
        await uploadFile4EverLand()
        const result = await listBucketContents()
        console.log(result)
    })
});
