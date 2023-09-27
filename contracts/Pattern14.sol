// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CyanDiagonalPattern {

    // true represents diagonal from top-left to bottom-right.
    // false represents diagonal from bottom-left to top-right.
    bool[150][50] public diagonals; // Grid of 150x50 cells (based on 10 pixel steps)

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 150; x++) {
            for (uint256 y = 0; y < 50; y++) {
                diagonals[x][y] = (pseudoRandom(seed, x, y) > 500);
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    // This function retrieves the diagonal direction by its x and y position in the grid.
    function getDiagonalDirection(uint256 x, uint256 y) public view returns (bool) {
        require(x < 150 && y < 50, "Coordinates out of bounds");
        return diagonals[x][y];
    }
}
