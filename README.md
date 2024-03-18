# Whitelisting
Whitelist an user on chain. This uses both Direct Whitelisting and Referral Whitelisting of the users. 

## About the contract:
This Solidity contract, named `Whitelist`, is designed to manage a whitelist of users, allowing for two types of whitelisting: direct whitelisting by an admin and referral whitelisting by an already whitelisted user. The contract includes various functionalities to manage the whitelist, such as updating the admin, whitelisting users directly, whitelisting users through referrals, and managing referral cooldowns. Let's break down the contract's components and functionalities in detail:

### State Variables

- **owner**: The address that deployed the contract. This address has special privileges, such as updating the admin.
- **admin**: The address that has administrative privileges, such as directly whitelisting users.
- **whitelists**: A mapping that stores the whitelist status and referrer for each address.
- **counter**: A counter to keep track of the total number of whitelisted users.
- **referralCooldown**: The time (in seconds) a referrer must wait before they can whitelist another user through referrals.
- **referrerTimeStamp**: A mapping that stores the timestamp of the last referral made by each address.

### Modifiers

- **ownerOnly**: Ensures that only the owner of the contract can execute the function.
- **adminOnly**: Ensures that only the admin of the contract can execute the function.
- **whitelistedOnly**: Ensures that only whitelisted users can execute the function.

### Constructor

The constructor sets the `owner` of the contract to the address that deployed it.

### Functions

- **updateAdmin**: Allows the owner to update the admin address.
- **getAdminAddress**: Returns the current admin address.
- **directWhitelist**: Allows the admin to directly whitelist an address. It updates the whitelist status and increments or decrements the counter based on the new status.
- **referWhitelist**: Allows a whitelisted user to whitelist another address through referrals. It checks if the referrer is not on cooldown and updates the whitelist status, referrer, and counter.
- **updateReferralCooldown**: Allows the admin to update the referral cooldown time.
- **getOwner**: Returns the owner address.
- **getWhitelist**: Returns the whitelist data for a given address.
- **getWhitelistCount**: Returns the total number of whitelisted users.
- **getCooldownTime**: Returns the current referral cooldown time.

### Events

- **DirectlyWhitelisted**: Emitted when an address is directly whitelisted.
- **ReferredWhitelisted**: Emitted when an address is whitelisted through referrals.

### Key Features

- **Access Control**: The contract uses modifiers to restrict access to certain functions to the owner, admin, or whitelisted users.
- **Whitelist Management**: It allows for both direct and referral-based whitelisting, with mechanisms to prevent abuse, such as referral cooldowns.
- **Counter and Referral Timestamps**: Keeps track of the total number of whitelisted users and the last referral timestamp for each referrer to manage referral cooldowns.

This contract is a comprehensive solution for managing a whitelist with both direct and referral-based whitelisting functionalities, including access control and referral cooldowns to prevent abuse.

## About the test cases:

The provided test suite for the `Whitelist` contract is designed to test various functionalities and behaviors of the contract. It uses the Chai assertion library for testing and is structured into several sections, each focusing on a different aspect of the contract's functionality. Let's break down the test cases based on the contract's features and the test suite's structure:

### Setup

Before each test, the contract is deployed, and the owner and several addresses (`addr1`, `addr2`, `addr3`, `addr4`) are set up. This setup ensures that each test starts with a fresh instance of the contract and a known state.

### Deployment

- **Should set the right owner**: This test checks that the contract's owner is correctly set to the address that deployed the contract. It uses the `getOwner` function to verify this.
- **Should initialize the counter to 0**: This test ensures that the counter, which tracks the number of whitelisted users, is initialized to 0 upon deployment.

### Admin Functions

- **Should update admin address**: Tests that the owner can successfully update the admin address to `addr1`. It uses the `updateAdmin` function and verifies the change with `getAdminAddress`.
- **Should not allow non-owner to update admin**: This test checks that only the owner can update the admin address. It attempts to update the admin from `addr1` and expects the transaction to revert with an appropriate error message.
- **Should update referral cooldown**: After setting `addr1` as the admin, this test updates the referral cooldown to 60 seconds and verifies the change with `getCooldownTime`.
- **Should not allow non-admin to update referral cooldown**: This test ensures that only the admin can update the referral cooldown. It attempts to update the cooldown from `addr1` and expects the transaction to revert.

