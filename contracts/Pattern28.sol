// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract TextGrid {

    enum CharType { G, M }

    struct CellData {
        uint8 red;
        uint8 green;
        uint8 blue;
        CharType charType;
    }

    CellData[10][10] public grid; // 10x10 grid

function generateGrid(uint256 tokenId) public pure returns (CellData[10][10] memory) {
    uint256 seed = tokenId; // Use tokenId as seed
    CellData[10][10] memory localGrid;

    for (uint256 x = 0; x < 10; x++) {
        for (uint256 y = 0; y < 10; y++) {
            CellData memory cell;
            uint256 randChar = pseudoRandom(seed, x, y, 0) % 10;
            if (randChar < 5) {
                cell.red = uint8(pseudoRandom(seed, x, y, 1) % 256);
                cell.green = 0;
                cell.blue = uint8(pseudoRandom(seed, x, y, 2) % 256);
                cell.charType = CharType.G;
            } else {
                cell.red = 0;
                cell.green = uint8(pseudoRandom(seed, x, y, 3) % 256);
                cell.blue = uint8(pseudoRandom(seed, x, y, 4) % 256);
                cell.charType = CharType.M;
            }
            localGrid[x][y] = cell;
        }
    }
    return localGrid;
}

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }

    function getCellData(uint256 x, uint256 y) public view returns (CellData memory) {
        require(x < 10 && y < 10, "Coordinates out of bounds");
        return grid[x][y];
    }

function getSvgData(uint256 tokenId) public pure returns (string memory) {
    CellData[10][10] memory localGrid = generateGrid(tokenId);
    bytes memory svg = abi.encodePacked('<svg width="1000" height="1000" xmlns="http://www.w3.org/2000/svg">');

    for (uint256 y = 0; y < 10; y++) {
        for (uint256 x = 0; x < 10; x++) {
            CellData memory cell = localGrid[x][y];
            svg = abi.encodePacked(svg, 
                '<rect x="', uintToString(x * 100), 
                '" y="', uintToString(y * 100), 
                '" width="100" height="100" fill="rgb(', 
                uintToString(cell.red), ',', uintToString(cell.green), ',', uintToString(cell.blue), ')" />',
                '<text x="', uintToString(x * 100 + 40), '" y="', uintToString(y * 100 + 60), 
                '" fill="white" font-size="40">', 
                (cell.charType == CharType.G) ? 'G' : 'M', 
                '</text>'
            );
        }
    }

    svg = abi.encodePacked(svg, '</svg>');
    console.log("SVG: %s", string(svg));
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
