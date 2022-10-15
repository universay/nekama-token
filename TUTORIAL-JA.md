# Hardhat's tutorial for beginners
EthereumコントラクトとdApp開発への初心者ガイドへようこそ。このチュートリアルは、ゼロから何かを構築するためのセットアップを迅速に行うことを目的としています。

このプロセスを組織化するために、Ethereum上での構築を容易にする開発環境であるHardhatを使用するつもりです。これは、スマートコントラクトやdAppを構築するプロセスに内在する反復タスクを開発者が管理・自動化するのに役立ち、このワークフローを中心にさらなる機能を容易に導入することができます。これは、まさに中核となるコンパイルとテストを意味します。

Hardhatには、開発用に設計されたローカルなEthereumネットワークであるHardhat Networkも組み込まれています。これにより、コントラクトをデプロイし、テストを実行し、コードをデバッグすることができます。

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

もし、上記のどれかができないなら、リンクをたどって、時間をかけて基本を学んでください。

# 2. Setting up the environment
ほとんどのEthereumのライブラリやツールはJavaScriptで書かれており、Hardhatもそうです。Node.jsに馴染みがなければ、それはChromeのV8 JavaScriptエンジン上に構築されたJavaScriptランタイムです。これは、ウェブブラウザの外でJavaScriptを実行するための最も一般的なソリューションであり、Hardhatはその上に構築されています。

