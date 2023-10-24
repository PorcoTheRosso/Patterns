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
    bool public isPatternRandomized = false; // flag to check if randomizePattern was called

    function randomizePattern(uint256 tokenId) public {
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));
        for (uint256 i = 0; i < stripes.length; i++) {
            stripes[i].positionX = (random / (i + 1)) % 500;
            stripes[i].colorHue = (random / (i + 1)) % 360;
            stripes[i].colorSaturation = 50 + (random / (i + 1)) % 50;
            stripes[i].colorBrightness = 50 + (random / (i + 1)) % 50;
        }
        isPatternRandomized = true; // set the flag to true after randomization
    }

    function getSvgData() public view returns (string memory) {
        require(isPatternRandomized, "Pattern has not been randomized yet. Please call randomizePattern first.");

        if(stripes.length == 0) {
            return "Error: No stripes present.";
        }

        uint256 stripeWidth = 500 / stripes.length;
        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 i = 0; i < stripes.length; i++) {
            svg = abi.encodePacked(svg, 
                    '<rect x="', toString(stripes[i].positionX), 
                    '" y="0" width="', toString(stripeWidth), 
                    '" height="500" fill="hsl(', toString(stripes[i].colorHue), ', ', 
                    toString(stripes[i].colorSaturation), 
                    '%, ', toString(stripes[i].colorBrightness), '%)" />');
        }

        svg = abi.encodePacked(svg, '</svg>');
        return string(svg);
    }

    function toString(uint256 value) internal pure returns(string memory) {
        // Maximum length of uint256 is 78 digits
        bytes memory buffer = new bytes(78);
        uint8 length = 0;
        while (value != 0) {
            buffer[length++] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        // Reverse the string
        bytes memory result = new bytes(length);
        for (uint8 i = 0; i < length; i++) {
            result[i] = buffer[length - 1 - i];
        }
        return string(result);
    }
}
