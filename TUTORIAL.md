# Hardhat's tutorial for beginners
Welcome to our beginners guide to Ethereum contracts and dApp development. This tutorial aims to quickly get you set up to build something from scratch.

To orchestrate this process we're going to use Hardhat, a development environment that facilitates building on Ethereum. It helps developers manage and automate the recurring tasks that are inherent to the process of building smart contracts and dApps, and it allows you to easily introducing more functionality around this workflow. This means compiling and testing at the very core.

Hardhat also comes built-in with Hardhat Network, a local Ethereum network designed for development. It allows you to deploy your contracts, run your tests and debug your code.

In this tutorial we'll guide you through:

- Setting up your Node.js environment for Ethereum development
- Creating and configuring a Hardhat project
- The basics of a Solidity smart contract that implements a token
- Writing automated tests for your contract using Hardhat
- Debugging Solidity with `console.log()` using Hardhat Network
- Deploying your contract to Hardhat Network and Ethereum testnets

To follow this tutorial you should be able to:

- Write code in JavaScript
- Operate a terminal
- Use git
- Understand the basics of how smart contracts work
- Set up a Metamask wallet

If you can't do any of the above, follow the links and take some time to learn the basics.

# 2. Setting up the environment
Most Ethereum libraries and tools are written in JavaScript, and so is Hardhat. If you're not familiar with Node.js, it's a JavaScript runtime built on Chrome's V8 JavaScript engine. It's the most popular solution to run JavaScript outside of a web browser and Hardhat is built on top of it.

> TIP
>
> Hardhat for Visual Studio Code is the official Hardhat extension that adds advanced support for Solidity to VSCode. If you use Visual Studio Code, give it a try!

# Installing Node.js
You can skip this section if you already have a working Node.js `>=16.0` installation. If not, here's how to install it on Ubuntu, MacOS and Windows.

## Linux
### Ubuntu
Copy and paste these commands in a terminal:
```sh
sudo apt update
sudo apt install curl git
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```


# Upgrading your Node.js installation
If your version of Node.js is older and not supported by Hardhat follow the instructions below to upgrade.

## Linux
### Ubuntu
1. Run `sudo apt remove nodejs` in a terminal to remove Node.js.
2. Find the version of Node.js that you want to install here and follow the instructions.
3. Run `sudo apt update && sudo apt install nodejs` in a terminal to install Node.js again.

# 3. Creating a new Hardhat project
We'll install Hardhat using the Node.js package manager (npm), which is both a package manager and an online repository for JavaScript code.

You can use other package managers with Node.js, but we suggest you use npm 7 or higher to follow this guide. You should already have it if you followed the previous section's steps.

Open a new terminal and run these commands to create a new folder:
```sh
mkdir hardhat-tutorial
cd hardhat-tutorial
```

Then initialize an npm project as shown below. You'll be prompted to answer some questions.

>TIP
>
>Use the tabs in the snippets to select your preferred package manager. We recommend using npm 7 or later, since it makes installing Hardhat's dependencies much easier.

```sh
npm init
```
Now we can install Hardhat:
```sh
npm install --save-dev hardhat
```
In the same directory where you installed Hardhat run:
```sh
npx hardhat
```
Select `Create an empty hardhat.config.js` with your keyboard and hit enter.

```
$ npx hardhat
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

👷 Welcome to Hardhat v2.9.9 👷‍

? What do you want to do? …
  Create a JavaScript project
  Create a TypeScript project
❯ Create an empty hardhat.config.js
  Quit
```
When Hardhat is run, it searches for the closest `hardhat.config.js` file starting from the current working directory. This file normally lives in the root of your project and an empty `hardhat.config.js` is enough for Hardhat to work. The entirety of your setup is contained in this file.

## Hardhat's architecture
Hardhat is designed around the concepts of tasks and plugins. The bulk of Hardhat's functionality comes from plugins, and you're free to choose the ones you want to use.

### Tasks
Every time you're running Hardhat from the command-line, you're running a task. For example, `npx hardhat compile` is running the `compile` task. To see the currently available tasks in your project, run `npx hardhat`. Feel free to explore any task by running `npx hardhat help [task]`.

>TIP
>
>You can create your own tasks. Check out the Creating a task guide.

### Plugins
Hardhat is unopinionated in terms of what tools you end up using, but it does come with some built-in defaults. All of which can be overriden. Most of the time the way to use a given tool is by consuming a plugin that integrates it into Hardhat.

