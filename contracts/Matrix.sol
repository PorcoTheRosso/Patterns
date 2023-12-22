// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatrixPattern {

    uint256 constant cellSize = 10;
    uint256 constant width = 500;
    uint256 constant height = 500;
    string constant chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\u3042\u3044\u3046\u3048\u304A\u304B\u304D\u304F\u3051\u3053\u3055\u3057\u3059\u305B\u305D\u305F\u3061\u3064\u3066\u3068\u306A\u306B\u306C\u306D\u306E\u306F\u3072\u3075\u3078\u307B";


    // Helper function to simulate the pseudoRandom function
    function pseudoRandom(uint256 x, uint256 y) internal pure returns (uint256) {
        // Scaling to simulate the floating point operation using integers
        return (x * y * 12345 / 100000000 + x * 142857 / 1000000 + y * 238095 / 1000000) % 1000;
    }

    // Helper function to simulate the pseudoOffset function
    function pseudoOffset(uint256 x) internal pure returns (uint256) {
        // Scaling to simulate the floating point operation using integers
        return (x * 238095 / 1000000) % (cellSize * 3 / 2);
    }

    // Helper function to simulate the pseudoSpacing function
    function pseudoSpacing(uint256 val) internal pure returns (uint256) {
        // Scaling to simulate the floating point operation using integers
        return (val * 12345 / 1000000) % 10;
    }

    // Function to get character from the string by index
    function getCharAt(string memory str, uint256 index) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(1);
        result[0] = strBytes[index];
        return string(result);
    }

    // Function to generate the SVG pattern
    function getSvg() public pure returns (string memory) {
        string memory svgString = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">';
        uint256 xOffset;
        uint256 yOffset;
        uint256 charIndex;
        string memory char;
        uint256 randomVal;

        for (uint256 x = 0; x < width; x += cellSize + pseudoSpacing(x)) {
            xOffset = pseudoOffset(x);
            // We do not handle columnHeight as in p5.js since we're not drawing rectangles, we're generating text elements

            for (uint256 y = 0; y < height; y += cellSize + pseudoSpacing(y)) {
                yOffset = y + cellSize;
                randomVal = pseudoRandom(x, y);

                if (randomVal > 200 && randomVal < 800) {  // Simulating the condition (noiseVal > 0.2 && noiseVal < 0.8)
                    charIndex = randomVal * bytes(chars).length / 1000;  // Scale down to get the index
                    char = getCharAt(chars, charIndex);

                    // Add text to the SVG. Note: We need to add a function to convert numbers to string
                    svgString = string(abi.encodePacked(svgString, 
                    '<text x="', uintToString(x), 
                    '" y="', uintToString(yOffset), 
                    '" fill="white">', 
                    char, 
                    '</text>'));
                }
            }
        }

        svgString = string(abi.encodePacked(svgString, '</svg>'));
        return svgString;
    }

    // Convert uint to string
    function uintToString(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
