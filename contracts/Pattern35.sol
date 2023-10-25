// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiagonalPattern {

    enum LineType { NONE, FORWARD, BACKWARD }

    struct Line {
        LineType lineType;
        uint8 colorIndex;
    }

    Line[50][50] public canvas;

    string[5] public pastelColors = [
        "#f7c5d5",
        "#d5e8f7",
        "#e7d5f7",
        "#f7d5e2",
        "#d5f7e2"
    ];

    function generatePattern(uint256 tokenId) public {
        uint256 seed = tokenId;

        uint256 x = 25; 
        uint256 y = 25;

        while (y < 50) {
            uint8 colorIndex = uint8(pseudoRandom(seed, x, y, 0) % 5);
            bool lineDirection = pseudoRandom(seed, x, y, 1) < 500;

            Line memory line;
            line.colorIndex = colorIndex;
            if (lineDirection) {
                line.lineType = LineType.FORWARD;
            } else {
                line.lineType = LineType.BACKWARD;
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

    function getSvgData(uint256 tokenId) public returns (string memory) {
        generatePattern(tokenId);

        bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                if (canvas[i][j].lineType == LineType.FORWARD) {
                    svg = abi.encodePacked(
                        svg,
                        '<line x1="',
                        uintToString(i * 10),
                        '" y1="',
                        uintToString(j * 10),
                        '" x2="',
                        uintToString(i * 10 + 10),
                        '" y2="',
                        uintToString(j * 10 + 10),
                        '" stroke="',
                        pastelColors[canvas[i][j].colorIndex],
                        '" />'
                    );
                } else if (canvas[i][j].lineType == LineType.BACKWARD) {
                    svg = abi.encodePacked(
                        svg,
                        '<line x1="',
                        uintToString(i * 10),
                        '" y1="',
                        uintToString(j * 10 + 10),
                        '" x2="',
                        uintToString(i * 10 + 10),
                        '" y2="',
                        uintToString(j * 10),
                        '" stroke="',
                        pastelColors[canvas[i][j].colorIndex],
                        '" />'
                    );
                }
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
