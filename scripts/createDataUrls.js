// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function deployAndCreate(patternName, tokenId) {
  const pattern = await hre.ethers.deployContract(patternName);

  await pattern.waitForDeployment();

  const dataUrl = await pattern.getDataUrl(tokenId)
  return dataUrl
}

async function main() {

  const p1Url = await deployAndCreate("StripePatternV1a", 1)
  console.log(p1Url)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
