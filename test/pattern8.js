const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 8", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("FineGradientDiagonalPattern");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }
  
  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {

      const P1_SVG = '...';  // Your expected SVG

      // deploy smart contract with default values
      const { pattern, owner } = await loadFixture(deployPattern);

      // Directly retrieve the SVG for tokenId 1
      const svg = await pattern.getSvgData(1);
      console.log(svg);  // This will log the actual SVG output to the console
      // Check if the generated SVG matches the expected SVG
      expect(svg).to.equal(P1_SVG);
    });
  })
});
