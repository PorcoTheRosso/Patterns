// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientTiles {

    struct Color {
        uint8 red;
        uint8 green;
        uint8 blue;
    }

    uint256 public constant tileSize = 20;
    uint256 public constant numTilesX = 25; // 500 / 20
    uint256 public constant numTilesY = 25; // 500 / 20
    Color[25] public gradient; // We make it a fixed size array for our specific use case

    constructor() {
        // Create the gradient on contract deployment
        Color[] memory tempGradient = createGradient(
            Color({red: 255, green: 255, blue: 255}),
            Color({red: 0, green: 0, blue: 0}),
            numTilesX
        );

        // Manually copy from the memory array to the storage array
        for (uint256 i = 0; i < numTilesX; i++) {
            gradient[i] = tempGradient[i];
        }
    }

    function getTileColor(uint256 x, uint256 y) public view returns (Color memory) {
        uint256 index = y * numTilesX + x;
        return gradient[index % numTilesX];
    }

    function createGradient(Color memory startColor, Color memory endColor, uint256 numSteps) internal pure returns (Color[] memory) {
        Color[] memory newGradient = new Color[](numSteps);

        for (uint256 i = 0; i < numSteps; i++) {
            Color memory c;
            c.red = uint8(startColor.red + (endColor.red - startColor.red) * i / (numSteps - 1));
            c.green = uint8(startColor.green + (endColor.green - startColor.green) * i / (numSteps - 1));
            c.blue = uint8(startColor.blue + (endColor.blue - startColor.blue) * i / (numSteps - 1));

            newGradient[i] = c;
        }

        return newGradient;
    }
}
