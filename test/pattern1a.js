const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Pattern 1a", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployPattern() {
    const [owner] = await ethers.getSigners();

    const Pattern = await ethers.getContractFactory("StripePatternV1a");
    const pattern = await Pattern.deploy();

    return { pattern, owner };
  }
  
  describe('getSvgData', async function () {
    it("should retrieve pattern", async function () {

      const P1_SVG = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg"><rect x="498" y="0" width="25" height="500" fill="hsl(198, 98%, 98%)" /><rect x="499" y="0" width="25" height="500" fill="hsl(99, 99%, 99%)" /><rect x="166" y="0" width="25" height="500" fill="hsl(306, 66%, 66%)" /><rect x="249" y="0" width="25" height="500" fill="hsl(229, 99%, 99%)" /><rect x="299" y="0" width="25" height="500" fill="hsl(39, 99%, 99%)" /><rect x="333" y="0" width="25" height="500" fill="hsl(153, 83%, 83%)" /><rect x="285" y="0" width="25" height="500" fill="hsl(285, 85%, 85%)" /><rect x="374" y="0" width="25" height="500" fill="hsl(294, 74%, 74%)" /><rect x="222" y="0" width="25" height="500" fill="hsl(102, 72%, 72%)" /><rect x="399" y="0" width="25" height="500" fill="hsl(19, 99%, 99%)" /><rect x="227" y="0" width="25" height="500" fill="hsl(247, 77%, 77%)" /><rect x="416" y="0" width="25" height="500" fill="hsl(76, 66%, 66%)" /><rect x="153" y="0" width="25" height="500" fill="hsl(153, 53%, 53%)" /><rect x="142" y="0" width="25" height="500" fill="hsl(322, 92%, 92%)" /><rect x="433" y="0" width="25" height="500" fill="hsl(133, 83%, 83%)" /><rect x="187" y="0" width="25" height="500" fill="hsl(327, 87%, 87%)" /><rect x="146" y="0" width="25" height="500" fill="hsl(286, 96%, 96%)" /><rect x="111" y="0" width="25" height="500" fill="hsl(51, 61%, 61%)" /><rect x="289" y="0" width="25" height="500" fill="hsl(29, 89%, 89%)" /><rect x="449" y="0" width="25" height="500" fill="hsl(189, 99%, 99%)" /></svg>'

      // deploy smart contract with default values
      const { pattern, owner } = await loadFixture(deployPattern);

      const svg = await pattern.getSvgData(1)
      
      // we want the correct SVG
      expect(svg).to.equal(P1_SVG);
    });
  })

  describe('getDataUrl', async function () {
    it("should return a data URL", async function () {
      const P1_DATAURL = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB4PSI0OTgiIHk9IjAiIHdpZHRoPSIyNSIgaGVpZ2h0PSI1MDAiIGZpbGw9ImhzbCgxOTgsIDk4JSwgOTglKSIgLz48cmVjdCB4PSI0OTkiIHk9IjAiIHdpZHRoPSIyNSIgaGVpZ2h0PSI1MDAiIGZpbGw9ImhzbCg5OSwgOTklLCA5OSUpIiAvPjxyZWN0IHg9IjE2NiIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDMwNiwgNjYlLCA2NiUpIiAvPjxyZWN0IHg9IjI0OSIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDIyOSwgOTklLCA5OSUpIiAvPjxyZWN0IHg9IjI5OSIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDM5LCA5OSUsIDk5JSkiIC8+PHJlY3QgeD0iMzMzIiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMTUzLCA4MyUsIDgzJSkiIC8+PHJlY3QgeD0iMjg1IiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMjg1LCA4NSUsIDg1JSkiIC8+PHJlY3QgeD0iMzc0IiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMjk0LCA3NCUsIDc0JSkiIC8+PHJlY3QgeD0iMjIyIiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMTAyLCA3MiUsIDcyJSkiIC8+PHJlY3QgeD0iMzk5IiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMTksIDk5JSwgOTklKSIgLz48cmVjdCB4PSIyMjciIHk9IjAiIHdpZHRoPSIyNSIgaGVpZ2h0PSI1MDAiIGZpbGw9ImhzbCgyNDcsIDc3JSwgNzclKSIgLz48cmVjdCB4PSI0MTYiIHk9IjAiIHdpZHRoPSIyNSIgaGVpZ2h0PSI1MDAiIGZpbGw9ImhzbCg3NiwgNjYlLCA2NiUpIiAvPjxyZWN0IHg9IjE1MyIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDE1MywgNTMlLCA1MyUpIiAvPjxyZWN0IHg9IjE0MiIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDMyMiwgOTIlLCA5MiUpIiAvPjxyZWN0IHg9IjQzMyIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDEzMywgODMlLCA4MyUpIiAvPjxyZWN0IHg9IjE4NyIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDMyNywgODclLCA4NyUpIiAvPjxyZWN0IHg9IjE0NiIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDI4NiwgOTYlLCA5NiUpIiAvPjxyZWN0IHg9IjExMSIgeT0iMCIgd2lkdGg9IjI1IiBoZWlnaHQ9IjUwMCIgZmlsbD0iaHNsKDUxLCA2MSUsIDYxJSkiIC8+PHJlY3QgeD0iMjg5IiB5PSIwIiB3aWR0aD0iMjUiIGhlaWdodD0iNTAwIiBmaWxsPSJoc2woMjksIDg5JSwgODklKSIgLz48cmVjdCB4PSI0NDkiIHk9IjAiIHdpZHRoPSIyNSIgaGVpZ2h0PSI1MDAiIGZpbGw9ImhzbCgxODksIDk5JSwgOTklKSIgLz48L3N2Zz4='

      // deploy smart contract with default values
      const { pattern, owner } = await loadFixture(deployPattern);

      const dataUrl = await pattern.getDataUrl(1)
      
      // we want the correct SVG
      expect(dataUrl).to.equal(P1_DATAURL);
    })
  })

});
