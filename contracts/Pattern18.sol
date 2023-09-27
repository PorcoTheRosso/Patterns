// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicTiles {

    struct TileData {
        uint8 red;
        uint8 green;
        uint8 blue;
        int8 xOffset;
        int8 yOffset;
    }

    TileData[61][21] public tiles; // Grid based on ceil(1500/25) x ceil(500/25)

    function generateTiles() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 x = 0; x < 61; x++) {
            for (uint256 y = 0; y < 21; y++) {
                TileData memory t;
                t.red = uint8(pseudoRandom(seed, x, y, 0) % 156 + 100);
                t.green = uint8(pseudoRandom(seed, x, y, 1) % 156 + 100);
                t.blue = uint8(pseudoRandom(seed, x, y, 2) % 156 + 100);

                int256 xOffsetTemp = int256(pseudoRandom(seed, x, y, 3) % 51) - 25;
                t.xOffset = int8(xOffsetTemp);

                int256 yOffsetTemp = int256(pseudoRandom(seed, x, y, 4) % 51) - 25;
                t.yOffset = int8(yOffsetTemp);

                tiles[x][y] = t;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }

    // This function retrieves a tile's data by its x and y position in the grid.
    function getTileData(uint256 x, uint256 y) public view returns (TileData memory) {
        require(x < 61 && y < 21, "Coordinates out of bounds");
        return tiles[x][y];
    }

    // This function regenerates colors for the tiles.
    function regenerateColors() public {
        generateTiles();
    }
}