> TIP
>
> [Hardhat for Visual Studio Code](https://hardhat.org/hardhat-vscode/docs/overview)は、VSCodeにSolidityの高度なサポートを追加するHardhatの公式エクステンションです。Visual Studio Code を使用している方は、ぜひお試しください。

# Installing Node.js
すでにNode.js `>=16.0` が動作している場合は、このセクションはスキップできます。そうでない場合は、Ubuntu、MacOS、Windowsにインストールする方法を説明します。

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
Node.jsパッケージマネージャ（npm）を使ってHardhatをインストールします。npmはパッケージマネージャであると同時に、JavaScriptコードのオンラインリポジトリでもあります。

Node.jsでは他のパッケージマネージャも使用できますが、このガイドに従うにはnpm 7以降を使用することをお勧めします。前のセクションの手順に従った場合は、すでに入手しているはずです。

新しいターミナルを開き、以下のコマンドを実行して、新しいフォルダーを作成します。

```sh
mkdir hardhat-tutorial
cd hardhat-tutorial
```

次に、下図のようにnpmプロジェクトを初期化します。いくつかの質問に答えるように促されます。

>TIP
>
> snippetsのタブを使用して、お好みのパッケージマネージャを選択してください。Hardhatの依存関係をより簡単にインストールできるため、npm 7以降を使用することをお勧めします。

```sh
npm init
```
Now we can install Hardhat:
```sh
npm install --save-dev hardhat
```
Hardhatをインストールしたのと同じディレクトリで実行します。
```sh
npx hardhat
```
キーボードで `Create an empty hardhat.config.js` を選択し、Enterキーを押します。

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
Hardhat が実行されると、現在の作業ディレクトリから最も近い `hardhat.config.js` ファイルを探します。このファイルは通常プロジェクトのルートにあり、Hardhat が動作するためには `hardhat.config.js` を空にすれば十分です。あなたのセットアップの全ては、このファイルに含まれています。

## Hardhat's architecture
Hardhat は、タスクとプラグインというコンセプトで設計されています。Hardhatの機能の大部分はプラグインによるもので、使いたい[plugins](https://hardhat.org/hardhat-runner/plugins)を自由に選択することができます。

### Tasks
Hardhat をコマンドラインから実行するときはいつも、タスクを実行していることになります。例えば、`npx hardhat compile` は `compile` タスクを実行しています。あなたのプロジェクトで現在利用可能なタスクを見るには、 `npx hardhat` を実行してください。npx hardhat help [task]`を実行することで、どのタスクも自由に調べることができます。

```sh
GLOBAL OPTIONS:

  --config              Hardhatの設定ファイルです。
  --emoji               メッセージに絵文字を使用します。
  --help                このメッセージ、またはタスク名が提供されている場合はタスクのヘルプを表示します。
  --max-memory          Hardhatが使用できる最大メモリ量です。
  --network             接続するネットワーク。
  --show-stack-traces   スタックトレースを表示します。
  --tsconfig            TypeScriptの設定ファイルです。
  --verbose             Hardhatの詳細なロギングを有効にします。
  --version             Hardhatのバージョンを表示します。

AVAILABLE TASKS:

  check                 必要なものをチェックする。
  clean                 キャッシュをクリアし、すべてのアーティファクトを削除します。
  compile               プロジェクト全体をコンパイルし、全てのアーティファクトをビルドします。
  console               hardhatのコンソールを開きます。
  coverage              テストのコードカバレッジレポートを生成します。
  flatten               コントラクトとその依存関係を平坦化して出力します。
  gas-reporter:merge
  help                  このメッセージを出力します。
  node                  Hardhat Network 上で JSON-RPC サーバーを開始します。
  run                   プロジェクトをコンパイルした後に、ユーザー定義のスクリプトを実行します。
  test                  mochaのテストを実行します
  typechain             コンパイルしたコントラクトに対して Typechain の型付けを生成する
  verify                Etherscan上でコントラクトを検証します
```

>TIP
>
>タスクは自分で作成することができます。[Creating a task](https://hardhat.org/hardhat-runner/docs/advanced/create-task)をご覧ください。

### Plugins
Hardhat、最終的にどのようなツールを使うかという点では独創的ですが、いくつかのデフォルトが組み込まれています。これらはすべて上書きすることができます。ほとんどの場合、あるツールを使用するには、そのツールをHardhatに統合するプラグインを使用することになります。

このチュートリアルでは、スマートコントラクトの開発に必要なものがすべて揃っている、私たちの推奨プラグイン `@nomicfoundation/hardhat-toolbox` を使用する予定です。[hardhat-toolbox](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-toolbox)

インストールするには、プロジェクトディレクトリでこれを実行してください。

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
転送可能なトークンを実装した、シンプルなスマートコントラクトを作成します。トークン契約は、価値の交換や保存に最も頻繁に使用されます。このチュートリアルでは、コントラクトの Solidity コードに深く立ち入ることはしませんが、私たちが実装したロジックには知っておくべきものがいくつかあります。

- トークンの総供給量は固定されており、変更することはできません。
- 契約を展開するアドレスに全供給量を割り当てる。
- 誰でもトークンを受け取ることができます。
- トークンを1つ以上持っている人なら、誰でもトークンを譲渡することができます。
- トークンは分割できません。1、2、3、37個のトークンを譲渡することができますが、2.5個は譲渡できません。
>TIP
>
>ERC-20という、イーサリアムのトークン規格をご存じでしょうか。DAIやUSDCなどのトークンはERC-20規格を実装しているため、ERC-20トークンを扱えるソフトウェアであればすべて互換性を持つことができます。簡単のために、私たちが作ろうとしているトークンはERC-20規格を実装していません。

## Writing smart contracts
まず、`contracts` という名前の新しいディレクトリを作り、その中に `Token.sol` という名前のファイルを作成します。

下のコードをファイルに貼り付けて、少し時間をおいて読んでみてください。シンプルで、Solidity の基本を説明するコメントでいっぱいです。

>TIP
>
>Visual Studio Code で Solidity の構文強調表示と編集支援を行うには、Hardhat for Visual Studio Code をお試しください。

```js
//SPDX-License-Identifier: UNLICENSED

// Solidity ファイルはこのプラグマで開始する必要があります。
// これは、Solidity コンパイラがそのバージョンを検証するために使用されます。
pragma solidity ^0.8.9;


// これは、スマートコントラクトの主要な構成要素である。
contract Token {
    // トークンを識別するためのいくつかの文字列型変数。
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // 符号なし整数型変数に格納される、トークンの固定量。
    uint256 public totalSupply = 1000000;

    // アドレス型変数は、イーサリアムのアカウントを格納するために使用されます。
    address public owner;

    // マッピングとは、キー/バリューのマップのことです。ここでは、各口座の残高を格納しています。
    mapping(address => uint256) balances;

    // Transferイベントは、オフチェーンアプリケーションが以下を理解するのに役立ちます。
    // あなたの契約内で起こること
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    constructor() {
        // TotalSupply は、トランザクション送信者（コントラクトを展開するアカウント）に割り当てられる。
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * トークンを転送するための機能です。
     *
     * `external` 修飾子は、コントラクトの *外から* *のみ* 関数を呼び出すことができるようにします。
     */
    function transfer(address to, uint256 amount) external {
        // トランザクションの送信者が十分なトークンを持っているかどうかを確認します。
        // もし `require` の最初の引数が `false` と評価された場合、トランザクションは元に戻されます。
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // 金額を振り込む。
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // オフチェーンアプリケーションに転送を通知する。
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * 指定した口座のトークン残高を取得する読み取り専用関数です。
     *
     * `view` 修飾子はコントラクトの状態を変更しないことを示し、
     * これによりトランザクションを実行せずに呼び出すことができます。
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
```

## Compiling contracts
契約書をコンパイルするには、ターミナルで `npx hardhat compile` を実行してください。コンパイルタスクはビルトインタスクの1つです。

```sh
$ npx hardhat compile
Compiling 1 file with 0.8.9
Compilation finished successfully
```
The contract has been successfully compiled and it's ready to be used.

# 5. Testing contracts
スマートコントラクトを構築する際に自動化されたテストを書くことは、ユーザーのお金がかかっているため、極めて重要なことです。

私たちのコントラクトをテストするために、開発用に設計されたローカルなEthereumネットワークであるHardhat Networkを使用するつもりです。これは Hardhat に内蔵されており、デフォルトのネットワークとして使用されます。これを使用するために何かを設定する必要はありません。

テストでは、前のセクションで構築した Ethereum コントラクトと対話するために ethers.js を使用し、テストランナーとして Mocha を使用する予定です。

## Writing tests
プロジェクトのルートディレクトリ内に `test` という新しいディレクトリを作成し、その中に `Token.js` という新しいファイルを作成します。

まずは、以下のコードから始めましょう。次に説明しますが、とりあえず、これを `Token.js` に貼り付けてください。

```js
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

ターミナルで `npx hardhat test` を実行します。以下のような出力が表示されるはずです。
```sh
$ npx hardhat test

  Token contract
    ✓ Deployment should assign the total supply of tokens to the owner (654ms)


  1 passing (663ms)
```

This means the test passed. Let's now explain each line:

```js
const [owner] = await ethers.getSigners();
```

ethers.jsにおける`Signe`rは、Ethereumのアカウントを表すオブジェクトです。コントラクトや他のアカウントにトランザクションを送信するために使用されます。ここでは、接続しているノード（この場合は Hardhat Network）のアカウント一覧を取得し、最初のものだけを保持しています。

変数 `ethers` はグローバルスコープで利用可能です。もし、コードが常に明示的であることが好きなら、この行を一番上に追加することができます。

```js
const { ethers } = require("hardhat");
```
> [Signers](https://docs.ethers.io/v5/api/signer/)

```js
const Token = await ethers.getContractFactory("Token");
```
ethers.jsの `ContractFactory` は新しいスマートコントラクトをデプロイするために使用される抽象化であり、ここでの `Token` は私たちのトークンコントラクトのインスタンスのための工場です。
```js
const hardhatToken = await Token.deploy();
```
`ContractFactory` に対して `deploy()` を呼び出すとデプロイが開始され、`Contract` に解決する `Promise` が返されます。これは、スマートコントラクトの各機能に対応したメソッドを持つオブジェクトです。

```js
const ownerBalance = await hardhatToken.balanceOf(owner.address);
```
コントラクトがデプロイされると、`hardhatToken` に対してコントラクトメソッドを呼び出すことができます。ここでは、コントラクトの `balanceOf()` メソッドを呼び出して、オーナーアカウントの残高を取得します。

トークンをデプロイしたアカウントは、その全供給量を取得することを思い出してください。デフォルトでは、 `ContractFactory` と `Contract` のインスタンスは最初の署名者に接続されています。つまり、変数 `owner` にあるアカウントがデプロイを実行し、 `balanceOf()` が供給量全体を返すはずです。

```js
expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
```
ここで再び `Contract` インスタンスを使用して Solidity コード内のスマートコントラクト関数を呼び出しています。totalSupply`() はトークンの供給量を返し、それが `ownerBalance` と等しいかどうかをチェックしています。

これを行うために、人気のある JavaScript のアサーションライブラリである Chai を使用しています。これらのアサーション関数は "matcher "と呼ばれ、ここで使用しているのは  `@nomicfoundation/hardhat-chai-matchers` プラグインです。
 このプラグインはChaiを拡張し、スマートコントラクトのテストに役立つ多くのmatcherを備えています。

 ## Using a different account
もし、デフォルト以外のアカウント(ethers.jsの用語では `Signer` )からトランザクションを送信してコードをテストする必要がある場合、以下のようにethers.jsの `Contract` オブジェクトの `connect()` メソッドを使用して異なるアカウントに接続することが可能です。

```js
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
私たちが書いたふたつのテストは、まずそのセットアップから始まります。この場合、トークンコントラクトをデプロイすることを意味します。より複雑なプロジェクトでは、このセットアップに複数のデプロイや他のトランザクションが含まれる可能性があります。それをすべてのテストで行うことは、多くのコードの重複を意味します。さらに、各テストの最初に多くのトランザクションを実行すると、テストスイートがかなり遅くなります。

フィクスチャを使用することで、コードの重複を避け、テストスイートのパフォーマンスを向上させることができます。フィクスチャとは、最初に呼び出されたときだけ実行される設定関数のことです。それ以降の起動では、再実行する代わりに、Hardhat はネットワークの状態を、フィクスチャが最初に実行された後の時点の状態にリセットします。

```js
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Token contract", function () {
  async function deployTokenFixture() {
    const Token = await ethers.getContractFactory("Token");
    const [owner, addr1, addr2] = await ethers.getSigners();

    const hardhatToken = await Token.deploy();

    await hardhatToken.deployed();

    // Fixturesは、テストに役立つと思われるものなら何でも返すことができます。
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

ここでは `deployTokenFixture` 関数を書いて、必要な設定を行い、後でテストで使用するすべての値を返します。そして各テストで、 `loadFixture` を使ってフィクスチャを実行し、それらの値を取得します。loadFixture` は初回にセットアップを実行し、他のテストではすぐにその状態に戻ります。

## Full coverage
さて、コントラクトのテストに必要な基本を説明しましたが、ここではトークンの完全なテストスイートを、Mocha とテストの構成方法に関する多くの追加情報とともに紹介します。熟読されることをお勧めします。

```js
// これはテストファイルの例です。
// Hardhat は `test/` にあるすべての *.js ファイルを実行するので、新しいファイルを自由に追加してください。

// Hardhatのテストは通常MochaとChaiで書かれています。

// ここではChaiをインポートして、そのアサーション機能を利用する。
const { expect } = require("chai");

// テスト間で共通のセットアップ (あるいはフィクスチャ) を共有するために、`loadFixture` を使用します。
// これを使用すると、Hardhat Networks のスナップショット機能を利用して、テストを簡素化し、より速く実行することができます。
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

// `describe` は Mocha の関数で、テストを整理するためのものです。
// テストを整理することで、デバッグが容易になります。
// Mocha のすべての関数はグローバルスコープで利用できます。
//
// `describe` は、テストスイートのセクションの名前と コールバックを受け取ります。
// コールバックは、そのセクションのテストを定義しなければなりません。
// このコールバックは非同期関数にすることはできません。
describe("Token contract", function () {
  // 毎回のテストで同じ設定を再利用するために、Fixtureを定義します。 
  // loadFixture を使って、このセットアップを一度実行し、その状態をスナップショットし、
  // すべてのテストで Hardhat Network をそのスナップショットにリセットしています。
  async function deployTokenFixture() {
    // ContractFactoryとSignersはこちらから入手してください。
    const Token = await ethers.getContractFactory("Token");
    const [owner, addr1, addr2] = await ethers.getSigners();

    // コントラクトをデプロイするには、Token.deploy()を呼び出し、
    // そのトランザクションが採掘された時点で発生するdeployed()メソッドを待機すればよい。

    const hardhatToken = await Token.deploy();

    await hardhatToken.deployed();

    // Fixtureは、テストに役立つと思われるものなら何でも返すことができます。
    return { Token, hardhatToken, owner, addr1, addr2 };
  }

  // 記述呼び出しをネストしてサブセクションを作成することができます。
  describe("Deployment", function () {
    // `it` はもうひとつの Mocha 関数です。これは各テストを定義するために使用します。
    // テストの名前とコールバック関数を受け取ります。
    //
    // コールバック関数が非同期の場合、Mocha はコールバック関数を `await` します。
    it("Should set the right owner", async function () {
      // loadFixture を使って環境をセットアップし、うまくいったことを表明します。

      const { hardhatToken, owner } = await loadFixture(deployTokenFixture);

      // `expect` は値を受け取り、それをアサーションオブジェクトにラップします。 
      // これらのオブジェクトは、値をアサートするための多くのユーティリティメソッドを持っています。

      // このテストでは、コントラクトに格納されているowner変数がSignersのownerと同じであることを期待します。
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
      // 他のアカウントからトランザクションを送信するために、.connect(signer)を使用します。
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
      // 他のアカウントからトランザクションを送信するために、.connect(signer)を使用します。
      await expect(hardhatToken.connect(addr1).transfer(addr2.address, 50))
        .to.emit(hardhatToken, "Transfer")
        .withArgs(addr1.address, addr2.address, 50);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const { hardhatToken, owner, addr1 } = await loadFixture(
        deployTokenFixture
      );
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      // addr1（0トークン）からowner（1000トークン）へ1トークンを送信してみる。
      // `require` は false と評価され、トランザクションを元に戻します。
      await expect(
        hardhatToken.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("Not enough tokens");

      // オーナーズバランスが変わってはいけない。
      expect(await hardhatToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });
  });
});
```
これは、完全なテストスイートに対して `npx hardhat test` の出力がどのように見えるかを示しています。

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
`npx hardhat test` を実行するとき、コントラクトが最後にテストを実行したときから変更されていれば、自動的にコンパイルされることを覚えておいてください。

# 6. Debugging with Hardhat Network
Hardhatには、開発用に設計されたローカルなEthereumネットワークであるHardhat Networkが内蔵されています。これにより、コントラクトのデプロイ、テストの実行、コードのデバッグを、すべてローカルマシンの範囲内で行うことができます。Hardhat が接続するのはデフォルトのネットワークなので、動作させるために何かを設定する必要はありません。テストを実行するだけです。

## Solidity `console.log`
Hardhat Network 上でコントラクトとテストを実行するとき、Solidity コードから `console.log()` を呼び出して、ロギングメッセージとコントラクト変数を表示することができます。これを使用するには、コントラクトコードの中で `hardhat/console.sol` をインポートする必要があります。

This is what it looks like:

```sh
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Token {
  //...
}
```

そして、JavaScript で使っているかのように、 `transfer()` 関数に `console.log` の呼び出しをいくつか追加するだけでよいのです。

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

ログの出力は、テストを実行したときに表示されます。

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
dAppを他の人と共有する準備ができたら、それをライブネットワークにデプロイしたいと思うかもしれません。こうすることで、他の人はあなたのシステム上でローカルに実行されていないインスタンスにアクセスすることができます。

「メインネット」イーサリアムネットワークは実際のお金を扱いますが、そうでない別の「テストネット」ネットワークがあります。これらのテストネットは、実際のお金を危険にさらすことなく、現実世界のシナリオを模倣するのに適した共有ステージング環境を提供し、EthereumにはGoerliやSepoliaのようないくつかのネットワークがあります。私たちは、コントラクトをGoerliテストネットにデプロイすることをお勧めします。

ソフトウェアレベルでは、テストネットへのデプロイは、メインネットへのデプロイと同じです。唯一の違いは、どのネットワークに接続するかということです。ethers.jsを使用してコントラクトをデプロイするコードがどのようなものか見てみましょう。

使用する主な概念は、テストのセクションで説明した `Signer`、`ContractFactory`、`Contract` です。コントラクトをテストするときは、実際に開発ネットワークにデプロイすることになるので、テストと比較して新しいことをする必要はありません。このため、コードは非常に似ている、あるいは同じになります。

プロジェクトのルートディレクトリ内に新しいディレクトリ `scripts` を作成し、そのディレクトリ内の `deploy.js` ファイルに次のコードを貼り付けてみましょう。

```js
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

Hardhatに特定のEthereumネットワークに接続するよう指示するには、任意のタスクを実行する際に、以下のように `--network` パラメータを使用します。

```sh
npx hardhat run scripts/deploy.js --network <network-name>
```

現在の設定では、`--network` パラメータを付けずに実行すると、Hardhat Network の組み込みインスタンスに対してコードが実行されることになります。このシナリオでは、Hardhat の実行が終了すると、デプロイは実際に失われますが、デプロイメントコードが動作することをテストするのに便利です。

```sh
$ npx hardhat run scripts/deploy.js --network rinkeby

Deploying contracts with the account: 
0x7e28fF8aA2962DA45212711C6679E7a3FA24482D
Account balance: 2000000000000000000
Token address: 0x3265da402CAf1f082c7e9166b5908C82A9e6A613
```

## Deploying to remote networks
メインネットやテストネットなどのリモートネットワークにデプロイするには、 `hardhat.config.js` ファイルにネットワークのエントリを追加する必要があります。この例では Goerli を使用しますが、同様に任意のネットワークを追加することができます。


```js
require("@nomicfoundation/hardhat-toolbox");

// https://www.alchemyapi.io にアクセスし、サインアップして、そのダッシュボードで新しいAppを作成し、「KEY」をそのキーに置き換えます
// const ALCHEMY_API_KEY = "KEY "とする。

// この秘密鍵をGoerliアカウントの秘密鍵に置き換えます。
// Metamaskから秘密鍵をエクスポートするには、Metamaskを起動し
// go to Account Details > Export Private Key
// ご注意ください。テスト用アカウントに本物のEtherを絶対に入れないでください。

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

ここではAlchemyを使用していますが、`url`を任意のEthereumノードやゲートウェイに向けることも可能です。ALCHEMY_API_KEY` を取得し、戻ってきてください。

Goerli にデプロイするには、デプロイを行うアドレスに Goerli ether を送る必要があります。テストネットエーテルは、testing-ETH を無料で配布しているサービスである faucet から入手することができます。Goerli 用のものはこちらです。

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
もしあなたがdAppをすぐに始めたい、またはこのプロジェクト全体がフロントエンドでどのように見えるかを見たい場合は、私たちのボイラープレート・レポを使うことができます。

## What's included
- The Solidity contract we used in this tutorial
- Tests for the entire functionality of the contract
- A minimal React front-end to interact with the contract using ethers.js
### Solidity contract & tests
レポのルートには、このチュートリアルで作成した `sToken` コントラクトを持つ Hardhat プロジェクトがあります。このプロジェクトが実装しているものについて、記憶を呼び覚ましてください。

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
まずリポジトリをクローンし、コントラクトデプロイメントの準備をします。
```sh
cd hardhat-boilerplate
npm install
npx hardhat node
```
ここでは、npmプロジェクトの依存関係をインストールし、`npx hardhat node`を実行することで、MetaMaskを使って接続できるHardhat Networkのインスタンスをスピンアップさせるだけです。同じディレクトリの別の端末で、以下を実行します。
```sh
npx hardhat --network localhost run scripts/deploy.js
```
これで、Hardhat Networkにコントラクトがデプロイされます。これが完了したら、reactのWebアプリを起動します。
```sh
cd frontend
npm install
npm run start
```


[boilerplate-project](https://hardhat.org/tutorial/boilerplate-project)