In this tutorial we are going to use our recommended plugin, 
`@nomicfoundation/hardhat-toolbox`
, which has everything you need for developing smart contracts.

To install it, run this in your project directory:

```sh
npm install --save-dev @nomicfoundation/hardhat-toolbox
```
Add the highlighted line to your `hardhat.config.js` so that it looks like this:
```sh
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
};
```

# 4. Writing and compiling smart contracts
We're going to create a simple smart contract that implements a token that can be transferred. Token contracts are most frequently used to exchange or store value. We won't go in depth into the Solidity code of the contract on this tutorial, but there's some logic we implemented that you should know:

- There is a fixed total supply of tokens that can't be changed.
- The entire supply is assigned to the address that deploys the contract.
- Anyone can receive tokens.
- Anyone with at least one token can transfer tokens.
- The token is non-divisible. You can transfer 1, 2, 3 or 37 tokens but not 2.5.
>TIP
>
>You might have heard about ERC-20, which is a token standard in Ethereum. Tokens such as DAI and USDC implement the ERC-20 standard which allows them all to be compatible with any software that can deal with ERC-20 tokens. For the sake of simplicity, the token we're going to build does not implement the ERC-20 standard.

## Writing smart contracts
Start by creating a new directory called `contracts` and create a file inside the directory called `Token.sol`.

Paste the code below into the file and take a minute to read the code. It's simple and it's full of comments explaining the basics of Solidity.

>TIP
>
>To get syntax highlighting and editing assistance for Solidity in Visual Studio Code, try Hardhat for Visual Studio Code.

```sh
//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;


// This is the main building block for smart contracts.
contract Token {
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account's balance.
    mapping(address => uint256) balances;

    // The Transfer event helps off-chain applications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside*
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
```

## Compiling contracts
To compile the contract run `npx hardhat compile` in your terminal. The `compile` task is one of the built-in tasks.

```sh
$ npx hardhat compile
Compiling 1 file with 0.8.9
Compilation finished successfully
```
The contract has been successfully compiled and it's ready to be used.

# 5. Testing contracts
Writing automated tests when building smart contracts is of crucial importance, as your user's money is what's at stake.

To test our contract, we are going to use Hardhat Network, a local Ethereum network designed for development. It comes built-in with Hardhat, and it's used as the default network. You don't need to setup anything to use it.

In our tests we're going to use ethers.js to interact with the Ethereum contract we built in the previous section, and we'll use Mocha as our test runner.

## Writing tests
Create a new directory called `test` inside our project root directory and create a new file in there called `Token.js`.

Let's start with the code below. We'll explain it next, but for now paste this into `Token.js`:
```sh
const { expect } = require("chai");

describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("Token");

    const hardhatToken = await Token.deploy();

    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
  });
});
```
In your terminal run `npx hardhat test`. You should see the following output:
```sh
$ npx hardhat test

  Token contract
    ✓ Deployment should assign the total supply of tokens to the owner (654ms)


  1 passing (663ms)
```
This means the test passed. Let's now explain each line:
```sh
const [owner] = await ethers.getSigners();
```
A `Signe`r in ethers.js is an object that represents an Ethereum account. It's used to send transactions to contracts and other accounts. Here we're getting a list of the accounts in the node we're connected to, which in this case is Hardhat Network, and we're only keeping the first one.

