// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StripePatternV2 {

    struct Stripe {
        uint256 positionX;
        uint256 colorHue;
        uint256 colorSaturation;
        uint256 colorBrightness;
    }

    Stripe[20] public stripes;

    // This function initializes the pattern.
    function generatePattern() public {
        uint256 stripeWidth = 1500 / 20; // width divided by number of stripes
        
        uint256 hueDifference = 292 - 100;
        uint256 saturationDifference = 88 - 1; // this will be 87, which is positive
        uint256 brightnessDifference = 90 - 67;
        
        for (uint256 i = 0; i < 20; i++) {
            stripes[i].positionX = i * stripeWidth;
            
            // Linear interpolation of colors
            uint256 hue = 100 + (hueDifference * i) / 19;
            uint256 saturation = 88 - (saturationDifference * i) / 19; // note the '-' here
            uint256 brightness = 67 + (brightnessDifference * i) / 19;

            stripes[i].colorHue = hue;
            stripes[i].colorSaturation = saturation;
            stripes[i].colorBrightness = brightness;
        }
    }

    // This function retrieves a stripe's data by its index.
    function getStripe(uint256 index) public view returns (Stripe memory) {
        require(index < 20, "Index out of bounds");
        return stripes[index];
    }
}
