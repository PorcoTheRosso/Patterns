// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GMGrid {

    enum CharType { G, M }

    struct CellData {
        CharType charType;
        uint8 colorIndex;
    }

    CellData[15][15] public grid; // Grid based on 600/40 x 600/40

    string[5] public gmColors = ["#FEBFCA", "#D7EBEE", "#F8DCC1", "#C5E99B", "#E8D8EC"];

    function generateGrid() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 15; x++) {
            for (uint256 y = 0; y < 15; y++) {
                CellData memory cell;
                uint256 randChar = pseudoRandom(seed, x, y, 0) % 2;
                cell.charType = CharType(randChar);
                cell.colorIndex = uint8(pseudoRandom(seed, x, y, 1) % 5); // There are 5 colors
                grid[x][y] = cell;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }

    // This function retrieves a cell's data by its x and y position in the grid.
    function getCellData(uint256 x, uint256 y) public view returns (CellData memory) {
        require(x < 15 && y < 15, "Coordinates out of bounds");
        return grid[x][y];
    }
}
