// SPDX-License-Identifier: MIT
//FINAL EDIT
pragma solidity ^0.8.0;

import "./base64.sol";

contract StripePatternV1a {
    struct Stripe {
        uint256 positionX;
        uint256 colorHue;
        uint256 colorSaturation;
        uint256 colorBrightness;
    }

    uint256 constant NUMBER_STRIPES = 20;

    function randomizePattern(
        uint256 tokenId
    ) internal pure returns (Stripe[] memory stripes) {
        uint256 random = uint256(keccak256(abi.encodePacked(tokenId)));

        stripes = new Stripe[](NUMBER_STRIPES);
        for (uint256 i = 0; i < NUMBER_STRIPES; i++) {
            stripes[i].positionX = (random / (i + 1)) % 500;
            stripes[i].colorHue = (random / (i + 1)) % 360;
            stripes[i].colorSaturation = 50 + ((random / (i + 1)) % 50);
            stripes[i].colorBrightness = 50 + ((random / (i + 1)) % 50);
        }

        return stripes;
    }

    function getSvgData(uint256 _tokenId) public pure returns (string memory) {
        Stripe[] memory stripes = randomizePattern(_tokenId);

        uint256 stripeWidth = 500 / NUMBER_STRIPES;
        bytes memory svg = abi.encodePacked(
            '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">'
        );

        for (uint256 i = 0; i < NUMBER_STRIPES; i++) {
            svg = abi.encodePacked(
                svg,
                '<rect x="',
                uintToString(stripes[i].positionX),
                '" y="0" width="',
                uintToString(stripeWidth),
                '" height="500" fill="hsl(',
                uintToString(stripes[i].colorHue),
                ", ",
                uintToString(stripes[i].colorSaturation),
                "%, ",
                uintToString(stripes[i].colorBrightness),
                '%)" />'
            );
        }

        svg = abi.encodePacked(svg, "</svg>");
        return string(svg);
    }

    function getDataUrl(
        uint256 _tokenId
    ) external pure returns (string memory) {
        string memory result = string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(getSvgData(_tokenId)))
            )
        );

        return result;
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