The `ethers` variable is available in the global scope. If you like your code always being explicit, you can add this line at the top:
```sh
const { ethers } = require("hardhat");
```
> [Signers](https://docs.ethers.io/v5/api/signer/)
```sh
const Token = await ethers.getContractFactory("Token");
```
A `ContractFactory` in ethers.js is an abstraction used to deploy new smart contracts, so `Token` here is a factory for instances of our token contract.
```sh
const hardhatToken = await Token.deploy();
```
Calling `deploy()` on a `ContractFactory` will start the deployment, and return a `Promise` that resolves to a `Contract`. This is the object that has a method for each of your smart contract functions.

```sh
const ownerBalance = await hardhatToken.balanceOf(owner.address);
```
Once the contract is deployed, we can call our contract methods on `hardhatToken`. Here we get the balance of the owner account by calling the contract's `balanceOf()` method.

Recall that the account that deploys the token gets its entire supply. By default, `ContractFactory` and `Contract` instances are connected to the first signer. This means that the account in the `owner` variable executed the deployment, and `balanceOf()` should return the entire supply amount.

```sh
expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
```
Here we're again using our `Contract` instance to call a smart contract function in our Solidity code. `totalSupply`() returns the token's supply amount and we're checking that it's equal to `ownerBalance`, as it should be.

To do this we're using Chai which is a popular JavaScript assertion library. These asserting functions are called "matchers", and the ones we're using here come from the 
`@nomicfoundation/hardhat-chai-matchers`
 plugin, which extends Chai with many matchers useful to test smart contracts.

 ## Using a different account
If you need to test your code by sending a transaction from an account (or `Signer` in ethers.js terminology) other than the default one, you can use the `connect()` method on your ethers.js `Contract` object to connect it to a different account, like this:

```sh
const { expect } = require("chai");

describe("Token contract", function () {
  // ...previous test...

  it("Should transfer tokens between accounts", async function() {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("Token");

    const hardhatToken = await Token.deploy();

    // Transfer 50 tokens from owner to addr1
    await hardhatToken.transfer(addr1.address, 50);
    expect(await hardhatToken.balanceOf(addr1.address)).to.equal(50);

    // Transfer 50 tokens from addr1 to addr2
    await hardhatToken.connect(addr1).transfer(addr2.address, 50);
    expect(await hardhatToken.balanceOf(addr2.address)).to.equal(50);
  });
});
```

## Reusing common test setups with fixtures
The two tests that we wrote begin with their setup, which in this case means deploying the token contract. In more complex projects, this setup could involve multiple deployments and other transactions. Doing that in every test means a lot of code duplication. Plus, executing many transactions at the beginning of each test can make the test suite much slower.

You can avoid code duplication and improve the performance of your test suite by using fixtures. A fixture is a setup function that is run only the first time it's invoked. On subsequent invocations, instead of re-running it, Hardhat will reset the state of the network to what it was at the point after the fixture was initially executed.

```sh
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Token contract", function () {
  async function deployTokenFixture() {
    const Token = await ethers.getContractFactory("Token");
    const [owner, addr1, addr2] = await ethers.getSigners();

    const hardhatToken = await Token.deploy();

    await hardhatToken.deployed();

    // Fixtures can return anything you consider useful for your tests
    return { Token, hardhatToken, owner, addr1, addr2 };
  }

  it("Should assign the total supply of tokens to the owner", async function () {
    const { hardhatToken, owner } = await loadFixture(deployTokenFixture);

    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
  });

  it("Should transfer tokens between accounts", async function () {
    const { hardhatToken, owner, addr1, addr2 } = await loadFixture(
      deployTokenFixture
    );

    // Transfer 50 tokens from owner to addr1
    await expect(
      hardhatToken.transfer(addr1.address, 50)
    ).to.changeTokenBalances(hardhatToken, [owner, addr1], [-50, 50]);

    // Transfer 50 tokens from addr1 to addr2
    // We use .connect(signer) to send a transaction from another account
    await expect(
      hardhatToken.connect(addr1).transfer(addr2.address, 50)
    ).to.changeTokenBalances(hardhatToken, [addr1, addr2], [-50, 50]);
  });
});
```

Here we wrote a `deployTokenFixture` function that does the necessary setup and returns every value we use later in the tests. Then in each test, we use `loadFixture` to run the fixture and get those values. `loadFixture` will run the setup the first time, and quickly return to that state in the other tests.

## Full coverage
Now that we've covered the basics that you'll need for testing your contracts, here's a full test suite for the token with a lot of additional information about Mocha and how to structure your tests. We recommend reading it thoroughly.
```sh
// This is an example test file. Hardhat will run every *.js file in `test/`,
// so feel free to add new ones.

// Hardhat tests are normally written with Mocha and Chai.

// We import Chai to use its asserting functions here.
const { expect } = require("chai");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Networks snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

// `describe` is a Mocha function that allows you to organize your tests.
// Having your tests organized makes debugging them easier. All Mocha
// functions are available in the global scope.
//
// `describe` receives the name of a section of your test suite, and a
// callback. The callback must define the tests of that section. This callback
// cant be an async function.
describe("Token contract", function () {
  // We define a fixture to reuse the same setup in every test. We use
  // loadFixture to run this setup once, snapshot that state, and reset Hardhat
  // Network to that snapshopt in every test.
  async function deployTokenFixture() {
    // Get the ContractFactory and Signers here.
    const Token = await ethers.getContractFactory("Token");
    const [owner, addr1, addr2] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // its deployed() method, which happens onces its transaction has been
    // mined.
    const hardhatToken = await Token.deploy();

    await hardhatToken.deployed();

    // Fixtures can return anything you consider useful for your tests
    return { Token, hardhatToken, owner, addr1, addr2 };
  }

  // You can nest describe calls to create subsections.
  describe("Deployment", function () {
    // `it` is another Mocha function. This is the one you use to define each
    // of your tests. It receives the test name, and a callback function.
    //
    // If the callback function is async, Mocha will `await` it.
    it("Should set the right owner", async function () {
      // We use loadFixture to setup our environment, and then assert that
      // things went well
      const { hardhatToken, owner } = await loadFixture(deployTokenFixture);

      // `expect` receives a value and wraps it in an assertion object. These
      // objects have a lot of utility methods to assert values.

      // This test expects the owner variable stored in the contract to be
      // equal to our Signers owner.
      expect(await hardhatToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const { hardhatToken, owner } = await loadFixture(deployTokenFixture);
      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      const { hardhatToken, owner, addr1, addr2 } = await loadFixture(
        deployTokenFixture
      );
      // Transfer 50 tokens from owner to addr1
      await expect(
        hardhatToken.transfer(addr1.address, 50)
      ).to.changeTokenBalances(hardhatToken, [owner, addr1], [-50, 50]);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await expect(
        hardhatToken.connect(addr1).transfer(addr2.address, 50)
      ).to.changeTokenBalances(hardhatToken, [addr1, addr2], [-50, 50]);
    });

    it("should emit Transfer events", async function () {
      const { hardhatToken, owner, addr1, addr2 } = await loadFixture(
        deployTokenFixture
      );

      // Transfer 50 tokens from owner to addr1
      await expect(hardhatToken.transfer(addr1.address, 50))
        .to.emit(hardhatToken, "Transfer")
        .withArgs(owner.address, addr1.address, 50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await expect(hardhatToken.connect(addr1).transfer(addr2.address, 50))
        .to.emit(hardhatToken, "Transfer")
        .withArgs(addr1.address, addr2.address, 50);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const { hardhatToken, owner, addr1 } = await loadFixture(
        deployTokenFixture
      );
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      // Try to send 1 token from addr1 (0 tokens) to owner (1000 tokens).
      // `require` will evaluate false and revert the transaction.
      await expect(
        hardhatToken.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("Not enough tokens");

      // Owner balance shouldnt have changed.
      expect(await hardhatToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });
  });
});
```
This is what the output of `npx hardhat test` should look like against the full test suite:

```sh
$ npx hardhat test

  Token contract
    Deployment
      ✓ Should set the right owner
      ✓ Should assign the total supply of tokens to the owner
    Transactions
      ✓ Should transfer tokens between accounts (199ms)
      ✓ Should fail if sender doesn’t have enough tokens
      ✓ Should update balances after transfers (111ms)


  5 passing (1s)
```
Keep in mind that when you run `npx hardhat test`, your contracts will be automatically compiled if they've changed since the last time you ran your tests.

# 6. Debugging with Hardhat Network
Hardhat comes built-in with Hardhat Network, a local Ethereum network designed for development. It allows you to deploy your contracts, run your tests and debug your code, all within the confines of your local machine. It's the default network Hardhat that connects to, so you don't need to set up anything for it to work. Just run your tests.

## Solidity `console.log`
When running your contracts and tests on Hardhat Network you can print logging messages and contract variables calling `console.log()` from your Solidity code. To use it you have to import `hardhat/console.sol` in your contract code.

This is what it looks like:
```sh
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Token {
  //...
}
```

Then you can just add some `console.log` calls to the `transfer()` function as if you were using it in JavaScript:

```sh
function transfer(address to, uint256 amount) external {
    require(balances[msg.sender] >= amount, "Not enough tokens");

    console.log(
        "Transferring from %s to %s %s tokens",
        msg.sender,
        to,
        amount
    );

    balances[msg.sender] -= amount;
    balances[to] += amount;

    emit Transfer(msg.sender, to, amount);
}
```
The logging output will show when you run your tests:
```sh
$ npx hardhat test

  Token contract
    Deployment
      ✓ Should set the right owner
      ✓ Should assign the total supply of tokens to the owner
    Transactions
Transferring from 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 to 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 50 tokens
Transferring from 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 to 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc 50 tokens
      ✓ Should transfer tokens between accounts (373ms)
      ✓ Should fail if sender doesn’t have enough tokens
Transferring from 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 to 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 50 tokens
Transferring from 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 to 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc 50 tokens
      ✓ Should update balances after transfers (187ms)


  5 passing (2s)
```

# 7. Deploying to a live network
Once you're ready to share your dApp with other people, you may want to deploy it to a live network. This way others can access an instance that's not running locally on your system.

The "mainnet" Ethereum network deals with real money, but there are separate "testnet" networks that do not. These testnets provide shared staging environments that do a good job of mimicking the real world scenario without putting real money at stake, and Ethereum has several, like Goerli and Sepolia. We recommend you deploy your contracts to the Goerli testnet.

At the software level, deploying to a testnet is the same as deploying to mainnet. The only difference is which network you connect to. Let's look into what the code to deploy your contracts using ethers.js would look like.

The main concepts used are `Signer`, `ContractFactory` and `Contract` which we explained back in the testing section. There's nothing new that needs to be done when compared to testing, given that when you're testing your contracts you're actually making a deployment to your development network. This makes the code very similar, or even the same.

Let's create a new directory `scripts` inside the project root's directory, and paste the following into a `deploy.js` file in that directory:

```sh
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy();

  console.log("Token address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```
To tell Hardhat to connect to a specific Ethereum network, you can use the `--network` parameter when running any task, like this:
```sh
npx hardhat run scripts/deploy.js --network <network-name>
```
With our current configuration, running it without the `--network` parameter would cause the code to run against an embedded instance of Hardhat Network. In this scenario, the deployment actually gets lost when Hardhat finishes running, but it's still useful to test that our deployment code works:
```sh
$ npx hardhat run scripts/deploy.js --network rinkeby

Deploying contracts with the account: 
0x7e28fF8aA2962DA45212711C6679E7a3FA24482D
Account balance: 2000000000000000000
Token address: 0x3265da402CAf1f082c7e9166b5908C82A9e6A613
```

## Deploying to remote networks
To deploy to a remote network such as mainnet or any testnet, you need to add a network entry to your `hardhat.config.js` file. We’ll use Goerli for this example, but you can add any network similarly:
```sh
require("@nomicfoundation/hardhat-toolbox");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "KEY";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY = "YOUR GOERLI PRIVATE KEY";

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};
```

We're using Alchemy, but pointing `url` to any Ethereum node or gateway would work. Go grab your `ALCHEMY_API_KEY` and come back.

To deploy on Goerli you need to send some Goerli ether to the address that's going to be making the deployment. You can get testnet ether from a faucet, a service that distributes testing-ETH for free. Here are some for Goerli:

- Chainlink faucet
- Alchemy Goerli Faucet

You'll have to change Metamask's network to Goerli before transacting.

>TIP
>
>You can learn more about other testnets and find links to their faucets on the ethereum.org site.

Finally, run:
```sh
npx hardhat run scripts/deploy.js --network goerl
```
If everything went well, you should see the deployed contract address.

# Hardhat Boilerplate Project
If you want to get started with your dApp quickly or see what this whole project looks like with a frontend, you can use our boilerplate repo.

## What's included
- The Solidity contract we used in this tutorial
- Tests for the entire functionality of the contract
- A minimal React front-end to interact with the contract using ethers.js
### Solidity contract & tests
In the root of the repo you'll find the Hardhat project we put together through this tutorial with the `sToken` contract. To refresh your memory on what it implements:

- There is a fixed total supply of tokens that can't be changed.
- The entire supply is assigned to the address that deploys the contract.
- Anyone can receive tokens.
- Anyone with at least one token can transfer tokens.
- The token is non-divisible. You can transfer 1, 2, 3 or 37 tokens but not 2.5.

## Frontend app
In `frontend` you'll find a simple app that allows the user to do two things:

- Check the connected wallet's balance
- Send tokens to an address

It's a separate npm project and it was created using create-react-app, so this means that it uses webpack and babel.

## Frontend file architecture
- `src/` contains all the code
  - `src/components` contains the react components
    - `Dapp.js` is the only file with business logic. This is where you'd replace the code with your own if you were to use this as boilerplate
    - Every other component just renders HTML, no logic.
    - `src/contracts` has the ABI and address of the contract and these are automatically generated by the deployment script

##  How to use it
First clone the repository, and then prepare for the contract deployment:
```sh
cd hardhat-boilerplate
npm install
npx hardhat node
```
Here we just install the npm project's dependencies, and by running `npx hardhat node` we spin up an instance of Hardhat Network that you can connect to using MetaMask. In a different terminal in the same directory, run:
```sh
npx hardhat --network localhost run scripts/deploy.js
```
This will deploy the contract to Hardhat Network. After this completes, start the react web app:
```sh
cd frontend
npm install
npm run start
```


[boilerplate-project](https://hardhat.org/tutorial/boilerplate-project)