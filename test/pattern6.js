const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 6", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("DiagonalPattern");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }
  
  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {

      const P1_SVG = '...' // Your expected SVG string

      const { pattern, owner } = await loadFixture(deployPattern);

      const tokenId = 1;
      await pattern.generatePattern(tokenId); // Generate the pattern for the given tokenId

      const svg = await pattern.getSvgData(tokenId);
      console.log(svg);  // This will log the actual SVG output to the console
      expect(svg).to.equal(P1_SVG);
    });
  })

});
