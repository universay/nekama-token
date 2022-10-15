### hardhat tutorial
- [7. Deploying to a live network](https://hardhat.org/tutorial/deploying-to-a-live-network)

# nekama-token

```sh
# Repositories Clone
git clone https://github.com/universay/Alchemy.git
```

```sh
# remote接続
sudo git remote add universay https://github.com/universay/nekama-token.git
```

```sh
# VScode 権限付与
sudo chown -R tomato /home/tomato/projects/Alchemy
```

## 実行
```
npx hardhat run scripts/deploy.js --network matic
```

## Alchemy

address:
0xC6A466053Cdb44e67688fE6c2de85e1614A31cc2

https://polygon-mainnet.g.alchemy.com/v2/-nbyw_FlW8BNxbnNVEM5isZmPXCoiqMV


### Rinkeby
- [How to deploy your smart contract to Rinkeby](https://soliditytips.com/articles/guide-deploy-smart-contract-rinkeby/)
- [How to deploy a Smart Contract to the Testnet](https://dev.to/emanuelferreira/how-to-deploy-smart-contract-to-rinkeby-testnet-using-infura-and-hardhat-5ddj)
### Infura
- [Choose a network](https://docs.infura.io/infura/networks/ethereum/how-to/choose-a-network)
- [APIkey(mayo)](https://infura.io/dashboard/ethereum/2b789277aa9b46b68baca4d19ce4bf34/settings)
### Etherscan
- Etherscanでアドレスを検索する 
- contracts or token address (hash)
- [Rinkeby Blocks Explore](https://rinkeby.etherscan.io/blocks)
- [my token hash](https://rinkeby.etherscan.io/tx/0x9bcf23d1ba4fc2e5d57630e025a393e265a931f6118721cd9c215565e677a6fe)



https://rinkeby.infura.io/v3/2b789277aa9b46b68baca4d19ce4bf34

### デプロイしたトークンの情報
```sh
$ npx hardhat run scripts/deploy.js --network rinkeby

Deploying contracts with the account: 
0x7e28fF8aA2962DA45212711C6679E7a3FA24482D
Account balance: 2000000000000000000
Token address: 0x3265da402CAf1f082c7e9166b5908C82A9e6A613
```