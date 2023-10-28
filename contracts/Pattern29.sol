// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GMGrid {

    enum CharType { G, M }

    struct CellData {
        CharType charType;
        uint8 colorIndex;
    }

    CellData[15][15] public grid; // Grid based on 600/40 x 600/40

    string[5] public gmColors = ["#FEBFCA", "#D7EBEE", "#F8DCC1", "#C5E99B", "#E8D8EC"];

 function generateGrid(uint256 tokenId) public pure returns (CellData[15][15] memory) {
    uint256 seed = tokenId; // Use tokenId as seed for randomization
    CellData[15][15] memory localGrid;

    for (uint256 x = 0; x < 15; x++) {
        for (uint256 y = 0; y < 15; y++) {
            CellData memory cell;
            uint256 randChar = pseudoRandom(seed, x, y, 0) % 2;
            cell.charType = CharType(randChar);
            cell.colorIndex = uint8(pseudoRandom(seed, x, y, 1) % 5); // There are 5 colors
            localGrid[x][y] = cell;
        }
    }
    return localGrid;
}

    function pseudoRandom(uint256 seed, uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y, z))) % 1000;
    }

    function getCellData(uint256 x, uint256 y) public view returns (CellData memory) {
        require(x < 15 && y < 15, "Coordinates out of bounds");
        return grid[x][y];
    }

function getSvgData(uint256 tokenId) public view returns (string memory) {
    CellData[15][15] memory localGrid = generateGrid(tokenId);
    bytes memory svg = abi.encodePacked('<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">');

        for (uint256 y = 0; y < 15; y++) {
            for (uint256 x = 0; x < 15; x++) {
                CellData memory cell = localGrid[x][y];
                svg = abi.encodePacked(svg, 
                    '<rect x="', uintToString(x * 40), 
                    '" y="', uintToString(y * 40), 
                    '" width="40" height="40" fill="', gmColors[cell.colorIndex], '" />',
                    '<text x="', uintToString(x * 40 + 15), '" y="', uintToString(y * 40 + 25), 
                    '" fill="black" font-size="20">', 
                    (cell.charType == CharType.G) ? 'G' : 'M', 
                    '</text>'
                );
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
