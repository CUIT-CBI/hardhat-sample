import '@nomiclabs/hardhat-ethers';
import { ethers } from "hardhat";

async function main() {
  const Banker = await ethers.getContractFactory("Banker");
  const banker = await Banker.deploy();

  await banker.deployed();

  const Attacker = await ethers.getContractFactory("Attacker");
  const attacker = await Attacker.deploy(banker.address);

  await attacker.deployed();

  const [ user1, user2 ] = await ethers.getSigners();
  const signedBanker1 = banker.connect(user1);
  await signedBanker1.deposit({ value: ethers.utils.parseEther("10") });


  const signedAttacker = attacker.connect(user2);
  await signedAttacker.deposit({ value: ethers.utils.parseEther("1") });
  await signedAttacker.attack();

  let balance = await signedBanker1.getBalance();
  console.log(balance);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
