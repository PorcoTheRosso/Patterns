// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FineGradientDiagonalPattern {

    struct DiagonalData {
        bool direction;   // true: top-left to bottom-right, false: bottom-left to top-right
        uint8 redValue;   // Red component of the color
    }

    DiagonalData[75][25] public diagonals; // Grid of 75x25 cells (based on 20 pixel steps)

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 75; x++) {
            for (uint256 y = 0; y < 25; y++) {
                DiagonalData memory d;
                d.direction = (pseudoRandom(seed, x, y) > 500);
                d.redValue = uint8((x * 255) / 74);  // Linearly scale x to [0, 255]
                diagonals[x][y] = d;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    // This function retrieves the diagonal data by its x and y position in the grid.
    function getDiagonalData(uint256 x, uint256 y) public view returns (DiagonalData memory) {
        require(x < 75 && y < 25, "Coordinates out of bounds");
        return diagonals[x][y];
    }
}
