/**
 * Open Tibia Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2020 Open Tibia Community
 */

#include "account_storage_stub.hpp"

#include "creatures/players/account/account.hpp"
#include "creatures/players/account/account_storage.hpp"

#include <catch2/catch.hpp>
#include <limits>

#define account_id 123

/*******************************************************************************
 * Account()
 ******************************************************************************/
TEST_CASE("Constructor ID", "[UnitTest]")
{
    account::Account acc(account_id);

    SECTION("Default ID")
    {
        uint32_t id = acc.getID();
        CHECK(id == account_id);
    }

    SECTION("Default Premium Remaining Days")
    {
        uint32_t days = acc.getPremiumRemainingDays();
        CHECK(days == 0);
    }

    SECTION("Default Premium Last Day")
    {
        time_t time = acc.getPremiumLastDay();
        CHECK(time == 0);
    }

    SECTION("Default Account Type")
    {
        account::AccountType type = acc.getAccountType();
        CHECK(type == account::ACCOUNT_TYPE_NORMAL);
    }
}

TEST_CASE("Constructor EMAIL", "[UnitTest]")
{
    account::Account acc("otbr@ot.com");

    SECTION("Default ID")
    {
        uint32_t id = acc.getID();
        CHECK(id == 0);
    }

    SECTION("Default Premium Remaining Days")
    {
        uint32_t days = acc.getPremiumRemainingDays();
        CHECK(days == 0);
    }

    SECTION("Default Premium Last Day")
    {
        time_t time = acc.getPremiumLastDay();
        CHECK(time == 0);
    }

    SECTION("Default Account Type")
    {
        account::AccountType type = acc.getAccountType();
        CHECK(type == account::ACCOUNT_TYPE_NORMAL);
    }
}


/*******************************************************************************
 * setAccountStorageInterface()
 ******************************************************************************/
TEST_CASE("Set Storage Interface to Nullptr", "[UnitTest]")
{
    account::Account account(account_id);
    error_t result;
    result = account.setAccountStorageInterface(nullptr);
    CHECK(result == account::ERROR_NULLPTR);
}

TEST_CASE("Set Storage Interface", "[UnitTest]")
{
    account::Account account(account_id);
    error_t result;
    account::AccountStorageStub accStorage();
    result = account.setAccountStorageInterface(nullptr);
    CHECK(result == account::ERROR_NULLPTR);
}


/*******************************************************************************
 * loadAccount()
 ******************************************************************************/
TEST_CASE("Load Account Without Interface", "[UnitTest]")
{
    // Load Account
    account::Account account(account_id);
    error_t result;
    result = account.loadAccount();

    CHECK(result == account::ERROR_NULLPTR);
}

TEST_CASE("Load Account ID", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;
    accStub.m_account.premiumRemainingDays = 10;
    accStub.m_account.premiumLastDay = 15;
    accStub.m_account.accountType = account::ACCOUNT_TYPE_NORMAL;
    accStub.m_account.players.insert({"eNoob", 24});
    accStub.m_account.players.insert({"oMarCopia", 0});
    accStub.m_account.players.insert({"Otbr", 100});

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Account Players
    std::map<std::string, uint64_t> players;
    std::tie(players, result) = account.getAccountPlayers();
    REQUIRE(result == account::ERROR_NO);

    // Check account info
    CHECK(account.getID() == account_id);
    CHECK(account.getPremiumRemainingDays() ==
        accStub.m_account.premiumRemainingDays);
    CHECK(account.getPremiumLastDay() == accStub.m_account.premiumLastDay);
    CHECK(account.getAccountType() == account::ACCOUNT_TYPE_NORMAL);

    CHECK(players.size() == 3);
    CHECK(players["eNoob"] == 24);
    CHECK(players["oMarCopia"] == 0);
    CHECK(players["Otbr"] == 100);
}

