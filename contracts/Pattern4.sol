// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmallGradientPattern {

    struct Color {
        uint256 red;
        uint256 green;
        uint256 blue;
    }

    // Dimensions of the grid have been reduced to 200x50
    Color[200][50] public colors; 
    mapping(uint256 => Color[200][50]) public tokenColors;

    function randomizePattern(uint256 tokenId) internal pure returns (Color[200][50] memory) {
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));
        Color[200][50] memory randomizedColors;

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 200; x++) {
                randomizedColors[x][y].red = (random / (x + y + 1)) % 256;
                randomizedColors[x][y].green = (random / (x + y + 2)) % 256;
                randomizedColors[x][y].blue = (random / (x + y + 3)) % 256;
            }
        }

        return randomizedColors;
    }

function mint(uint256 tokenId) public {
    Color[200][50] memory randomizedColors = randomizePattern(tokenId);
    
    for (uint256 y = 0; y < 50; y++) {
        for (uint256 x = 0; x < 200; x++) {
            tokenColors[tokenId][x][y] = randomizedColors[x][y];
        }
    }
}


    function getSvgData(uint256 tokenId) public view returns (string memory) {
        require(tokenColors[tokenId][0][0].red != 0, "Token ID not found"); // rudimentary check; can be improved

        bytes memory svg = abi.encodePacked('<svg width="1000" height="250" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 200; x++) {
                svg = abi.encodePacked(svg, 
                    '<rect x="', uintToString(x * 5), 
                    '" y="', uintToString(y * 5),
                    '" width="5" height="5" fill="', colorToSvgFill(tokenColors[tokenId][x][y]), '" />');
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
