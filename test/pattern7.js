const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 7", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("GradientDiagonalPattern");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }
  
  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {

      // ... The expected SVG string should be updated to match the diagonals pattern with varying red colors
      const P1_SVG = '...';

      // deploy smart contract with default values
      const { pattern, owner } = await loadFixture(deployPattern);

      // Generate the pattern before retrieving the SVG
      await pattern.generatePattern(1);

      // Get the SVG data
      await pattern.getSvgData({ gasLimit: 3000000 });

      console.log(svg);  // This will log the actual SVG output to the console
      // we want the correct SVG
      expect(svg).to.equal(P1_SVG);
    });
  })

});
