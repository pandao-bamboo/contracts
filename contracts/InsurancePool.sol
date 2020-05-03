pragma solidity ^0.6.4;

/// Utilities
import "../node_modules/@nomiclabs/buidler/console.sol";
import "./libraries/StringHelper.sol";

/// Imports
import "../node_modules/@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

/// PanDAO
import "./TokenStorage.sol";
import "./factories/TokenFactory.sol";


contract InsurancePool is Ownable, TokenStorage, TokenFactory, StringHelper {
    bytes32 public constant insurancePoolStorage = keccak256(
        "InsurancePool.storage.location"
    );

    struct insurancePool {
        address insuredTokenAddress;
        uint256 insureeFeeRate;
        uint256 serviceFeeRate;
        uint256 claimPenalty;
    }

    ClaimsToken public claimsToken;
    CollateralToken public collateralToken;

    /// Public
    constructor(
        address _tokenAddressToInsure,
        string _tokenSymbol,
        uint256 _claimPenalty,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate
    ) public {
        insurancePool storage insurancePool = load();

        require(
            address(insurancePool.insuredTokenAddress) ==
                address(_tokenAddressToInsure),
            "InsurancePool.create: Insurance Pool already exists."
        );
        require(
            _tokenAddressToInsure != address(0),
            "InsurancePool.create: _tokenAddressToInsure can not be 0x00"
        );

        owner = msg.sender;

        insurancePool.claimPenalty = _claimPenalty;
        insurancePool.insureeFeeRate = _insureeFeeRate;
        insurancePool.insuredTokenAddress = _tokenAddressToInsure;
        insurancePool.serviceFeeRate = _serviceFeeRate;

        TokenFactory.createTokens(_tokenSymbol);
    }

    /// Load storage
    function load() internal pure returns (insurancePool storage s) {
        bytes32 location = insurancePoolStorage;

        assembly {
            s_slot := location
        }
    }
}
