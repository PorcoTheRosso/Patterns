const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Pattern 1", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployP1() {
    const [owner] = await ethers.getSigners();

    const Pattern1 = await ethers.getContractFactory("StripePattern");
    const p1 = await Pattern1.deploy();

    return { p1, owner };
  }

  describe("randomize", function () {
    it("should create a new random pattern", async function () {
      // deploy smart contract with default values
      const { p1, owner } = await loadFixture(deployP1);
      
      // we want the tx to go through (note where the 'await' is!)
      await expect(p1.randomizePattern(1)).not.to.be.reverted;

      // how to get public variables from the smart contract
      const isRandomized = await p1.isPatternRandomized()
      const [x, hue, sat, bright] = await p1.stripes(0)
      
      // console logging for development
      // console.log(Number(x), hue, Number(sat), bright)

      // we want isPatternRandomized to be true after the function has been called
      expect(isRandomized).to.be.true;
    });
  });

  describe('getSvgData', async function () {
    it("should not retrieve uninitialized pattern", async function () {
      // deploy smart contract with default values
      const { p1, owner } = await loadFixture(deployP1);
      
      // we want the tx to revert
      await expect(p1.getSvgData()).to.be.revertedWith('Pattern has not been randomized yet. Please call randomizePattern first.');
    });

    it("should retrieve an initialized pattern", async function () {

      const P1_SVG = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg"><rect x="498" y="0" width="25" height="500" fill="hsl(198, 98%, 98%)" /><rect x="499" y="0" width="25" height="500" fill="hsl(99, 99%, 99%)" /><rect x="166" y="0" width="25" height="500" fill="hsl(306, 66%, 66%)" /><rect x="249" y="0" width="25" height="500" fill="hsl(229, 99%, 99%)" /><rect x="299" y="0" width="25" height="500" fill="hsl(39, 99%, 99%)" /><rect x="333" y="0" width="25" height="500" fill="hsl(153, 83%, 83%)" /><rect x="285" y="0" width="25" height="500" fill="hsl(285, 85%, 85%)" /><rect x="374" y="0" width="25" height="500" fill="hsl(294, 74%, 74%)" /><rect x="222" y="0" width="25" height="500" fill="hsl(102, 72%, 72%)" /><rect x="399" y="0" width="25" height="500" fill="hsl(19, 99%, 99%)" /><rect x="227" y="0" width="25" height="500" fill="hsl(247, 77%, 77%)" /><rect x="416" y="0" width="25" height="500" fill="hsl(76, 66%, 66%)" /><rect x="153" y="0" width="25" height="500" fill="hsl(153, 53%, 53%)" /><rect x="142" y="0" width="25" height="500" fill="hsl(322, 92%, 92%)" /><rect x="433" y="0" width="25" height="500" fill="hsl(133, 83%, 83%)" /><rect x="187" y="0" width="25" height="500" fill="hsl(327, 87%, 87%)" /><rect x="146" y="0" width="25" height="500" fill="hsl(286, 96%, 96%)" /><rect x="111" y="0" width="25" height="500" fill="hsl(51, 61%, 61%)" /><rect x="289" y="0" width="25" height="500" fill="hsl(29, 89%, 89%)" /><rect x="449" y="0" width="25" height="500" fill="hsl(189, 99%, 99%)" /></svg>'

      // deploy smart contract with default values
      const { p1, owner } = await loadFixture(deployP1);

      await p1.randomizePattern(1);

      const svg = await p1.getSvgData()
      //console.log(svg);  // This will log the actual SVG output to the console
      // we want the correct SVG
      expect(svg).to.equal(P1_SVG);
    });
  })

});
