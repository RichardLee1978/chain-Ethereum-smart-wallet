// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "openzeppelin-contracts/contracts/proxy/Clones.sol";
import {Address} from "openzeppelin-contracts/contracts/utils/Address.sol";

/*
 * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
 * 部署最小代理合约，也称为“克隆”
 */
contract WalletFactory {
    //钱包合约创建事件
    event WalletDeployment(address indexed proxy, address indexed implementation);

    /**
     * @notice createWallet with no salt
     * @param _implementation Proxy wallet contract address
     * @param _initCallData call data
     */
    function createWallet(address _implementation, bytes memory _initCallData) public payable returns (address wallet) {
        wallet = _clone(_implementation, _initCallData);

        emit WalletDeployment(wallet, _implementation);
    }
    /**
     * @notice createWallet with salt(use Create2 function)
     * @param _implementation Proxy wallet contract address
     * @param _initCallData call data
     * @param _salt salt
     */
    function createWallet(address _implementation, bytes memory _initCallData, bytes32 _salt)
        public
        payable
        returns (address wallet)
    {
        wallet = _cloneDeterministic(_implementation, _initCallData, _salt);

        emit WalletDeployment(wallet, _implementation);
    }
    /**
     * 预测 确定性地址
     * @param implementation Proxy wallet contract address
     * @param salt salt
     * @return address 合约的地址
     */
    function predictDeterministicAddress(address implementation, bytes32 salt) public view returns (address) {
        return Clones.predictDeterministicAddress(implementation, salt);
    }

    /**
     * @notice clone use Create function
     * @param _implementation Proxy wallet contract address
     * @param _initCallData call data
     * @return _contract  address of new wallet
     */
    function _clone(address _implementation, bytes memory _initCallData) internal returns (address _contract) {
        _contract = Clones.clone(_implementation);

        // Initialize Wallet
        if (_initCallData.length > 0) {
            Address.functionCallWithValue(_contract, _initCallData, msg.value);
        }
    }
    
    /**
     * @notice clone use Create2 function
     * @param _implementation Proxy wallet contract address
     * @param _initCallData call data
     * @param _salt salt
     * @return _contract   address of new wallet
     */
    function _cloneDeterministic(address _implementation, bytes memory _initCallData, bytes32 _salt)
        internal
        returns (address _contract)
    {
        _contract = Clones.cloneDeterministic(_implementation, _salt);

        // Initialize Wallet
        if (_initCallData.length > 0) {
            Address.functionCallWithValue(_contract, _initCallData, msg.value);
        }
    }
    /**
     * clone with param value Denominator  
     * @param _implementation Proxy wallet contract address
     * @param _initCallData call data
     * @param _salt salt
     * @param _valueDenominator  the 'msg.value' be divided with value Denominator
     */
    function _cloneDeterministic(
        address _implementation,
        bytes memory _initCallData,
        bytes32 _salt,
        uint256 _valueDenominator
    ) internal returns (address _contract) {
        _contract = Clones.cloneDeterministic(_implementation, _salt);

        // Initialize wallet
        if (_initCallData.length > 0) {
            Address.functionCallWithValue(_contract, _initCallData, msg.value / _valueDenominator);
        }
    }
}