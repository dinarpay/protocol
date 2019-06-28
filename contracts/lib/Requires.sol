/*

    Copyright 2019 The Hydro Protocol Foundation

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

import "./Store.sol";
import "../helper/StandardToken.sol";

library Requires {
    function requireAssetExist(
        Store.State storage state,
        address asset
    )
        internal
        view
    {
        require(isAssetExist(state, asset), "ASSET_NOT_EXIST");
    }

    function requireAssetNotExist(
        Store.State storage state,
        address asset
    )
        internal
        view
    {
        require(!isAssetExist(state, asset), "ASSET_ALREADY_EXIST");
    }

    function requireMarketIDAndAssetMatch(
        Store.State storage state,
        uint16 marketID,
        address asset
    )
        internal
        view
    {
        require(
            asset == state.markets[marketID].baseAsset || asset == state.markets[marketID].quoteAsset,
            "ASSET_NOT_BELONGS_TO_MARKET"
        );
    }

    function requireMarketNotExist(
        Store.State storage state,
        Types.Market memory market
    )
        internal
        view
    {
        require(!isMarketExist(state, market), "MARKET_ALREADY_EXIST");
    }

    function requireMarketAssetsValid(
        Store.State storage state,
        Types.Market memory market
    )
        internal
        view
    {
        require(market.baseAsset != market.quoteAsset, "BASE_QUOTE_DUPLICATED");
        require(isAssetExist(state, market.baseAsset), "MARKET_BASE_ASSET_NOT_EXIST");
        require(isAssetExist(state, market.quoteAsset), "MARKET_QUOTE_ASSET_NOT_EXIST");
    }

    function requireCashLessThanOrEqualContractBalance(
        Store.State storage state,
        address asset
    )
        internal
        view
    {
        require(state.cash[asset] <= StandardToken(asset).balanceOf(address(this)), "CONTRACT_BALANCE_NOT_ENOUGH");
    }

    function requirePriceOracleAddressValid(
        address oracleAddress
    )
        internal
        pure
    {
        require(oracleAddress != address(0), "ORACLE_ADDRESS_NOT_VALID");
    }

    function requireDecimalLessOrEquanThanOne(
        uint256 decimal
    )
        internal
        pure
    {
        require(decimal <= Decimal.one(), "DECIMAL_GREATER_THAN_ONE");
    }

    function requireDecimalGreaterThanOne(
        uint256 decimal
    )
        internal
        pure
    {
        require(decimal > Decimal.one(), "DECIMAL_LESS_OR_EQUAL_THAN_ONE");
    }

    function requireMarketIDExist(
        Store.State storage state,
        uint16 marketID
    )
        internal
        view
    {
        require(marketID < state.marketsCount, "MARKET_NOT_EXIST");
    }

    function isAssetExist(
        Store.State storage state,
        address asset
    )
        internal
        view
        returns (bool)
    {
        return state.assets[asset].priceOracle != IPriceOracle(address(0));
    }

    function isMarketExist(
        Store.State storage state,
        Types.Market memory market
    )
        internal
        view
        returns (bool)
    {
        for(uint16 i = 0; i < state.marketsCount; i++) {
            if (state.markets[i].baseAsset == market.baseAsset && state.markets[i].quoteAsset == market.quoteAsset) {
                return true;
            }
        }

        return false;
    }

}
