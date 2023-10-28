const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // List all the pattern contract names
  const patternNames = [
    "StripePatternV1",
    "StripePatternV1a",
    "StripePatternV2",
    "GradientPattern",
    "DiagonalPattern",
    "GradientDiagonalPattern",
    "FineGradientDiagonalPattern",
    "CyanDiagonalPattern",
    "GradientRectPattern",
    // ... Add all other pattern names here
  ];

  for (const patternName of patternNames) {
    const Pattern = await hre.ethers.getContractFactory(patternName);
    const pattern = await Pattern.deploy();
    await pattern.deployed();

    console.log(`${patternName} deployed to ${pattern.address}`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
