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