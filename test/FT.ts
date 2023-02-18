import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "ethers";

describe("FT", function () {
  const symbol = 'TFT'
  const name = 'TestFT'
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFT() {
    // Contracts are deployed using the first signer/account by default
    const FT = await ethers.getContractFactory("FT");
    const ft = await FT.deploy(name, symbol);

    return { ft };
  }

  describe("Deployment", function () {
    it("Should have right symbol", async function () {
      const { ft } = await loadFixture(deployFT);

      expect(await ft.symbol()).to.equal(symbol);
    });

    it("Should have right name", async function () {
      const { ft } = await loadFixture(deployFT);

      expect(await ft.name()).to.equal(name);
    });
  });

  describe("Mintable", function () {
    it("Should mintable by owner", async function () {
      const { ft } = await loadFixture(deployFT);
      const [owner] = await ethers.getSigners();
      const signedFt = ft.connect(owner)
      const amount = 100
      await signedFt.mint(owner.address, amount)

      expect(await ft.balanceOf(owner.address)).to.equal(amount);
    });

    it("Should mintable by owner for other account", async function () {
      const { ft } = await loadFixture(deployFT);
      const [owner, otherAccount] = await ethers.getSigners();
      const signedFt = ft.connect(owner)
      const amount = 1000
      await signedFt.mint(otherAccount.address, amount)

      expect(await ft.balanceOf(otherAccount.address)).to.equal(amount);
    });

    it("Should not mintable by other account", async function () {
      const { ft } = await loadFixture(deployFT);
      const [owner, otherAccount] = await ethers.getSigners();
      const signedFt = ft.connect(otherAccount)
      const amount = 100

      signedFt.mint(otherAccount.address, amount).catch(async (e) => {
        expect(await ft.balanceOf(owner.address)).to.equal(0);
      })
    });
  });

  describe("Pausable", function () {
    it("Should pause and resume by owner", async function () {
      const { ft } = await loadFixture(deployFT);
      const [owner, otherAccount] = await ethers.getSigners();
      const signedFt = ft.connect(owner)
      
      await signedFt.mint(owner.address, 1000)

      await signedFt.pause()

      signedFt.transfer(otherAccount.address, 100).catch( async (e)=>{
        expect(await ft.balanceOf(owner.address)).to.equal(1000);
        expect(await ft.balanceOf(otherAccount.address)).to.equal(0);
      })

      await signedFt.unpause()
      await signedFt.transfer(otherAccount.address, 100)
      expect(await ft.balanceOf(owner.address)).to.equal(900);
      expect(await ft.balanceOf(otherAccount.address)).to.equal(100);
    });

    it("Should not pausable by other account", async function () {
      
    });
  });
});
