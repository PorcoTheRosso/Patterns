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

    // This function initializes the pattern.
    function generatePattern() public {
        uint256 stripeWidth = 500 / 20; // width divided by number of stripes
        
        for (uint256 i = 0; i < 20; i++) {
            stripes[i].positionX = i * stripeWidth;
            
            // Linear interpolation of colors
            uint256 hue = 235 + (292 - 235) * i / 19;
            stripes[i].colorHue = hue;
            stripes[i].colorSaturation = (i % 2 == 0) ? 88 : 95;
            stripes[i].colorBrightness = (i % 2 == 0) ? 67 : 90;
        }
    }

    // This function retrieves a stripe's data by its index.
    function getStripe(uint256 index) public view returns (Stripe memory) {
        require(index < 20, "Index out of bounds");
        return stripes[index];
    }
}
