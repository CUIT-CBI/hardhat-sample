import '@nomiclabs/hardhat-ethers';
import { ethers } from "hardhat";

async function main() {
  // const CBI = await ethers.getContractFactory("CBI");
  // const cbi = await CBI.deploy("CBI", "CUIT");

  // await cbi.deployed();

  // console.log(`CBI deployed to ${cbi.address}`);

  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = ethers.utils.parseEther("1");

  // const Lock = await ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  
  const FT = await ethers.getContractFactory("FT");
    const ft = await FT.deploy("zhangxj","ZXJ");
  
    await ft.deployed();
    console.log(`deploy address ${ft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
