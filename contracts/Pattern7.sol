// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientDiagonalPattern {

    struct DiagonalData {
        bool direction;   // true: top-left to bottom-right, false: bottom-left to top-right
        uint8 redValue;   // Red component of the color
    }

    DiagonalData[30][10] public diagonals; // Grid of 30x10 cells (based on 50 pixel steps)

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 30; x++) {
            for (uint256 y = 0; y < 10; y++) {
                DiagonalData memory d;
                d.direction = (pseudoRandom(seed, x, y) > 500);
                d.redValue = uint8((x * 255) / 29);  // Linearly scale x to [0, 255]
                diagonals[x][y] = d;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    // This function retrieves the diagonal data by its x and y position in the grid.
    function getDiagonalData(uint256 x, uint256 y) public view returns (DiagonalData memory) {
        require(x < 30 && y < 10, "Coordinates out of bounds");
        return diagonals[x][y];
    }
}