### Whitelist Functions

- **Should allow admin to directly whitelist an address**: This test verifies that the admin can directly whitelist an address (`addr2`) and checks the whitelist status of `addr2` to ensure it's true.
- **Should not allow non-whitelisted user to refer**: This test checks that a non-whitelisted user (`addr2`) cannot refer another user (`addr3`) to the whitelist. It expects the transaction to revert with an error message.
- **Should allow whitelisted user to refer another user**: After whitelisting `addr2`, this test allows `addr2` to refer `addr3` to the whitelist. It verifies that `addr3` is now whitelisted and that `addr2` is recorded as the referrer.
- **Should not allow referral if referrer is on cooldown**: This test ensures that a referrer cannot refer another user if they are still on cooldown. After `addr2` has referred `addr3`, it attempts to refer `addr4` again and expects the transaction to revert with a cooldown error message.

These test cases cover the core functionalities of the `Whitelist` contract, including deployment, admin management, and whitelist operations. They ensure that the contract behaves as expected under various conditions, such as updating the admin, managing referral cooldowns, and handling direct and referral whitelisting.

## How to run:

To run the Hardhat contract and tests for the `Whitelist` contract, you'll need to follow these steps. This guide assumes you have Node.js and npm installed on your system, and you're familiar with using the command line.

### Step 1: Install Hardhat

If you haven't already, you'll need to install Hardhat. Open your terminal and run:

```bash
npm install --save-dev hardhat
```

### Step 2: Initialize a Hardhat Project

Navigate to your project directory in the terminal and run:

```bash
npx hardhat
```

Follow the prompts to create a new Hardhat project. For the purpose of this guide, you can select the default options.

### Step 3: Install Required Dependencies

Your project will need the `chai` library for assertions and `ethers` for interacting with Ethereum. Install them by running:

```bash
npm install --save-dev chai ethers
```

### Step 4: Create Your Contract

Place your `Whitelist.sol` contract in the `contracts` directory of your Hardhat project. If the `contracts` directory doesn't exist, create it.

### Step 5: Write Your Tests

Place your `Whitelist.js` test file in the `test` directory of your Hardhat project. If the `test` directory doesn't exist, create it.

### Step 6: Configure Hardhat

Open the `hardhat.config.js` file in your project's root directory. You might need to configure the network settings, such as the network URL and private key for deployment. For local testing, you can use Hardhat's default network.

### Step 7: Compile Your Contract

Before running tests, you need to compile your contract. In your terminal, run:

```bash
npx hardhat compile
```

### Step 8: Run Your Tests

Finally, you can run your tests with the following command:

```bash
npx hardhat test
```

This command will execute all tests in the `test` directory. Hardhat will automatically compile your contracts if they haven't been compiled yet.

### Additional Notes

- **Network Configuration**: If you're deploying to a live network or a testnet, you'll need to configure the network settings in `hardhat.config.js`, including the network URL and private key.
- **Testing on a Live Network**: To test on a live network, you'll need to deploy your contract to that network. This typically involves setting up a deployment script and configuring the network settings in `hardhat.config.js`.
- **Using Hardhat's Default Network**: For local testing, Hardhat's default network is sufficient. It simulates a blockchain locally, allowing you to test your contracts without deploying them to a live network.

By following these steps, you should be able to run your Hardhat contract and tests successfully.

## Test case results:

Whitelist
    Deployment
      ✔ Should set the right owner
      ✔ Should initialize the counter to 0
    Admin Functions
      ✔ Should update admin address
      ✔ Should not allow non-owner to update admin
      ✔ Should update referral cooldown
      ✔ Should not allow non-admin to update referral cooldown
    Whitelist Functions
      ✔ Should allow admin to directly whitelist an address
      ✔ Should not allow non-whitelisted user to refer
      ✔ Should allow whitelisted user to refer another user
      ✔ Should not allow referral if referrer is on cooldown
