const TestToken = artifacts.require('./helper/TestToken.sol');
const BigNumber = require('bignumber.js');
const Hydro = artifacts.require('./Hydro.sol');
const PriceOracle = artifacts.require('./PriceOracle.sol');

BigNumber.config({
    EXPONENTIAL_AT: 1000
});

const wei = new BigNumber('1000000000000000000');
const toWei = x => {
    return new BigNumber(x).times(wei).toString();
};

module.exports = async () => {
    try {
        const hotToken = await TestToken.new('HOT', 'HOT', 18);
        console.log('HOT', hotToken.address);

        const tokenDAI = await TestToken.new('DAI', 'DAI', 18);
        console.log('DAI', tokenDAI.address);

        const tokenUSDC = await TestToken.new('USDC', 'USDC', 18);
        console.log('USDC', tokenUSDC.address);

        const tokenUSDT = await TestToken.new('USDT', 'USDT', 18);
        console.log('USDT', tokenUSDT.address);

        const hydro = await Hydro.new(hotToken.address);
        console.log('Hydro', hydro.address);

        const oracle = await PriceOracle.new();
        console.log('Oracle', oracle.address);

        const etherAddress = '0x0000000000000000000000000000000000000000';
        await hydro.registerAsset(etherAddress, oracle.address, 'Ether', 'Ether', 18);

        await hydro.registerAsset(
            hotToken.address,
            '0xf000000000000000000000000000000000000000',
            'hotToken',
            'hotToken',
            18
        );
        await hydro.registerAsset(
            tokenDAI.address,
            '0xf000000000000000000000000000000000000000',
            'tokenDAI',
            'tokenDAI',
            18
        );
        await hydro.registerAsset(
            tokenUSDC.address,
            '0xf000000000000000000000000000000000000000',
            'tokenUSDC',
            'tokenUSDC',
            18
        );
        await hydro.registerAsset(
            tokenUSDT.address,
            '0xf000000000000000000000000000000000000000',
            'tokenUSDT',
            'tokenUSDT',
            18
        );

        await oracle.setPrice(etherAddress, toWei('100'));
        await oracle.setPrice(hotToken.address, toWei('0.1'));
        await oracle.setPrice(tokenDAI.address, toWei('1'));
        await oracle.setPrice(tokenUSDC.address, toWei('1'));
        await oracle.setPrice(tokenUSDT.address, toWei('1'));

        await hydro.createMarket({
            liquidateRate: toWei('1.1'),
            withdrawRate: toWei('2'),
            baseAsset: hotToken.address,
            quoteAsset: tokenDAI.address,
            auctionRatioStart: '10000000000000000',
            auctionRatioPerBlock: '10000000000000000'
        });

        await hydro.createMarket({
            liquidateRate: toWei('1.1'),
            withdrawRate: toWei('2'),
            baseAsset: hotToken.address,
            quoteAsset: tokenUSDC.address,
            auctionRatioStart: '10000000000000000',
            auctionRatioPerBlock: '10000000000000000'
        });

        await hydro.createMarket({
            liquidateRate: toWei('1.1'),
            withdrawRate: toWei('2'),
            baseAsset: etherAddress,
            quoteAsset: tokenDAI.address,
            auctionRatioStart: '10000000000000000',
            auctionRatioPerBlock: '10000000000000000'
        });

        await hydro.createMarket({
            liquidateRate: toWei('1.1'),
            withdrawRate: toWei('2'),
            baseAsset: etherAddress,
            quoteAsset: tokenUSDC.address,
            auctionRatioStart: '10000000000000000',
            auctionRatioPerBlock: '10000000000000000'
        });

        process.exit(0);
    } catch (e) {
        console.log(e);
    }
};