TEST_CASE("Load Account Email", "[UnitTest]")
{
    account::Account account("enoob@dev.xml"); // Tribute to the XML Dev from
                                               // ***
    // Create Stub Storage Interface
    account::AccountStorageStub accStub;
    accStub.m_account.premiumRemainingDays = 10;
    accStub.m_account.premiumLastDay = 15;
    accStub.m_account.accountType = account::ACCOUNT_TYPE_NORMAL;
    accStub.m_account.players.insert({"eNoob", 24});
    accStub.m_account.players.insert({"oMarCopia", 0});
    accStub.m_account.players.insert({"Otbr", 100});

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Account Players
    std::map<std::string, uint64_t> players;
    std::tie(players, result) = account.getAccountPlayers();
    REQUIRE(result == account::ERROR_NO);

    // Check Account
    CHECK(account.getID() == 122);
    CHECK(account.getPremiumRemainingDays() ==
        accStub.m_account.premiumRemainingDays);
    CHECK(account.getPremiumLastDay() == accStub.m_account.premiumLastDay);
    CHECK(account.getAccountType() == account::ACCOUNT_TYPE_NORMAL);

    CHECK(players.size() == 3);
    CHECK(players["eNoob"] == 24);
    CHECK(players["oMarCopia"] == 0);
    CHECK(players["Otbr"] == 100);
}

TEST_CASE("Load Account Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    accStub.m_forceLoadError = true;
    result = account.loadAccount();
    CHECK(result == account::ERROR_LOADING_ACCOUNT);
}


/*******************************************************************************
 * reLoadAccount()
 ******************************************************************************/
TEST_CASE("RE-Load Account Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    error_t result;
    result = account.reLoadAccount();
    CHECK(result == account::ERROR_NOT_INITIALIZED);
}

TEST_CASE("RE-Load Account Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Reload Account
    accStub.m_forceLoadError = true;
    result = account.reLoadAccount();
    CHECK(result == account::ERROR_LOADING_ACCOUNT);
}

TEST_CASE("RE-Load Account", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;
    accStub.m_account.premiumRemainingDays = 10;
    accStub.m_account.premiumLastDay = 15;
    accStub.m_account.accountType = account::ACCOUNT_TYPE_NORMAL;
    accStub.m_account.players.insert({"eNoob", 24});
    accStub.m_account.players.insert({"oMarCopia", 0});
    accStub.m_account.players.insert({"Otbr", 100});

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);
    REQUIRE(account.getID() == account_id);
    REQUIRE(account.getPremiumRemainingDays() ==
        accStub.m_account.premiumRemainingDays);
    REQUIRE(account.getPremiumLastDay() == accStub.m_account.premiumLastDay);
    REQUIRE(account.getAccountType() == account::ACCOUNT_TYPE_NORMAL);

    // Get Account Players
    std::map<std::string, uint64_t> players;
    std::tie(players, result) = account.getAccountPlayers();
    REQUIRE(result == account::ERROR_NO);
    REQUIRE(players.size() == 3);
    REQUIRE(players["eNoob"] == 24);
    REQUIRE(players["oMarCopia"] == 0);
    REQUIRE(players["Otbr"] == 100);

    // Change account
    REQUIRE(
        account.setAccountType(account::ACCOUNT_TYPE_GOD) == account::ERROR_NO);
    REQUIRE(account.setPremiumLastDay(5) == account::ERROR_NO);
    REQUIRE(account.setPremiumRemainingDays(20) == account::ERROR_NO);
    accStub.m_account.players.insert({"eXMLdev", 1});


    // Check account changes
    REQUIRE(account.getID() == account_id);
    REQUIRE(account.getPremiumRemainingDays() == 20);
    REQUIRE(account.getPremiumLastDay() == 5);
    REQUIRE(account.getAccountType() == account::ACCOUNT_TYPE_GOD);

    // Reload account
    result = account.reLoadAccount();
    REQUIRE(result == account::ERROR_NO);
    CHECK(account.getID() == account_id);
    CHECK(account.getPremiumRemainingDays() ==
        accStub.m_account.premiumRemainingDays);
    CHECK(account.getPremiumLastDay() == accStub.m_account.premiumLastDay);
    CHECK(account.getAccountType() == account::ACCOUNT_TYPE_NORMAL);

    // Get Account Players
    std::tie(players, result) = account.getAccountPlayers();
    REQUIRE(result == account::ERROR_NO);

    CHECK(players.size() == 4);
    CHECK(players["eNoob"] == 24);
    CHECK(players["oMarCopia"] == 0);
    CHECK(players["Otbr"] == 100);
    CHECK(players["eXMLdev"] == 1);
}


/*******************************************************************************
 * saveAccount()
 ******************************************************************************/
TEST_CASE("Save Account Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    error_t result;
    // Load Account
    result = account.saveAccount();
    CHECK(result == account::ERROR_NOT_INITIALIZED);
}

