// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./TaikoL2.sol";

/// @title TaikoL2EIP1559Configurable
/// @notice TaikoL2 with a setter to change EIP-1559 configurations and states.
/// @custom:security-contact security@taiko.xyz
contract TaikoL2EIP1559Configurable is TaikoL2 {
    /// @notice EIP-1559 configuration.
    Config public customConfig;

    uint256[49] private __gap;

    /// @notice Emits when the EIP-1559 configuration and gas excess are changed.
    /// @param config The new EIP-1559 config.
    /// @param gasExcess The new gas excess.
    event ConfigAndExcessChanged(Config config, uint64 gasExcess);

    error L2_INVALID_CONFIG();

    /// @notice Sets EIP1559 configuration and gas excess.
    /// @param newConfig The new EIP1559 config.
    /// @param newGasExcess The new gas excess
    function setConfigAndExcess(
        Config memory newConfig,
        uint64 newGasExcess
    )
        external
        virtual
        onlyOwner
    {
        if (newConfig.gasTargetPerL1Block == 0) revert L2_INVALID_CONFIG();
        if (newConfig.basefeeAdjustmentQuotient == 0) revert L2_INVALID_CONFIG();

        customConfig = newConfig;
        gasExcess = newGasExcess;

        emit ConfigAndExcessChanged(newConfig, newGasExcess);
    }

    /// @inheritdoc TaikoL2
    function getConfig() public view override returns (Config memory) {
        return customConfig;
    }
}
