// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./base64.sol"; // Ensure you have the Base64 library

contract dreimaster {
    struct Pixel {
        uint x;
        uint y;
        string color;
    }

    Pixel[] private pixels;

    constructor() {
        string memory boatColor1 = "#646496"; // Muted blue
        string memory boatColor2 = "#7878AA"; // Slightly lighter blue
        string memory mastColor = "#502A2A";  // Dark brown
        string memory sailColor = "#C8C8C8";   // Grey for sails
        string memory flagColor = "#FF0000";   // Red

        uint xOffset = 5; // Adjusted to remove negative values

        // Boat Hull
        for(uint i = 2; i <= 16; i++) {
            addPixel(i + xOffset, 18, boatColor1);
        }
        for(uint i = 3; i <= 17; i++) {
            addPixel(i + xOffset, 17, boatColor1);
        }
        for(uint i = 4; i <= 18; i++) {
            addPixel(i + xOffset, 16, boatColor2);
        }
        for(uint i = 2; i <= 19; i++) {
            addPixel(i + xOffset, 15, boatColor1);
        }
        for(uint i = 0; i <= 21; i++) {
            addPixel(i + xOffset, 14, boatColor1);
        }

        // Masts and Flags
        for(uint i = 4; i <= 13; i++) {
            addPixel(4 + xOffset, i, mastColor); // Mast 1
        }
        for(uint i = 3; i <= 13; i++) {
            addPixel(11 + xOffset, i, mastColor); // Mast 2
        }
        for(uint i = 4; i <= 13; i++) {
            addPixel(15 + xOffset, i, mastColor); // Mast 3
        }
        for(uint i = 0; i <= 2; i++) {
            addPixel(i + xOffset +2, 3, flagColor); // Flag 1
        }
        for(uint i = 0; i <= 2; i++) {
            addPixel(i + xOffset + 9, 2, flagColor); // Flag 2
        }
        for(uint i = 0; i <= 2; i++) {
            addPixel(i + xOffset + 13, 3, flagColor); // Flag 3
        }

        // Sails (Simplified)
// Sail 1 (Large Sail) - Shifted 3 pixels to the right
for(uint y = 8; y <= 9; y++) {
    addPixel(xOffset - 5 + 3, y, sailColor); // Adjusted Part 1
}
for(uint y = 7; y <= 10; y++) {
    addPixel(xOffset - 4 + 3, y, sailColor); // Adjusted Part 2
}
for(uint y = 6; y <= 11; y++) {
    addPixel(xOffset - 3 + 3, y, sailColor); // Adjusted Part 3
}
for(uint y = 5; y <= 12; y++) {
    addPixel(xOffset - 2 + 3, y, sailColor); // Adjusted Part 4
}
for(uint y = 5; y <= 12; y++) {
    addPixel(xOffset - 1 + 3, y, sailColor); // Adjusted Part 5
}
for(uint y = 5; y <= 12; y++) {
    addPixel(xOffset + 3, y, sailColor); // Adjusted Part 6
}


// Sail 2 (Middle Sail) - Shifted 3 pixels to the right
for(uint y = 4; y <= 12; y++) {
    for(uint x = 3 + 3; x <= 7 + 3; x++) { // Adjusted range
        addPixel(x + xOffset, y, sailColor); // Adjusted Full Sail 2
    }
}

// Sail 3 (Small Sail) - Shifted 3 pixels to the right
for(uint y = 5; y <= 12; y++) {
    for(uint x = 10 + 3; x <= 11 + 3; x++) { // Adjusted range
        addPixel(x + xOffset, y, sailColor); // Adjusted Full Sail 3
    }
}

// Sail 4 (Small Triangle Sail) - Shifted 3 pixels to the right and flipped vertically
for(uint y = 6; y <= 12; y++) {
    for(uint x = 16; x <= 21; x++) { // Keep the range same as before, just shifted by 3
        if(x - 16 <= y - 6) { // Adjusted condition
            addPixel(x + xOffset, y, sailColor); // Part of Sail 4
        }
    }
}


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