TEST_CASE("Save Account Error Storage", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Save Account
    accStub.m_forceSaveError = true;
    result = account.saveAccount();
    CHECK(result == account::ERROR_STORAGE);
}

TEST_CASE("Save Account", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;
    accStub.m_account.premiumRemainingDays = 10;
    accStub.m_account.premiumLastDay = 15;
    accStub.m_account.accountType = account::ACCOUNT_TYPE_NORMAL;
    accStub.m_account.players.insert({"eNoob", 24});
    accStub.m_account.players.insert({"oMarCopia", 0});
    accStub.m_account.players.insert({"Otbr", 100});

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);
    REQUIRE(account.getID() == account_id);
    REQUIRE(account.getPremiumRemainingDays() ==
        accStub.m_account.premiumRemainingDays);
    REQUIRE(account.getPremiumLastDay() == accStub.m_account.premiumLastDay);
    REQUIRE(account.getAccountType() == account::ACCOUNT_TYPE_NORMAL);

    // Change account
    REQUIRE(
        account.setAccountType(account::ACCOUNT_TYPE_GOD) == account::ERROR_NO);
    REQUIRE(account.setPremiumLastDay(5) == account::ERROR_NO);
    REQUIRE(account.setPremiumRemainingDays(20) == account::ERROR_NO);

    // Check account changes
    REQUIRE(account.getID() == account_id);
    REQUIRE(account.getPremiumRemainingDays() == 20);
    REQUIRE(account.getPremiumLastDay() == 5);
    REQUIRE(account.getAccountType() == account::ACCOUNT_TYPE_GOD);

    // Save account
    result = account.saveAccount();
    REQUIRE(result == account::ERROR_NO);

    // Check saved account
    CHECK(accStub.m_account.id == account_id);
    CHECK(accStub.m_account.premiumRemainingDays == 20);
    CHECK(accStub.m_account.premiumLastDay == 5);
    CHECK(accStub.m_account.accountType == account::ACCOUNT_TYPE_GOD);
    CHECK(accStub.m_account.players.size() == 3);
    CHECK(accStub.m_account.players["eNoob"] == 24);
    CHECK(accStub.m_account.players["oMarCopia"] == 0);
    CHECK(accStub.m_account.players["Otbr"] == 100);
}


/*******************************************************************************
 * getCoins()
 ******************************************************************************/
TEST_CASE("Get Coins Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    // Get Coins
    error_t result;
    uint32_t coins;
    std::tie(coins, result) = account.getCoins(account::COIN);
    CHECK(result == account::ERROR_NOT_INITIALIZED);
    CHECK(coins == 0);
}

TEST_CASE("Get Coins Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Coins
    uint32_t coins;
    accStub.m_forceGetCoinsError = true;
    std::tie(coins, result) = account.getCoins(account::COIN);
    CHECK(result == account::ERROR_STORAGE);
    CHECK(coins == 0);
}

TEST_CASE("Get Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Coins
    accStub.m_coins = 32;
    uint32_t coins;
    std::tie(coins, result) = account.getCoins(account::COIN);
    CHECK(result == account::ERROR_NO);
    CHECK(coins == 32);
}


/*******************************************************************************
 * addCoins()
 ******************************************************************************/
TEST_CASE("Add Coins Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    // Add Coins
    error_t result;
    result = account.addCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NOT_INITIALIZED);
}

TEST_CASE("Add Zero Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Add Coins
    result = account.addCoins(account::COIN, 0);
    CHECK(result == account::ERROR_NO);
}

TEST_CASE("Add Coins getCoins Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Add Coins
    accStub.m_forceGetCoinsError = true;
    result = account.addCoins(account::COIN, 32);
    CHECK(result == account::ERROR_STORAGE);
}

TEST_CASE("Add Coins Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Add Coins
    accStub.m_forceSetCoinsError = true;
    result = account.addCoins(account::COIN, 32);
    CHECK(result == account::ERROR_STORAGE);
}

TEST_CASE("Add Coins Register Transaction Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Add Coins
    accStub.m_forceRegisterError = true;
    result = account.addCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NO);
    CHECK(accStub.m_coins == 32);
}

TEST_CASE("Add Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Add Coins
    result = account.addCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NO);
    CHECK(accStub.m_coins == 32);
}

/*******************************************************************************
 * removeCoins()
 ******************************************************************************/
