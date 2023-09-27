// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TextGrid {

    enum CharType { G, M }

    struct CellData {
        uint8 red;
        uint8 green;
        uint8 blue;
        CharType charType;
    }

    CellData[10][10] public grid; // 10x10 grid

    function generateGrid() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 10; x++) {
            for (uint256 y = 0; y < 10; y++) {
                CellData memory cell;
                uint256 randChar = pseudoRandom(seed, x, y, 0) % 10;
                if (randChar < 5) {
                    cell.red = uint8(pseudoRandom(seed, x, y, 1) % 256);
                    cell.green = 0;
                    cell.blue = uint8(pseudoRandom(seed, x, y, 2) % 256);
                    cell.charType = CharType.G;
                } else {
                    cell.red = 0;
                    cell.green = uint8(pseudoRandom(seed, x, y, 3) % 256);
                    cell.blue = uint8(pseudoRandom(seed, x, y, 4) % 256);
                    cell.charType = CharType.M;
                }
                grid[x][y] = cell;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }

    // This function retrieves a cell's data by its x and y position in the grid.
    function getCellData(uint256 x, uint256 y) public view returns (CellData memory) {
        require(x < 10 && y < 10, "Coordinates out of bounds");
        return grid[x][y];
    }
}
