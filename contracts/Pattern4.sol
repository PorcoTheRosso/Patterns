// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmallGradientPattern {

    struct Color {
        uint256 red;
        uint256 green;
        uint256 blue;
    }

    Color[300][100] public colors; // Grid of 300x100 cells to represent 5x5 rectangles

    // This function initializes the pattern.
    function generatePattern() public {
        Color memory c1 = Color(89, 198, 255);
        Color memory c2 = Color(0, 0, 0);
        Color memory c3 = Color(255, 0, 135);
        Color memory c4 = Color(255, 214, 0);

        for (uint256 y = 0; y < 100; y++) { // 100 rows of 5 pixels each
            for (uint256 x = 0; x < 300; x++) { // 300 columns of 5 pixels each
                Color memory inter1 = interpolate(c1, c2, x, 300);
                Color memory inter2 = interpolate(c3, c4, x, 300);
                colors[x][y] = interpolate(inter1, inter2, y, 100);
            }
        }
    }

    function interpolate(Color memory cStart, Color memory cEnd, uint256 i, uint256 max) internal pure returns (Color memory) {
        return Color(
            cStart.red + (cEnd.red - cStart.red) * i / max,
            cStart.green + (cEnd.green - cStart.green) * i / max,
            cStart.blue + (cEnd.blue - cStart.blue) * i / max
        );
    }

    // This function retrieves a color's data by its x and y position in the grid.
    function getColor(uint256 x, uint256 y) public view returns (Color memory) {
        require(x < 300 && y < 100, "Coordinates out of bounds");
        return colors[x][y];
    }
}
