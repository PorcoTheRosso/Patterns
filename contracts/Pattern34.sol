// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StripePatternV3 {

    string[9] public colors = [
        "#F2CAA8",
        "#DBB68A",
        "#C1A479",
        "#A6916B",
        "#8A7D5D",
        "#6E6A50",
        "#515642",
        "#354334",
        "#193026"
    ];

    struct Stripe {
        uint8 colorIndex;
        uint256 width;
        uint256 xPos;
    }

    Stripe[100] public stripes;

    function generatePattern(uint256 tokenId) public {
        uint256 seed = tokenId;

        for (uint256 i = 0; i < 100; i++) {
            Stripe memory stripe;
            stripe.colorIndex = uint8(pseudoRandom(seed, i, 0) % 8 + 1);
            stripe.width = pseudoRandom(seed, i, 1) % 51 + 10;
            stripe.xPos = pseudoRandom(seed, i, 2) % (500 - stripe.width);
            stripes[i] = stripe;
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    function getSvgData() public view returns (string memory) {
        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg" style="background-color:', colors[0], ';">');

        for (uint256 i = 0; i < 100; i++) {
            svg = abi.encodePacked(
                svg,
                '<rect x="',
                uintToString(stripes[i].xPos),
                '" y="0" width="',
                uintToString(stripes[i].width),
                '" height="500" fill="',
                colors[stripes[i].colorIndex],
                '" />'
            );
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
