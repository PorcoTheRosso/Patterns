// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatternCanvas {

    enum ElementType { NONE, RECT, DIAGLINE, VERTLINE, HORILINE }

    struct Element {
        ElementType elementType;
    }

    Element[25][25] public canvas;

function generatePattern(uint256 tokenId) public pure returns (Element[25][25] memory) {
    uint256 seed = tokenId; 
    Element[25][25] memory localCanvas;

    for (uint256 x = 0; x < 25; x++) {
        for (uint256 y = 0; y < 25; y++) {
            uint256 randValue = pseudoRandom(seed, x, y) % 5;
            localCanvas[x][y] = Element(ElementType(randValue));
        }
    }
    return localCanvas;
}

    function pseudoRandom(uint256 seed, uint256 x, uint256 y) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, x, y))) % 1000;
    }

function getSvgData(uint256 tokenId) public pure returns (string memory) {
    Element[25][25] memory localCanvas = generatePattern(tokenId);

    bytes memory svg = abi.encodePacked('<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">');

    for (uint256 y = 0; y < 25; y++) {
        for (uint256 x = 0; x < 25; x++) {
            if (localCanvas[x][y].elementType == ElementType.RECT) {
                svg = abi.encodePacked(svg, '<rect x="', uintToString(x * 20), '" y="', uintToString(y * 20), '" width="20" height="20" fill="black" />');
            } else if (localCanvas[x][y].elementType == ElementType.DIAGLINE) {
                svg = abi.encodePacked(svg, '<line x1="', uintToString(x * 20), '" y1="', uintToString(y * 20), '" x2="', uintToString((x + 1) * 20), '" y2="', uintToString((y + 1) * 20), '" stroke="black" />');
            } else if (localCanvas[x][y].elementType == ElementType.VERTLINE) {
                svg = abi.encodePacked(svg, '<line x1="', uintToString(x * 20), '" y1="', uintToString(y * 20), '" x2="', uintToString(x * 20), '" y2="', uintToString((y + 1) * 20), '" stroke="black" />');
            } else if (localCanvas[x][y].elementType == ElementType.HORILINE) {
                svg = abi.encodePacked(svg, '<line x1="', uintToString(x * 20), '" y1="', uintToString(y * 20), '" x2="', uintToString((x + 1) * 20), '" y2="', uintToString(y * 20), '" stroke="black" />');
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

    function getElementData(uint256 x, uint256 y) public view returns (Element memory) {
        require(x < 25 && y < 25, "Coordinates out of bounds");
        return canvas[x][y];
    }
}
