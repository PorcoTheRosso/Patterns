// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatternCanvas {

    enum ElementType { NONE, RECT, DIAGLINE, VERTLINE, HORILINE }

    struct Element {
        ElementType elementType;  // Renamed from `type` to `elementType`
    }

    Element[25][25] public canvas; // Based on 500/20 x 500/20 grid

    function generatePattern() public {
        // Initialize canvas
        for (uint256 x = 0; x < 25; x++) {
            for (uint256 y = 0; y < 25; y++) {
                canvas[x][y] = Element(ElementType.NONE);
            }
        }

        // Draw horizontal lines
        for (uint256 y = 2; y <= 22; y += 2) {
            for (uint256 x = 0; x < 25; x++) {
                canvas[x][y] = Element(ElementType.HORILINE);
            }
        }

        // Draw diagonal lines
        for (uint256 i = 0; i <= 25; i++) {
            for (uint256 j = 0; j <= 25; j++) {
                canvas[i][j] = Element(ElementType.DIAGLINE);
            }
        }

        // Draw vertical lines
        for (uint256 x = 2; x <= 22; x += 2) {
            for (uint256 y = 0; y < 25; y++) {
                canvas[x][y] = Element(ElementType.VERTLINE);
            }
        }
    }

    // This function retrieves an element's data by its x and y position on the canvas.
    function getElementData(uint256 x, uint256 y) public view returns (Element memory) {
        require(x < 25 && y < 25, "Coordinates out of bounds");
        return canvas[x][y];
    }
}
