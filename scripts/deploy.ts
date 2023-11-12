import '@nomiclabs/hardhat-ethers';
import { ethers } from "hardhat";

async function main() {
  const Banker = await ethers.getContractFactory("Banker");
  const banker = await Banker.deploy();

  await banker.deployed();

  const [ user1 ] = await ethers.getSigners();
  const signedBanker = banker.connect(user1);

  await signedBanker.deposit({ value: ethers.utils.parseEther("1") });

  let balance = await signedBanker.balanceOf(user1.address);
  console.log(balance);

  await signedBanker.withdraw(balance);

  balance = await signedBanker.balanceOf(user1.address);
  console.log(balance);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
