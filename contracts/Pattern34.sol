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
        uint8 colorIndex; // Index to the colors array
        uint256 width;
        uint256 xPos;
    }

    Stripe[100] public stripes; // A fixed number of stripes for simplicity

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1)); // Use previous blockhash as seed

        for (uint256 i = 0; i < 100; i++) {
            Stripe memory stripe;
            stripe.colorIndex = uint8(pseudoRandom(seed, i, 0) % 8 + 1); // +1 because we exclude the background color
            stripe.width = pseudoRandom(seed, i, 1) % 51 + 10; // Random width between 10 and 60
            stripe.xPos = pseudoRandom(seed, i, 2) % (500 - stripe.width); // Random position between 0 and (500 - stripe width)
            stripes[i] = stripe;
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }
}
