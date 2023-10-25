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

    function generateTiles(uint256 tokenId) public {
        uint256 seed = tokenId; // Use tokenId as seed

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

    function getTileData(uint256 x, uint256 y) public view returns (TileData memory) {
        require(x < 61 && y < 21, "Coordinates out of bounds");
        return tiles[x][y];
    }

    function getSvgData(uint256 tokenId) public returns (string memory) {
        generateTiles(tokenId); // Generate tiles based on tokenId

        bytes memory svg = abi.encodePacked('<svg width="1500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 21; y++) {
            for (uint256 x = 0; x < 61; x++) {
                TileData memory t = tiles[x][y];
                svg = abi.encodePacked(svg, 
                    '<rect x="', intToString(int256(x * 25) + t.xOffset), 
                    '" y="', intToString(int256(y * 25) + t.yOffset), 
                    '" width="25" height="25" fill="rgb(', 
                    uintToString(t.red), ',', uintToString(t.green), ',', uintToString(t.blue), ')" />');
            }
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
    }

    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        while (v != 0) {
            uint256 remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint256 j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1];
        }
        return string(s);
    }

    function intToString(int256 v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        bool negative = v < 0;
        if (negative) {
            v = -v;
        }
        uint256 uv = uint256(v);

        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        while (uv != 0) {
            uint256 remainder = uv % 10;
            uv = uv / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i + (negative ? 1 : 0));
        if (negative) {
            s[0] = '-';
        }
        for (uint256 j = 0; j < i; j++) {
            s[j + (negative ? 1 : 0)] = reversed[i - j - 1];
        }
        return string(s);
    }
}
