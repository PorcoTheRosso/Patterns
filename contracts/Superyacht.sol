// SPDX-License-Identifier: UNLICENSED.
pragma solidity ^0.8.0;

import "./base64.sol"; // Ensure you have the Base64 library

contract Superyacht {
    struct Pixel {
        uint x;
        uint y;
        string color;
    }

    Pixel[] private pixels;

    constructor() {
        // Define colors (single colors, as gradients are not possible)
        string memory boatColor = "#646496"; // Muted blue for the hull
        string memory frameColor = "#7878AA"; // Lighter blue for the frame
        string memory sailColor = "#C8C8C8"; // Grey for sails
        string memory mastColor = "#A0A0A0"; // Light grey for masts
        string memory flagColor = "#FF0000"; // Red for flags
        string memory windowColor = "#000000"; // Black for windows

uint xOffset = 10; // Adjust to ensure all x values are positive

// Hull construction
// Row 1 - Adding 6 pixels to the left
for(uint i = 0; i < 34 + 6; i++) { // Extending range by 6
    if (i < 34) { // Original range 0 to 34
        addPixel(i + xOffset - 6, 15, frameColor);
    }
}
// Row 2 - Adding 4 pixels to the left
for(uint i = 0; i < 30 + 4; i++) { // Extending range by 4
    if (i < 30) { // Original range 0 to 30
        addPixel(i + xOffset - 4, 16, frameColor);
    }
}
// Row 3 - Adding 5 pixels to the left
for(uint i = 0; i < 30 + 5; i++) { // Extending range by 5
    if (i < 30) { // Original range 0 to 30
        addPixel(i + xOffset - 5, 17, boatColor);
    }
}
// Row 4 - Adding 6 pixels to the left
for(uint i = 0; i < 30 + 6; i++) { // Extending range by 6
    if (i < 30) { // Original range 0 to 30
        addPixel(i + xOffset - 6, 18, boatColor);
    }
}
// Row 5 - Adding 7 pixels to the left
for(uint i = 0; i < 30 + 7; i++) { // Extending range by 7
    if (i < 30) { // Original range 0 to 30
        addPixel(i + xOffset - 7, 19, boatColor);
    }
}
// Skipping Row 6 as per the original sketch


        // Cabin construction (rows 1 to 5)
        for(uint i = 0; i < 22; i++) {
            addPixel(i + xOffset, 14, sailColor); // Cabin Row 1
        }
        for(uint i = 2; i < 20; i++) {
            addPixel(i + xOffset, 13, frameColor); // Cabin Row 2
        }
        for(uint i = 4; i < 18; i++) {
            addPixel(i + xOffset, 12, sailColor); // Cabin Row 3
        }
        for(uint i = 6; i < 16; i++) {
            addPixel(i + xOffset, 11, frameColor); // Cabin Row 4
        }
        for(uint i = 8; i < 14; i++) {
            addPixel(i + xOffset, 10, sailColor); // Cabin Row 5
        }

        // Mast and Flag
        for(uint y = 9; y <= 10; y++) {
            addPixel(11 + xOffset, y, mastColor); // Mast
        }
        for(uint x = 10; x <= 11; x++) {
            addPixel(x + xOffset, 8, flagColor); // Flag
        }

        // Fixed windows
        addPixel(10 + xOffset, 16, windowColor);
        addPixel(14 + xOffset, 15, windowColor);
    }

    function addPixel(uint x, uint y, string memory color) private {
        pixels.push(Pixel(x, y, color));
    }

    function getSvgData() public view returns (string memory) {
        uint pixelSize = 12;
        bytes memory svg = abi.encodePacked('<svg width="512" height="512" xmlns="http://www.w3.org/2000/svg">');

        for (uint i = 0; i < pixels.length; i++) {
            Pixel memory p = pixels[i];
            svg = abi.encodePacked(svg, '<rect x="', uintToString(p.x * pixelSize), '" y="', uintToString(p.y * pixelSize), '" width="', uintToString(pixelSize), '" height="', uintToString(pixelSize), '" fill="', p.color, '" />');
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
    }

    function getDataUrl() external view returns (string memory) {
        string memory svgData = getSvgData();
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svgData))));
    }

    function uintToString(uint value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (value != 0) {
            uint remainder = value % 10;
            value = value / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1];
        }
        return string(s);
    }
}
