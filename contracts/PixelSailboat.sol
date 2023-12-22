// SPDX-License-Identifier: UNLICENSED.
pragma solidity ^0.8.0;

import "./base64.sol"; // Ensure you have the Base64 library

contract PixelSailboat {

    struct Pixel {
        uint x;
        uint y;
        string color;
    }

    Pixel[] private pixels;

    constructor() {
        // Boat Body
        for(uint i = 4; i <= 15; i++) {
            addPixel(i, 18, "#0000FF"); // Blue
        }
        for(uint i = 2; i <= 16; i++) {
            addPixel(i, 17, "#0000FF"); // Blue
        }
        for(uint i = 2; i <= 17; i++) {
            addPixel(i, 16, "#0000FF"); // Blue
        }
        for(uint i = 1; i <= 18; i++) {
            addPixel(i, 15, "#808080"); // Grey
        }

    // Adjust these values as needed based on the size of your canvas
    uint minValidX = 0; // Minimum valid x-coordinate
    uint maxValidX = 40; // Maximum valid x-coordinate, adjust as per your canvas size

    // Sails - Right Triangle (Starboard), shifted 8 pixels to the left
    for(uint y = 7; y <= 13; y++) {
        for(uint x = 11; x <= 17; x++) {  // Adjusted start value to prevent underflow
            uint adjustedX = x - 8;
            if (adjustedX >= minValidX && adjustedX <= maxValidX && 17 - x <= y - 7) {
                addPixel(adjustedX, y, "#00FFFF"); // Cyan
            }
        }
    }

    // Sails - Left Triangle (Port), shifted 8 pixels to the right
    for(uint y = 7; y <= 13; y++) {
        for(uint x = 3; x <= 9; x++) {  // Original range, adjust if necessary
            uint adjustedX = x + 8;
            if (adjustedX >= minValidX && adjustedX <= maxValidX && x - 3 <= y - 7) {
                addPixel(adjustedX, y, "#00FFFF"); // Cyan
            }
        }
    }

        // Mast
        for(uint i = 6; i <= 14; i++) {
            addPixel(10, i, "#A0522D"); // Brown
        }

        // Flag
        for(uint i = 8; i <= 10; i++) {
            addPixel(i, 5, "#FF0000"); // Red
        }
    }


    function addPixel(uint x, uint y, string memory color) private {
        pixels.push(Pixel(x, y, color));
    }

  function getSvgData() public view returns (string memory) {
    uint pixelSize = 12;
    uint svgWidth = 512;
    uint svgHeight = 512;

    // Assuming you know the min and max coordinates of your design
    uint minBoatX = 0; // Adjust with your boat's minimum X coordinate
    uint maxBoatX = 20; // Adjust with your boat's maximum X coordinate
    uint minBoatY = 0; // Adjust with your boat's minimum Y coordinate
    uint maxBoatY = 30; // Adjust with your boat's maximum Y coordinate

    // Calculate boat width and height in pixels
    uint boatWidth = (maxBoatX - minBoatX) * pixelSize;
    uint boatHeight = (maxBoatY - minBoatY) * pixelSize;

    // Calculate centering offsets
    uint offsetX = (svgWidth - boatWidth) / 2;
    uint offsetY = (svgHeight - boatHeight) / 2;

    bytes memory svg = abi.encodePacked(
        '<svg width="', uintToString(svgWidth), 
        '" height="', uintToString(svgHeight), 
        '" xmlns="http://www.w3.org/2000/svg">'
    );

for (uint i = 0; i < pixels.length; i++) {
    Pixel memory p = pixels[i];
    // Apply the offset to each pixel
    uint pixelX = p.x * pixelSize + offsetX;
    uint pixelY = p.y * pixelSize + offsetY;

    svg = abi.encodePacked(
        svg,
        '<rect x="', uintToString(pixelX),
        '" y="', uintToString(pixelY),
        '" width="', uintToString(pixelSize),
        '" height="', uintToString(pixelSize),
        '" fill="', p.color, '" />'
    );
}

svg = abi.encodePacked(svg, '</svg>');
return string(svg);

}


    function getDataUrl() external view returns (string memory) {
        string memory svgData = getSvgData();
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svgData))
        ));
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