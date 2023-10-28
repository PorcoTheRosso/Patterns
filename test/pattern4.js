const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 4", function () {
  
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("SmallGradientPattern");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }
  
  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {

      const P1_SVG = '<svg width="1000" height="250" xmlns="http://www.w3.org/2000/svg"> ... </svg>' // Update the SVG content here with the expected output

      const { pattern, owner } = await loadFixture(deployPattern);

      const tokenId = 1;
      await pattern.mint(tokenId); // Mint the token to generate the pattern

      const svg = await pattern.getSvgData();
      console.log(svg);  // This will log the actual SVG output to the console
      expect(svg).to.equal(P1_SVG);
    });
  })
});
