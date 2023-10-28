// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradientDiagonalPattern {

    struct DiagonalData {
        bool direction;   // true: top-left to bottom-right, false: bottom-left to top-right
        uint8 redValue;   // Red component of the color
    }

    DiagonalData[30][10] public diagonals; // Grid of 30x10 cells (based on 50 pixel steps)

    function generatePattern(uint256 tokenId) public {
        for (uint256 x = 0; x < 30; x++) {
            for (uint256 y = 0; y < 10; y++) {
                DiagonalData memory d;
                d.direction = (pseudoRandom(tokenId, x, y) > 500);
                d.redValue = uint8((x * 255) / 29);
                diagonals[y][x] = d;
            }
        }
    }

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

    function getDiagonalData(uint256 x, uint256 y) public view returns (DiagonalData memory) {
        require(x < 30 && y < 10, "Coordinates out of bounds");
        return diagonals[y][x];
    }

    function getSvgData() public view returns (string memory) {
        bytes memory svg = abi.encodePacked('<svg width="1500" height="500" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 10; y++) {
            for (uint256 x = 0; x < 30; x++) {
                if (diagonals[y][x].direction) {
                    // Diagonal from top-left to bottom-right
                    svg = abi.encodePacked(svg, 
                        '<line x1="', uintToString(x * 50), 
                        '" y1="', uintToString(y * 50), 
                        '" x2="', uintToString((x + 1) * 50), 
                        '" y2="', uintToString((y + 1) * 50), 
                        '" style="stroke:rgb(', uintToString(diagonals[y][x].redValue), ',0,0);stroke-width:2" />');
                } else {
                    // Diagonal from bottom-left to top-right
                    svg = abi.encodePacked(svg, 
                        '<line x1="', uintToString(x * 50), 
                        '" y1="', uintToString((y + 1) * 50), 
                        '" x2="', uintToString((x + 1) * 50), 
                        '" y2="', uintToString(y * 50), 
                        '" style="stroke:rgb(', uintToString(diagonals[y][x].redValue), ',0,0);stroke-width:2" />');
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
