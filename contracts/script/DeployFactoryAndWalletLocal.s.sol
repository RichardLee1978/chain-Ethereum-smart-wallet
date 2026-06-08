// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {console} from "forge-std/console.sol";

import {Script} from "forge-std/Script.sol";

import {Currency} from "v4-core/src/types/Currency.sol";
import {IPermit2} from "permit2/src/interfaces/IPermit2.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {IPositionManager} from "v4-periphery/src/interfaces/IPositionManager.sol";
import {IUniswapV4Router04} from "hookmate/interfaces/router/IUniswapV4Router04.sol";
import {AddressConstants} from "hookmate/constants/AddressConstants.sol";

import {Permit2Deployer} from "hookmate/artifacts/Permit2.sol";
import {V4PoolManagerDeployer} from "hookmate/artifacts/V4PoolManager.sol";
import {V4PositionManagerDeployer} from "hookmate/artifacts/V4PositionManager.sol";
import {V4RouterDeployer} from "hookmate/artifacts/V4Router.sol";

import {WalletFactory} from "../src/WalletFactory.sol";
import {ProxyWallet} from "../src/ProxyWallet.sol";

//import {Deployers} from "../script/Deployers.s.sol";


contract DeployFactoryAndWalletLocal is Script{
    IPermit2 permit2;
    IPoolManager poolManager;
    IPositionManager positionManager;
    IUniswapV4Router04 swapRouter;
    Currency  currency0;
    Currency  currency1;
     function run() public{
       
        vm.startBroadcast();
        deployArtifacts();
        
        
        //(currency0, currency1) = deployCurrencyPair();
       
        WalletFactory factory = new WalletFactory();
        ProxyWallet walletImpl = new ProxyWallet(
            address(swapRouter),
            address(poolManager),
            address(permit2),
            address(positionManager),
            address(factory)
        );
         
        
        
        console.log("WalletFactory deployed at:", address(factory));
        console.log("permit2 deployed at:", address(permit2));
        console.log("poolManager deployed at:", address(poolManager));
        console.log("positionManager deployed at:", address(positionManager));
        console.log("swapRouter deployed at:", address(swapRouter));
        console.log("ProxyWallet deployed at:", address(walletImpl));
        // saveContracts('permit2',address(permit2),block.chainid);
        // saveContracts('poolManager',address(poolManager),block.chainid);
        // saveContracts('positionManager',address(positionManager),block.chainid);
        // saveContracts('swapRouter',address(swapRouter),block.chainid);
        // saveContracts('WalletFactory',address(factory),block.chainid);
        // saveContracts('ProxyWallet',address(walletImpl),block.chainid);
        vm.stopBroadcast();
        
       
        
        
     }
     //部署Permit2
    function deployPermit2() internal {
        address permit2Address = AddressConstants.getPermit2Address();

        // if (permit2Address.code.length > 0) {
        //     // Permit2 is already deployed, no need to etch it.
        // } else {
        //     _etch(permit2Address, Permit2Deployer.deploy().code);
        // }

        permit2 = IPermit2(permit2Address);
        //saveContracts("permit2",address(permit2));
    }

    //部署PoolManager
     function deployPoolManager() internal virtual {
         //local network
        poolManager = IPoolManager(V4PoolManagerDeployer.deploy(address(0x4444)));
        //saveContracts("poolManager",address(poolManager));
    }
    //部署PositionManager
    function deployPositionManager() internal virtual {
         //local network
        positionManager = IPositionManager(
                V4PositionManagerDeployer.deploy(
                    address(poolManager), address(permit2), 300_000, address(0), address(0)
                )
            );
        
        //saveContracts("positionManager",address(positionManager));
    }
    //部署UniSwapV4 Router
    function deployRouter() internal virtual {
        //local network
         swapRouter = IUniswapV4Router04(payable(V4RouterDeployer.deploy(address(poolManager), address(permit2))));
        //saveContracts("swapV4Router",address(swapRouter));
    }
    function _etch(address, bytes memory) internal virtual {
        revert("Not implemented");
    }
    function deployArtifacts() internal {
        
        deployPermit2();
        deployPoolManager();
        deployPositionManager();
        deployRouter();
    }

    function saveContracts(string memory name,address addr,uint256 chainid) internal {
        string memory chainId = vm.toString(chainid);
        string memory json1="key";
        string memory finalJson = vm.serializeAddress(json1, "address", addr);
        string memory dirPath = string.concat(string.concat("deploy_ContractsABIs/", name), "_");
        vm.writeJson(finalJson, string.concat(dirPath, string.concat(chainId, ".json"))); 

    }
}