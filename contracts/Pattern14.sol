// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CyanDiagonalPattern {

    // true represents diagonal from top-left to bottom-right.
    // false represents diagonal from bottom-left to top-right.
    bool[150][50] public diagonals; // Grid of 150x50 cells (based on 10 pixel steps)

    function generatePattern(uint256 tokenId) public {
        for (uint256 x = 0; x < 150; x++) {
            for (uint256 y = 0; y < 50; y++) {
                diagonals[x][y] = (pseudoRandom(tokenId, x, y) > 500);
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    function getDiagonalDirection(uint256 x, uint256 y) public view returns (bool) {
        require(x < 150 && y < 50, "Coordinates out of bounds");
        return diagonals[x][y];
    }

    function getSvgData() public view returns (string memory) {
        bytes memory svg = abi.encodePacked('<svg width="1500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 50; y++) {
            for (uint256 x = 0; x < 150; x++) {
                if (diagonals[x][y]) {
                    // Diagonal from top-left to bottom-right
                    svg = abi.encodePacked(svg, 
                        '<line x1="', uintToString(x * 10), 
                        '" y1="', uintToString(y * 10), 
                        '" x2="', uintToString((x + 1) * 10), 
                        '" y2="', uintToString((y + 1) * 10), 
                        '" style="stroke:cyan;stroke-width:2" />');
                } else {
                    // Diagonal from bottom-left to top-right
                    svg = abi.encodePacked(svg, 
                        '<line x1="', uintToString(x * 10), 
                        '" y1="', uintToString((y + 1) * 10), 
                        '" x2="', uintToString((x + 1) * 10), 
                        '" y2="', uintToString(y * 10), 
                        '" style="stroke:cyan;stroke-width:2" />');
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
