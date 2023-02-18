import '@nomiclabs/hardhat-ethers';
import { ethers } from "hardhat";

async function main() {
  const FT = await ethers.getContractFactory("FT");
  const ft = await FT.deploy("CBI", "CUIT");

  await ft.deployed();
  console.log(`FT deployed to ${ft.address}`);

  const [owner, otherAccount] = await ethers.getSigners();
  // console.log(`Owner address is ${owner.address}, other account address is ${otherAccount.address}`)
  const signedFT = ft.connect(owner);
  console.log(`balance of other account is ${await ft.balanceOf(otherAccount.address)}`)
  await signedFT.mint(otherAccount.address, 100)
  console.log(`balance of other account is ${await ft.balanceOf(otherAccount.address)}`)
  const signedFTByAccount2 = ft.connect(otherAccount)
  await signedFTByAccount2.burn(50)
  console.log(`balance of other account is ${await ft.balanceOf(otherAccount.address)}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
