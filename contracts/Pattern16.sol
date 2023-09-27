// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientRectPattern {

    struct Color {
        uint8 red;
        uint8 green;
        uint8 blue;
    }

    Color[25][25] public colors; // Grid of 25x25 rectangles

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        Color memory colorStart1 = Color(231, 29, 54);  // #E71D36
        Color memory colorEnd1 = Color(245, 166, 35);   // #F5A623
        Color memory colorStart2 = Color(46, 196, 182); // #2EC4B6
        Color memory colorEnd2 = Color(41, 100, 138);   // #29648A

        for (uint256 x = 0; x < 25; x++) {
            Color memory interpolatedColor1 = interpolate(colorStart1, colorEnd1, x, 24);
            Color memory interpolatedColor2 = interpolate(colorStart2, colorEnd2, x, 24);
            for (uint256 y = 0; y < 25; y++) {
                if (pseudoRandom(seed, x, y) > 500) {
                    colors[x][y] = interpolatedColor1;
                } else {
                    colors[x][y] = interpolatedColor2;
                }
            }
        }
    }

    function interpolate(Color memory cStart, Color memory cEnd, uint256 i, uint256 max) internal pure returns (Color memory) {
        return Color(
            uint8(cStart.red + (cEnd.red - cStart.red) * i / max),
            uint8(cStart.green + (cEnd.green - cStart.green) * i / max),
            uint8(cStart.blue + (cEnd.blue - cStart.blue) * i / max)
        );
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    // This function retrieves a rectangle's color data by its x and y position in the grid.
    function getColor(uint256 x, uint256 y) public view returns (Color memory) {
        require(x < 25 && y < 25, "Coordinates out of bounds");
        return colors[x][y];
    }
}