TEST_CASE("Remove Coins Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    // Remove Coins
    error_t result;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NOT_INITIALIZED);
}

TEST_CASE("Remove Zero Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    result = account.removeCoins(account::COIN, 0);
    CHECK(result == account::ERROR_NO);
}

TEST_CASE("Remove Coins getCoins Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    accStub.m_forceGetCoinsError = true;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_STORAGE);
}

TEST_CASE("Remove Coins Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    accStub.m_coins = 50;
    accStub.m_forceSetCoinsError = true;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_STORAGE);
}

TEST_CASE("Remove Coins Not Enough Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    accStub.m_coins = 0;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_REMOVE_COINS);
}

TEST_CASE("Remove Coins Register Transaction Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    accStub.m_forceRegisterError = true;
    accStub.m_coins = 50;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NO);
}

TEST_CASE("Remove Coins", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Remove Coins
    accStub.m_coins = 50;
    result = account.removeCoins(account::COIN, 32);
    CHECK(result == account::ERROR_NO);
    CHECK(accStub.m_coins == 18);
}

/*******************************************************************************
 * getPassword()
 ******************************************************************************/
TEST_CASE("Get Password Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    // Get Password
    std::string password;
    password.clear();
    password = account.getPassword();
    CHECK(password.empty());
}

TEST_CASE("Get Password Storage Error", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Password
    std::string password;
    accStub.m_forceGetPasswordError = true;
    password = account.getPassword();
    CHECK(password == "");
}

TEST_CASE("Get Password", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Password
    std::string password;
    accStub.m_password = "epNoobXMLdev";
    password = account.getPassword();
    CHECK(password == "epNoobXMLdev");
}


/*******************************************************************************
 * get/set PremiumRemainingDays()
 ******************************************************************************/
TEST_CASE("Set Premium Remaining Days", "[UnitTest]")
{
    account::Account account(account_id);

    error_t result;

    // Set Premium Remaining Days
    result = account.setPremiumRemainingDays(10);
    CHECK(result == account::ERROR_NO);

    // Get Premium Remaining Days
    CHECK(account.getPremiumRemainingDays() == 10);
}


/*******************************************************************************
 * get/set PremiumLastDay()
 ******************************************************************************/
TEST_CASE("Set Premium Last Day Invalid Value", "[UnitTest]")
{
    account::Account account(account_id);

    error_t result;

    // Set Premium Last Day
    result = account.setPremiumLastDay(-5);
    CHECK(result == account::ERROR_INVALID_LAST_DAY);
}

TEST_CASE("Set Premium Last Day", "[UnitTest]")
{
    account::Account account(account_id);

    error_t result;

    // Set Premium Remaining Days
    result = account.setPremiumLastDay(15);
    CHECK(result == account::ERROR_NO);

    // Get Premium Remaining Days
    CHECK(account.getPremiumLastDay() == 15);
}

/*******************************************************************************
 * getAccountPlayers()
 ******************************************************************************/
TEST_CASE("Get Account Players Not Initialized", "[UnitTest]")
{
    account::Account account(account_id);

    // Get Account Players
    error_t result;
    std::map<std::string, uint64_t> players;
    std::tie(players, result) = account.getAccountPlayers();
    CHECK(result == account::ERROR_NOT_INITIALIZED);
    CHECK(players.size() == 0);
}

TEST_CASE("Get Account Players", "[UnitTest]")
{
    account::Account account(account_id);

    // Create Stub Storage Interface
    account::AccountStorageStub accStub;
    accStub.m_account.players.insert({"eNoob", 24});
    accStub.m_account.players.insert({"oMarCopia", 0});
    accStub.m_account.players.insert({"Otbr", 100});

    // Create Storage Interface Pointer
    account::AccountStorage* storage;
    storage = &accStub;

    // Set Account Storage Interface
    error_t result;
    result = account.setAccountStorageInterface(storage);
    REQUIRE(result == account::ERROR_NO);

    // Load Account
    result = account.loadAccount();
    REQUIRE(result == account::ERROR_NO);

    // Get Account Players
    std::map<std::string, uint64_t> players;
    std::tie(players, result) = account.getAccountPlayers();
    CHECK(result == account::ERROR_NO);
    CHECK(players.size() == 3);
    CHECK(players["eNoob"] == 24);
    CHECK(players["oMarCopia"] == 0);
    CHECK(players["Otbr"] == 100);
}
