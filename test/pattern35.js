const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 35", function () {
  
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("DiagonalPattern2");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }

  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {
      
      const P1_SVG = '...'; // your expected SVG string

      // deploy smart contract with default values
      const { pattern, owner } = await loadFixture(deployPattern);

      // Call generatePattern first
      await pattern.generatePattern(1);

      // Then call getSvgData
      const svg = await pattern.getSvgData(1);
      console.log(svg);  // This will log the actual SVG output to the console
      // we want the correct SVG
      expect(svg).to.equal(P1_SVG);
    });
  });

});
