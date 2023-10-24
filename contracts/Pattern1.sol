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

    // Function to initialize the pattern with random values based on a token ID
    function randomizePattern(uint256 tokenId) public {
        // Seed the random generator
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));

        for (uint256 i = 0; i < stripes.length; i++) {
            // Generate random values based on the token ID and loop iteration
            stripes[i].positionX = (random / (i + 1)) % 500;
            stripes[i].colorHue = (random / (i + 1)) % 360;
            stripes[i].colorSaturation = 50 + (random / (i + 1)) % 50; // Range: 50-100
            stripes[i].colorBrightness = 50 + (random / (i + 1)) % 50; // Range: 50-100
        }
    }

    function getSvgData() public view returns (string memory) {
        uint256 stripeWidth = 500 / stripes.length; // width divided by number of stripes

        // Start of the SVG data
        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 i = 0; i < stripes.length; i++) {
            svg = abi.encodePacked(svg, '<rect x="', toString(stripes[i].positionX), 
            '" y="0" width="', toString(stripeWidth), 
            '" height="500" fill="hsl(', toString(stripes[i].colorHue), ', ', toString(stripes[i].colorSaturation), 
            '%, ', toString(stripes[i].colorBrightness), '%)" />');
        }

        // End of the SVG data
        svg = abi.encodePacked(svg, '</svg>');

        return string(svg);
    }

    function toString(uint256 value) internal pure returns(string memory) {
      // Convert a uint256 value to a string
      return string(abi.encodePacked(value));
    }
}
