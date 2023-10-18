// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StripePattern {

    struct Stripe {
        uint256 positionX;
        uint256 colorHue;
        uint256 colorSaturation;
        uint256 colorBrightness;
    }

    Stripe[20] public stripes;
    string public svgData; // This variable will store the SVG data

    // This function initializes the pattern.
    function generatePattern() public {
        uint256 stripeWidth = 500 / 20; // width divided by number of stripes

        // Start of the SVG data
        svgData = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">';

        for (uint256 i = 0; i < 20; i++) {
            stripes[i].positionX = i * stripeWidth;

            // Linear interpolation of colors
            uint256 hue = 235 + (292 - 235) * i / 19;
            stripes[i].colorHue = hue;
            stripes[i].colorSaturation = (i % 2 == 0) ? 88 : 95;
            stripes[i].colorBrightness = (i % 2 == 0) ? 67 : 90;

            // Constructing the rectangle element for the SVG
            svgData = string(abi.encodePacked(svgData, '<rect x="', toString(stripes[i].positionX), 
            '" y="0" width="', toString(stripeWidth), 
            '" height="500" fill="hsl(', toString(stripes[i].colorHue), ', ', toString(stripes[i].colorSaturation), 
            '%, ', toString(stripes[i].colorBrightness), '%)" />'));
        }

        // End of the SVG data
        svgData = string(abi.encodePacked(svgData, '</svg>'));
    }

    // Helper function to convert uint to string
    function toString(uint256 value) internal pure returns(string memory) {
      // Convert a uint256 value to a string
      return string(abi.encodePacked(value));
    }

    // This function retrieves the SVG data
    function getSvgData() public view returns (string memory) {
        return svgData;
    }

    // This function retrieves a stripe's data by its index.
    function getStripe(uint256 index) public view returns (Stripe memory) {
        require(index < 20, "Index out of bounds");
        return stripes[index];
    }
}
