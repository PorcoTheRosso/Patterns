// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientPattern {

    struct Color {
        uint256 red;
        uint256 green;
        uint256 blue;
    }

    Color[150][50] public colors; // Grid of 150x50 cells

    // This function randomizes the pattern based on the given tokenId.
    function randomizePattern(uint256 tokenId) internal pure returns (Color[150][50] memory) {
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));
        Color[150][50] memory randomizedColors;

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 150; x++) {
                randomizedColors[x][y].red = (random / (x + y + 1)) % 256;
                randomizedColors[x][y].green = (random / (x + y + 2)) % 256;
                randomizedColors[x][y].blue = (random / (x + y + 3)) % 256;
            }
        }

        return randomizedColors;
    }

    // This function initializes the pattern based on a given tokenId.
    function generatePattern(uint256 tokenId) public {
        Color[150][50] memory randomizedColors = randomizePattern(tokenId);

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 150; x++) {
                colors[x][y] = randomizedColors[x][y];
            }
        }
    }

    function getColor(uint256 x, uint256 y) public view returns (Color memory) {
        require(x < 150 && y < 50, "Coordinates out of bounds");
        return colors[x][y];
    }

    function getSvgData() public view returns (string memory) {
        bytes memory svg = abi.encodePacked('<svg width="1500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 150; x++) {
                svg = abi.encodePacked(svg, 
                    '<rect x="', uintToString(x * 10), 
                    '" y="', uintToString(y * 10),
                    '" width="10" height="10" fill="', colorToSvgFill(colors[x][y]), '" />');
            }
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
    }

    function colorToSvgFill(Color memory color) internal pure returns (string memory) {
        return string(abi.encodePacked("rgb(", uintToString(color.red), ",", uintToString(color.green), ",", uintToString(color.blue), ")"));
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
