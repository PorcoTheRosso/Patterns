// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientRectPattern {
    struct Color {
        uint8 red;
        uint8 green;
        uint8 blue;
    }

    Color[25][25] public colors; // Grid of 25x25 rectangles

    function generatePattern(uint256 tokenId) public {
        for (uint256 x = 0; x < 25; x++) {
            Color memory colorStart1 = Color(231, 29, 54);  // #E71D36
            Color memory colorEnd1 = Color(245, 166, 35);   // #F5A623
            Color memory colorStart2 = Color(46, 196, 182); // #2EC4B6
            Color memory colorEnd2 = Color(41, 100, 138);   // #29648A

            Color memory interpolatedColor1 = interpolate(colorStart1, colorEnd1, x, 24);
            Color memory interpolatedColor2 = interpolate(colorStart2, colorEnd2, x, 24);
            for (uint256 y = 0; y < 25; y++) {
                if (pseudoRandom(tokenId, x, y) > 500) {
                    colors[x][y] = interpolatedColor1;
                } else {
                    colors[x][y] = interpolatedColor2;
                }
            }
        }
    }

function interpolate(Color memory cStart, Color memory cEnd, uint256 i, uint256 max) public pure returns(Color memory) {
    int256 red = int256(uint256(cStart.red)) + (int256(uint256(cEnd.red)) - int256(uint256(cStart.red))) * int256(i) / int256(max);
    int256 green = int256(uint256(cStart.green)) + (int256(uint256(cEnd.green)) - int256(uint256(cStart.green))) * int256(i) / int256(max);
    int256 blue = int256(uint256(cStart.blue)) + (int256(uint256(cEnd.blue)) - int256(uint256(cStart.blue))) * int256(i) / int256(max);
    
return Color(
    uint8(uint256(clamp(red, 0, 255))),
    uint8(uint256(clamp(green, 0, 255))),
    uint8(uint256(clamp(blue, 0, 255)))
);

}


    function generatePatternForTokenId(uint256 tokenId) public pure returns(string memory) {
        // Utilize tokenId to determine the colors
        Color memory startColor = Color(
            uint8(tokenId % 256), 
            uint8((tokenId / 256) % 256), 
            uint8((tokenId / 65536) % 256)
        );
        
        // Generate a contrasting endColor using bitwise NOT operation
        Color memory endColor = Color(
            ~startColor.red,
            ~startColor.green,
            ~startColor.blue
        );

        // Use tokenId to determine the number of divisions in the pattern, between 5 to 20
        uint256 divisions = 5 + (tokenId % 16); 
        
        // Create the SVG pattern
        string memory pattern = "<svg xmlns='http://www.w3.org/2000/svg' width='500' height='500'>";
        uint256 stepSize = 500 / divisions;
        for (uint256 i = 0; i < divisions; i++) {
            Color memory interpolated = interpolate(startColor, endColor, i, divisions-1);
            pattern = string(abi.encodePacked(pattern, generateRect(i * stepSize, 0, stepSize, 500, interpolated)));
        }
        pattern = string(abi.encodePacked(pattern, "</svg>"));
        return pattern;
    }

    function clamp(int256 v, int256 min, int256 max) internal pure returns (int256) {
        if (v < min) return min;
        if (v > max) return max;
        return v;
    }

    function generateRect(uint256 x, uint256 y, uint256 width, uint256 height, Color memory color) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="', uintToString(x), 
            '" y="', uintToString(y), 
            '" width="', uintToString(width), 
            '" height="', uintToString(height), 
            '" fill="rgb(', uintToString(color.red), ',', uintToString(color.green), ',', uintToString(color.blue), ')" />'
        ));
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    function getColor(uint256 x, uint256 y) public view returns (Color memory) {
        require(x < 25 && y < 25, "Coordinates out of bounds");
        return colors[x][y];
    }

    function getSvgData(uint256 /* tokenId */) public view returns (string memory) {
        bytes memory svg = abi.encodePacked('<svg width="250" height="250" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 25; y++) {
            for (uint256 x = 0; x < 25; x++) {
                Color memory c = colors[x][y];
                svg = abi.encodePacked(svg, 
                    '<rect x="', uintToString(x * 10), 
                    '" y="', uintToString(y * 10), 
                    '" width="10" height="10" fill="rgb(', 
                    uintToString(c.red), ',', uintToString(c.green), ',', uintToString(c.blue), ')" />');
            }
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
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
