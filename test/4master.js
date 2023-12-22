const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Viermaster", function () {
    async function deployViermaster() {
        const [owner] = await ethers.getSigners();
        const Viermaster = await ethers.getContractFactory("Viermaster");
        const viermaster = await Viermaster.deploy();
        return { viermaster, owner };
    }

    describe('getSvgData', async function () {
        it("should retrieve the sailboat SVG", async function () {
            const { viermaster, owner } = await loadFixture(deployViermaster);

            const svg = await viermaster.getSvgData();
            console.log("SVG Output:", svg);

            // Define the expected SVG string here after running the test and obtaining the actual output
            const EXPECTED_SVG = '<svg...>...</svg>';  // Replace with actual SVG string
            expect(svg).to.equal(EXPECTED_SVG);
        });
    });

    describe('getDataUrl', async function () {
        it("should return a data URL for the sailboat SVG", async function () {
            const { viermaster, owner } = await loadFixture(deployViermaster);

            const dataUrl = await viermaster.getDataUrl();
            console.log("Data URL Output:", dataUrl);

            // Define the expected Data URL string here after running the test and obtaining the actual output
            const EXPECTED_DATA_URL = 'data:image/svg+xml;base64,...';  // Replace with actual Data URL string
            expect(dataUrl).to.equal(EXPECTED_DATA_URL);
        });
    });
});
