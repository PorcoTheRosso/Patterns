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

    function randomizePattern(uint256 tokenId) internal pure returns (Stripe[20] memory) {
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));
        Stripe[20] memory randomizedStripes;
        
        for (uint256 i = 0; i < 20; i++) {
            randomizedStripes[i].positionX = (random / (i + 1)) % 500;  // Changed modulus to 500
            randomizedStripes[i].colorHue = (random / (i + 1)) % 360;
            randomizedStripes[i].colorSaturation = 50 + (random / (i + 1)) % 50;
            randomizedStripes[i].colorBrightness = 50 + (random / (i + 1)) % 50;
        }

        return randomizedStripes;
    }

    function generatePattern(uint256 tokenId) public {
        Stripe[20] memory randomizedStripes = randomizePattern(tokenId);
        
        for (uint256 i = 0; i < 20; i++) {
            stripes[i] = randomizedStripes[i];
        }
    }

    function getStripe(uint256 index) public view returns (Stripe memory) {
        require(index < 20, "Index out of bounds");
        return stripes[index];
    }

    function getSvgData() public view returns (string memory) {
        uint256 stripeWidth = 500 / 20;  // Changed stripe width calculation
        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');  // Changed SVG dimensions to 500

        for (uint256 i = 0; i < 20; i++) {
            svg = abi.encodePacked(svg, 
                    '<rect x="', uintToString(stripes[i].positionX), 
                    '" y="0" width="', uintToString(stripeWidth), 
                    '" height="500" fill="hsl(', uintToString(stripes[i].colorHue), ', ', 
                    uintToString(stripes[i].colorSaturation), 
                    '%, ', uintToString(stripes[i].colorBrightness), '%)" />');
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
