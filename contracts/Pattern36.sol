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
    Color[25] public gradient;

    function generateGradient(uint256 tokenId) public {
        Color memory startColor = Color({
            red: uint8(pseudoRandom(tokenId, 0) % 256),
            green: uint8(pseudoRandom(tokenId, 1) % 256),
            blue: uint8(pseudoRandom(tokenId, 2) % 256)
        });
        
        Color memory endColor = Color({
            red: uint8(pseudoRandom(tokenId, 3) % 256),
            green: uint8(pseudoRandom(tokenId, 4) % 256),
            blue: uint8(pseudoRandom(tokenId, 5) % 256)
        });

        Color[] memory tempGradient = createGradient(startColor, endColor, numTilesX);

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

    function getSvgData(uint256 tokenId) public returns (string memory) {
        generateGradient(tokenId);
        
        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 x = 0; x < numTilesX; x++) {
            for (uint256 y = 0; y < numTilesY; y++) {
                Color memory color = getTileColor(x, y);
                svg = abi.encodePacked(
                    svg,
                    '<rect x="',
                    uintToString(x * tileSize),
                    '" y="',
                    uintToString(y * tileSize),
                    '" width="',
                    uintToString(tileSize),
                    '" height="',
                    uintToString(tileSize),
                    '" fill="rgb(',
                    uintToString(color.red),
                    ',',
                    uintToString(color.green),
                    ',',
                    uintToString(color.blue),
                    ')" />'
                );
            }
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
    }

    function pseudoRandom(uint256 seed, uint256 nonce) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, nonce))) % 1000;
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
}
