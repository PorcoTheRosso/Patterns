// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientPattern {

    struct Color {
        uint256 red;
        uint256 green;
        uint256 blue;
    }

    Color[150][50] public colors; // Grid of 150x50 cells

    // This function initializes the pattern.
    function generatePattern() public {
        Color memory c1 = Color(89, 198, 255);
        Color memory c2 = Color(0, 0, 0);
        Color memory c3 = Color(255, 0, 135);
        Color memory c4 = Color(255, 214, 0);

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 150; x++) {
                Color memory inter1 = interpolate(c1, c2, x, 150);
                Color memory inter2 = interpolate(c3, c4, x, 150);
                colors[x][y] = interpolate(inter1, inter2, y, 50);
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
        require(x < 150 && y < 50, "Coordinates out of bounds");
        return colors[x][y];
    }
}
