// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiagonalPattern {

    enum LineType { NONE, FORWARD, BACKWARD }

    struct Line {
        LineType lineType; // Renamed from `type` to `lineType`
        uint8 colorIndex;
    }

    Line[50][50] public canvas; // 500/10 x 500/10 grid

    string[5] public pastelColors = [
        "#f7c5d5",
        "#d5e8f7",
        "#e7d5f7",
        "#f7d5e2",
        "#d5f7e2"
    ];

    function generatePattern() public {
        uint256 seed = uint256(blockhash(block.number - 1));

        uint256 x = 25; // Start in the middle of the canvas
        uint256 y = 25;

        while (y < 50) {
            uint8 colorIndex = uint8(pseudoRandom(seed, x, y, 0) % 5);
            bool lineDirection = pseudoRandom(seed, x, y, 1) < 500; // Decide line direction

            Line memory line;
            line.colorIndex = colorIndex;
            if (lineDirection) {
                line.lineType = LineType.FORWARD; // Adjusted reference to lineType
            } else {
                line.lineType = LineType.BACKWARD; // Adjusted reference to lineType
            }
            canvas[x][y] = line;

            x += 1;
            if (x >= 50) {
                x = 0;
                y += 1;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }
}
