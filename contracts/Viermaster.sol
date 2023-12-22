// SPDX-License-Identifier: UNLICENSED.
pragma solidity ^0.8.0;

import "./base64.sol"; // Ensure you have the Base64 library

contract Viermaster {
    struct Pixel {
        uint x;
        uint y;
        string color;
    }

    Pixel[] private pixels;

    constructor() {
    // Define colors
    string memory boatColor1 = "#646496"; // Muted blue
    string memory boatColor2 = "#7878AA"; // Lighter blue
    string memory mastColor = "#502A2A";  // Dark brown
    string memory sailColor = "#C8C8C8";  // Grey for sails
    string memory flagColor = "#FF0000";  // Red

    uint xOffset = 7; // Adjust for positive values

    // Hull construction
    for (uint i = xOffset - 4; i < xOffset + 16; i++) {
        addPixel(i, 19, boatColor1); // Row 1
    }
    for (uint i = xOffset - 3; i < xOffset + 16; i++) {
        addPixel(i, 18, boatColor1); // Row 2
    }
    for (uint i = xOffset - 2; i < xOffset + 17; i++) {
        addPixel(i, 17, boatColor1); // Row 3
    }
    for (uint i = xOffset - 1; i < xOffset + 18; i++) {
        addPixel(i, 16, boatColor2); // Row 4
    }
    for (uint i = xOffset - 3; i < xOffset + 19; i++) {
        addPixel(i, 15, boatColor1); // Row 5
    }
    for (uint i = xOffset - 5; i < xOffset + 21; i++) {
        addPixel(i, 14, boatColor1); // Row 6
    }


    // Masts and Flags
    // Mast 1
    for (uint y = 3; y < 14; y++) {
        addPixel(xOffset - 1, y, mastColor);
    }
    // Flag 1
    addPixel(xOffset - 3, 2, flagColor);
    addPixel(xOffset - 2, 2, flagColor);
    addPixel(xOffset - 1, 2, flagColor);

    // Mast 2
    for (uint y = 2; y < 14; y++) {
        addPixel(xOffset + 5, y, mastColor);
    }
    // Flag 2
    addPixel(xOffset + 3, 1, flagColor);
    addPixel(xOffset + 4, 1, flagColor);
    addPixel(xOffset + 5, 1, flagColor);

    // Mast 3
    for (uint y = 3; y < 14; y++) {
        addPixel(xOffset + 11, y, mastColor);
    }
    // Flag 3
    addPixel(xOffset + 9, 2, flagColor);
    addPixel(xOffset + 10, 2, flagColor);
    addPixel(xOffset + 11, 2, flagColor);

    // Mast 4
    for (uint y = 6; y < 14; y++) {
        addPixel(xOffset + 14, y, mastColor);
    }
    // Flag 4
    addPixel(xOffset + 13, 5, flagColor);
    addPixel(xOffset + 14, 5, flagColor);

    // Sails
    // Sail 1 (Big Rounded)
    for (uint y = 6; y <= 9; y++) {
        for (uint x = xOffset - 7; x <= xOffset - 2; x++) {
            addPixel(x, y, sailColor); // Part of Sail 1
        }
    }

    // More parts of Sail 1
    // Adjust these loops to create the desired shape of Sail 1
    // Example:
    for (uint y = 5; y <= 10; y++) {
        for (uint x = xOffset - 6; x <= xOffset - 3; x++) {
            addPixel(x, y, sailColor); // Another part of Sail 1
        }
    }

    // Sail 2 (Big)
    for (uint y = 3; y <= 12; y++) {
        for (uint x = xOffset + 1; x <= xOffset + 4; x++) {
            addPixel(x, y, sailColor); // Full Sail 2
        }
    }

    // Sail 3 (Big)
    for (uint y = 4; y <= 12; y++) {
        for (uint x = xOffset + 7; x <= xOffset + 10; x++) {
            addPixel(x, y, sailColor); // Full Sail 3
        }
    }

    // Sail 4 (Small Triangle)
    for (uint y = 7; y <= 12; y++) {
        for (uint x = xOffset + 15; x <= xOffset + 20; x++) {
            if (x - xOffset - 15 <= 12 - y) {
                addPixel(x, y, sailColor); // Part of Sail 4
            }
        }
    }

        // More parts of Sail 4
        // Adjust these loops to create the desired shape of Sail 4
        // Example:
        for (uint y = 8; y <= 11; y++) {
            for (uint x = xOffset + 16; x <= xOffset + 19; x++) {
                if (x - xOffset - 16 <= 11 - y) {
                    addPixel(x, y, sailColor); // Another part of Sail 4
                }
            }
        }

    }
    function addPixel(uint x, uint y, string memory color) private {
        pixels.push(Pixel(x, y, color));
    }

    function getSvgData() public view returns (string memory) {
        uint pixelSize = 12;
        bytes memory svg = abi.encodePacked(
            '<svg width="512" height="512" xmlns="http://www.w3.org/2000/svg">'
        );

        for (uint i = 0; i < pixels.length; i++) {
            Pixel memory p = pixels[i];
            svg = abi.encodePacked(
                svg,
                '<rect x="', uintToString(p.x * pixelSize),
                '" y="', uintToString(p.y * pixelSize),
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
