//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ERC1363Receiver{
    function onTransferReceived(address operator, address from
    , uint256 value, bytes memory data) external returns (bytes4);
}

interface ERC1363Spender{
    function onApprovalReceived(address owner, uint256 value, bytes memory data) external returns (bytes4);
}

contract ERC1363 is ERC20{
    mapping(address => bool) public whitelist;
    address public owner;

    function rely(address user) external auth {whitelist[user] = true;}
    function dely(address user) external auth {whitelist[user] = false;}
    modifier auth{
        require(whitelist[msg.sender] == true, "not authorized");
        _;
    }

    function transferAndCall(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        receiver
        return true;
    }

    function mint(address user, uint256 amount) auth external {
        _mint(account, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}