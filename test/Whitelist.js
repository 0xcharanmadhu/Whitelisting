const { expect } = require("chai");

describe("Whitelist", function () {
    let Whitelist, whitelist, owner, addr1, addr2, addr3, addr4;

 beforeEach(async function () {
    Whitelist = await ethers.getContractFactory("Whitelist");
    [owner, addr1, addr2, addr3,addr4] = await ethers.getSigners();
    whitelist = await Whitelist.deploy();
 });

 describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await whitelist.getOwner()).to.equal(owner.address);
    });

    it("Should initialize the counter to 0", async function () {
      expect(await whitelist.getWhitelistCount()).to.equal(0);
    });
 });

 describe("Admin Functions", function () {
    it("Should update admin address", async function () {
      await whitelist.updateAdmin(addr1.address);
      expect(await whitelist.getAdminAddress()).to.equal(addr1.address);
    });

    it("Should not allow non-owner to update admin", async function () {
      await expect(whitelist.connect(addr1).updateAdmin(addr2.address)).to.be.revertedWith("Only Owner of this contract can perform this action!");
    });

    it("Should update referral cooldown", async function () {
      await whitelist.updateAdmin(addr1.address); // Ensure addr1 is the admin
      await whitelist.connect(addr1).updateReferralCooldown(60);
      expect(await whitelist.getCooldownTime()).to.equal(60);
    });

    it("Should not allow non-admin to update referral cooldown", async function () {
      await expect(whitelist.connect(addr1).updateReferralCooldown(60)).to.be.revertedWith("Only admin of this contract can perform this action!");
    });
 });

 describe("Whitelist Functions", function () {
    it("Should allow admin to directly whitelist an address", async function () {
      await whitelist.updateAdmin(addr1.address);
      await whitelist.connect(addr1).directWhitelist(addr2.address, true);
      const whitelistData = await whitelist.getWhitelist(addr2.address);
      expect(whitelistData.status).to.equal(true);
    });

    it("Should not allow non-whitelisted user to refer", async function () {
      await expect(whitelist.connect(addr2).referWhitelist(addr3.address)).to.be.revertedWith("Only whitelisted users can perform this action!");
    });

    it("Should allow whitelisted user to refer another user", async function () {
      await whitelist.updateAdmin(addr1.address);
      await whitelist.connect(addr1).directWhitelist(addr2.address, true);
      await whitelist.connect(addr2).referWhitelist(addr3.address);
      const whitelistData = await whitelist.getWhitelist(addr3.address);
      expect(whitelistData.status).to.equal(true);
      expect(whitelistData.referrer).to.equal(addr2.address);
    });

    it("Should not allow referral if referrer is on cooldown", async function () {
        await whitelist.updateAdmin(addr1.address);
        await whitelist.connect(addr1).directWhitelist(addr2.address, true);
        await whitelist.connect(addr2).referWhitelist(addr3.address);
        await expect(whitelist.connect(addr2).referWhitelist(addr4.address)).to.be.revertedWith("Referrer is on cooldown");
    });
 });
});
