//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SignedNFT is ERC721{
    mapping(address => bool) public whitelist;
    address public owner;
    string public constant version = "1";
    string private _tokenURI;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant MINT_TYPEHASH = 0x9e57a19aa1707606b4e7bd6faedd756ad05cf15ef46ec85bb8a69a690b376a08;

    constructor(string memory name, uint256 chainId_) ERC721("SignedNFT", "SNT"){
        whitelist[msg.sender] == true;
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            chainId_,
            address(this)
        ));
    }

    function rely(address user) external auth {whitelist[user] = true;}
    function dely(address user) external auth {whitelist[user] = false;}
    modifier auth{
        require(whitelist[msg.sender] == true, "not authorized");
        _;
    }

    function safeMint(address to, uint256 tokenId, uint8 v, bytes32 r, bytes32 s) external auth {
        bytes32 digest =
        keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(MINT_TYPEHASH, to, tokenId))
        ));
        require(to == ecrecover(digest, v, r, s));
        _safeMint(to, tokenId);
    }

    function burn(uint256 tokenId) external {
        _burn(tokenId);
    }

    function setBaseURI(string memory baseURI_) external auth {
        _tokenURI = baseURI_;
    }

    function getTokenURI() external view returns (string memory){
        return _tokenURI;
    }
}