/**
 * Open Tibia Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2020 Open Tibia Community
 */

#include "src/creatures/players/account/account.hpp"
#include <catch2/catch.hpp>
#include <limits>

TEST_CASE("Default Constructor", "[UnitTest]") {
  account::Account normal;

	SECTION("Default ID") {
    uint32_t id;
    normal.getID(&id);
    CHECK(id == 0);
  }

	SECTION("@DefaultEmail") {
    std::string email;
    normal.getEmail(&email);
    CHECK(email.empty() == true);
  }

	SECTION("Default Password") {
    std::string password;
    normal.getPassword(&password);
    CHECK(password.empty() == true);
  }

	SECTION("Default Premium Remaining Days") {
    uint32_t days;
    normal.getPremiumRemaningDays(&days);
    CHECK(days == 0);
  }

	SECTION("Default Premium Remaining Days") {
    time_t time;
    normal.getPremiumLastDay(&time);
    CHECK(time == 0);
  }
}

TEST_CASE("Constructor ID", "[UnitTest]") {
  account::Account with_id(14);
  uint32_t id;
  with_id.getID(&id);
  CHECK(id == 14);
}

TEST_CASE("Constructor Email", "[UnitTest]") {
	account::Account with_email("@test");
  std::string email;
  with_email.getEmail(&email);
  CHECK(email == "@test");
}

TEST_CASE("Set Database Interface", "[UnitTest]") {
	account::Account account;
  error_t result;
  Database new_database;
  result = account.setDatabaseInterface(&new_database);
  CHECK(result == account::ERROR_NO);
}

TEST_CASE("Set Database Interface to Nullptr Must Fail", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setDatabaseInterface(nullptr);
  CHECK(result == account::ERROR_NULLPTR);
}

TEST_CASE("Set Database Task Interface", "[UnitTest]") {
	account::Account account;
  error_t result;
  DatabaseTasks new_database_tasks;
  result = account.setDatabaseTasksInterface(&new_database_tasks);
  CHECK(result == account::ERROR_NO);
}

TEST_CASE("Set Database Task Interface to Nullptr Must Fail", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setDatabaseTasksInterface(nullptr);
  CHECK(result == account::ERROR_NULLPTR);
}

TEST_CASE("Get Coins Account Not Initialized", "[UnitTest]") {
	account::Account account;
  error_t result;
  uint32_t coins;
  result = account.getCoins(&coins);
  CHECK(result == account::ERROR_NOT_INITIALIZED);
}

TEST_CASE("Get ID", "[UnitTest]") {
	account::Account account(15);
  error_t result;
  uint32_t new_id;
  result = account.getID(&new_id);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_id == 15);
}

TEST_CASE("Get ID - Nullptr", "[UnitTest]") {
	account::Account account(15);
  error_t result;
  result = account.getID(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}

TEST_CASE("Set/Get Email", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setEmail("@RickMaru");
  REQUIRE(result == account::ERROR_NO);

  std::string new_email;
  result = account.getEmail(&new_email);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_email == "@RickMaru");
}

TEST_CASE("Set Email - Empty", "[UnitTest]") {
	account::Account account;
  error_t result;
  std::string new_email;
  result = account.setEmail(new_email);
  REQUIRE(result == account::ERROR_INVALID_ACCOUNT_EMAIL);
}

TEST_CASE("Get Email - Nullptr", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.getEmail(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}

TEST_CASE("Set/Get Password", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setPassword("password123");
  REQUIRE(result == account::ERROR_NO);

  std::string new_password;
  result = account.getPassword(&new_password);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_password == "password123");
}

TEST_CASE("Set Password - Empty", "[UnitTest]") {
	account::Account account;
  error_t result;
  std::string new_password;
  result = account.setPassword(new_password);
  REQUIRE(result == account::ERROR_INVALID_ACC_PASSWORD);
}

TEST_CASE("Get Password - Nullptr", "[UnitTest]") {
	account::Account account;
  error_t result;
  std::string new_password;
  result = account.getPassword(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}


TEST_CASE("Set/Get Premium Days Remaining", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setPremiumRemaningDays(20);
  REQUIRE(result == account::ERROR_NO);

  uint32_t new_days;
  result = account.getPremiumRemaningDays(&new_days);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_days == 20);
}

TEST_CASE("Get Premium Days Remaining - Nullptr", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.getPremiumRemaningDays(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}

TEST_CASE("Set/Get Premium Last Day", "[UnitTest]") {
	account::Account account;
  error_t result;
  time_t last_day = time(nullptr);
  result = account.setPremiumLastDay(last_day);
  REQUIRE(result == account::ERROR_NO);

  time_t new_last_day;
  result = account.getPremiumLastDay(&new_last_day);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_last_day == last_day);
}

TEST_CASE("Set Premium Last Day - Zero", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setPremiumLastDay(-1);
  REQUIRE(result == account::ERROR_INVALID_LAST_DAY);
}

TEST_CASE("Get Premium Last Day - Nullptr", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.getPremiumLastDay(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}


TEST_CASE("Set/Get Account Type", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setAccountType(account::ACCOUNT_TYPE_NORMAL);
  REQUIRE(result == account::ERROR_NO);

  account::AccountType new_account_type;
  result = account.getAccountType(&new_account_type);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(new_account_type == account::ACCOUNT_TYPE_NORMAL);
}

TEST_CASE("Set Account Type - Undefine", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.setAccountType(static_cast<account::AccountType>(20));
  REQUIRE(result == account::ERROR_INVALID_ACC_TYPE);
}

TEST_CASE("Get Account Type - Nullptr", "[UnitTest]") {
	account::Account account;
  error_t result;
  result = account.getAccountType(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}

TEST_CASE("Get Account Players - Nullptr", "[UnitTest]") {
	account::Account account(1);
  error_t result;
  result = account.getAccountPlayers(nullptr);
  REQUIRE(result == account::ERROR_NULLPTR);
}


TEST_CASE("Get Coins", "[UnitTest]") {
	account::Account account(1);
  error_t result;
  uint32_t coins;
  result = account.getCoins(&coins);
  CHECK(result == account::ERROR_DB);
}

TEST_CASE("Add Zero Coins", "[UnitTest]") {
	account::Account account(1);
  error_t result;
  result = account.addCoins(0);
  REQUIRE(result == account::ERROR_NO);
}

TEST_CASE("Remove Zero Coins", "[UnitTest]") {
	account::Account account(1);
  error_t result;
  result = account.removeCoins(0);
  REQUIRE(result == account::ERROR_NO);
}
/*******************************************************************************
 * Integration Test Cases (Uses external database)
 ******************************************************************************/

TEST_CASE("Get Account Players", "[UnitTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  std::vector<account::Player> players;
  result = account.getAccountPlayers(&players);
  REQUIRE(result == account::ERROR_NO);
  REQUIRE(players.size() >= 1);
}

TEST_CASE("Remove Coins From Account With Zero Coins", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  DatabaseTasks db_tasks;
  if (account::ERROR_NO != account.SetDatabaseTasksInterface(&db_tasks)) {
    std::cout << "Failed to connect to database tasks.";
    FAIL("DB Tasks connection failes");
  }
  db_tasks.SetDatabaseInterface(&Database::getInstance());
  db_tasks.startThread();

  error_t result;

  // Clean account coins
  uint32_t get_coins;
  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);
  result = account.removeCoins(get_coins);
  CHECK(result == account::ERROR_NO);
  db_tasks.flush();
  db_tasks.stop();
  db_tasks.shutdown();
  db_tasks.join();

  result = account.removeCoins(1);
  REQUIRE(result == account::ERROR_VALUE_NOT_ENOUGH_COINS);
}

TEST_CASE("Add Maximum Number Of Coins", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  DatabaseTasks db_tasks;
  if (account::ERROR_NO != account.SetDatabaseTasksInterface(&db_tasks)) {
    std::cout << "Failed to connect to database tasks.";
    FAIL("DB Tasks connection failes");
  }
  db_tasks.SetDatabaseInterface(&Database::getInstance());
  db_tasks.startThread();

  error_t result;

  // Clean account coins
  uint32_t get_coins;
  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);
  result = account.removeCoins(get_coins);
  CHECK(result == account::ERROR_NO);
  db_tasks.flush();

  result = account.addCoins(std::numeric_limits<uint32_t>::max());
  REQUIRE(result == account::ERROR_NO);
  db_tasks.flush();

  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);

  db_tasks.stop();
  db_tasks.shutdown();
  db_tasks.join();
  REQUIRE(get_coins == std::numeric_limits<uint32_t>::max());
}

TEST_CASE("Add Maximum Number Of Coins Plus One", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  DatabaseTasks db_tasks;
  if (account::ERROR_NO != account.SetDatabaseTasksInterface(&db_tasks)) {
    std::cout << "Failed to connect to database tasks.";
    FAIL("DB Tasks connection failes");
  }
  db_tasks.SetDatabaseInterface(&Database::getInstance());
  db_tasks.startThread();

  error_t result;

  // Clean account coins
  uint32_t get_coins;
  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);
  result = account.removeCoins(get_coins);
  CHECK(result == account::ERROR_NO);
  db_tasks.flush();

  result = account.addCoins(std::numeric_limits<uint32_t>::max());
  REQUIRE(result == account::ERROR_NO);
  db_tasks.flush();
  db_tasks.stop();
  db_tasks.shutdown();
  db_tasks.join();

  result = account.addCoins(1);
  REQUIRE(result == account::ERROR_VALUE_OVERFLOW);
}

TEST_CASE("Add/Remove Coins Operation", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB Tasks connection failes");
  }

  DatabaseTasks db_tasks;
  if (account::ERROR_NO != account.SetDatabaseTasksInterface(&db_tasks)) {
    std::cout << "Failed to connect to database tasks.";
    FAIL("DB connection failes");
  }
  db_tasks.SetDatabaseInterface(&Database::getInstance());
  db_tasks.startThread();

  error_t result;

  // Clean account coins
  uint32_t get_coins;
  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);
  result = account.removeCoins(get_coins);
  CHECK(result == account::ERROR_NO);
  db_tasks.flush();

  uint32_t add_coins = 15;
  result = account.addCoins(add_coins);
  REQUIRE(result == account::ERROR_NO);
  db_tasks.flush();

  result = account.getCoins(&get_coins);
  CHECK(result == account::ERROR_NO);

  db_tasks.stop();
  db_tasks.shutdown();
  db_tasks.join();
  REQUIRE(get_coins == 15);
}

TEST_CASE("Load Account Using ID From Constructor", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB Tasks connection failes");
  }

  error_t result;
  result = account.loadAccountDB();
  REQUIRE(result == account::ERROR_NO);

  uint32_t id;
  result = account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  std::string email;
  result = account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == "@GOD");

  std::string password;
  result = account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == "21298df8a3277357ee55b01df9530b535cf08ec1");

  uint32_t premium_remaining_days;
  result = account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == 0);

  time_t premium_last_day;
  result = account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == 0);

  account::AccountType account_type;
  result = account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == account::ACCOUNT_TYPE_GOD);
}

TEST_CASE("Load Account Using Email From Constructor", "[IntegrationTest]") {
	account::Account account("@GOD");
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  result = account.loadAccountDB();
  REQUIRE(result == account::ERROR_NO);

  uint32_t id;
  result = account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  std::string email;
  result = account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == "@GOD");

  std::string password;
  result = account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == "21298df8a3277357ee55b01df9530b535cf08ec1");

  uint32_t premium_remaining_days;
  result = account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == 0);

  time_t premium_last_day;
  result = account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == 0);

  account::AccountType account_type;
  result = account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == account::ACCOUNT_TYPE_GOD);
}

TEST_CASE("Load Account Using ID", "[IntegrationTest]") {
	account::Account account;
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  result = account.loadAccountDB(1);
  REQUIRE(result == account::ERROR_NO);

  uint32_t id;
  result = account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  std::string email;
  result = account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == "@GOD");

  std::string password;
  result = account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == "21298df8a3277357ee55b01df9530b535cf08ec1");

  uint32_t premium_remaining_days;
  result = account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == 0);

  time_t premium_last_day;
  result = account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == 0);

  account::AccountType account_type;
  result = account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == account::ACCOUNT_TYPE_GOD);
}

TEST_CASE("Load Account Using Email", "[IntegrationTest]") {
	account::Account account;
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  result = account.loadAccountDB("@GOD");
  REQUIRE(result == account::ERROR_NO);

  uint32_t id;
  result = account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  std::string email;
  result = account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == "@GOD");

  std::string password;
  result = account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == "21298df8a3277357ee55b01df9530b535cf08ec1");

  uint32_t premium_remaining_days;
  result = account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == 0);

  time_t premium_last_day;
  result = account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == 0);

  account::AccountType account_type;
  result = account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == account::ACCOUNT_TYPE_GOD);
}

TEST_CASE("Save Account", "[IntegrationTest]") {
	account::Account account_orig(1);
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  result = account_orig.loadAccountDB();
  REQUIRE(result == account::ERROR_NO);
  result = account.loadAccountDB();
  REQUIRE(result == account::ERROR_NO);

  // Check account
  uint32_t id;
  result = account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  std::string email;
  result = account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == "@GOD");

  std::string password;
  result = account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == "21298df8a3277357ee55b01df9530b535cf08ec1");

  uint32_t premium_remaining_days;
  result = account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == 0);

  time_t premium_last_day;
  result = account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == 0);

  account::AccountType account_type;
  result = account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == account::ACCOUNT_TYPE_GOD);


  // Change Account
  std::string new_email("@NewEmail");
  result = account.setEmail(new_email);
  CHECK(result == account::ERROR_NO);

  std::string new_password("123456789");
  result = account.setPassword(new_password);
  CHECK(result == account::ERROR_NO);

  uint32_t new_premium_remaining_days = 10;
  result = account.setPremiumRemaningDays(new_premium_remaining_days);
  CHECK(result == account::ERROR_NO);

  time_t new_premium_last_day = time(nullptr);
  result = account.setPremiumLastDay(new_premium_last_day);
  CHECK(result == account::ERROR_NO);

  account::AccountType new_account_type = account::ACCOUNT_TYPE_NORMAL;
  result = account.setAccountType(new_account_type);
  CHECK(result == account::ERROR_NO);


  //Save Account
  result = account.saveAccountDB();
  REQUIRE(result == account::ERROR_NO);

  //Load Changed Account
  account::Account changed_account;
  result = changed_account.loadAccountDB(1);

  //Check Changed Account
  result = changed_account.getID(&id);
  CHECK(result == account::ERROR_NO);
  CHECK(id == 1);

  result = changed_account.getEmail(&email);
  CHECK(result == account::ERROR_NO);
  CHECK(email == new_email);

  result = changed_account.getPassword(&password);
  CHECK(result == account::ERROR_NO);
  CHECK(password == new_password);

  result = changed_account.getPremiumRemaningDays(&premium_remaining_days);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_remaining_days == new_premium_remaining_days);

  result = changed_account.getPremiumLastDay(&premium_last_day);
  CHECK(result == account::ERROR_NO);
  CHECK(premium_last_day == new_premium_last_day);

  result = changed_account.getAccountType(&account_type);
  CHECK(result == account::ERROR_NO);
  CHECK(account_type == new_account_type);

  //Restore Account Values
  result = account_orig.saveAccountDB();
  REQUIRE(result == account::ERROR_NO);
}

TEST_CASE("Register Coin Transaction", "[IntegrationTest]") {
	account::Account account(1);
  std::string db_ip("127.0.0.1");
  std::string db_user("otserver");
  std::string db_password("otserver");
  std::string db_database("otserver");
  if (!Database::getInstance().connect(
          db_ip.c_str(),
          db_user.c_str(),
          db_password.c_str(),
          db_database.c_str(),
          0,
          NULL)) {
    std::cout << "Failed to connect to database.";
    FAIL("DB connection failes");
  }

  error_t result;
  result = account.registerCoinsTransaction(account::COIN_ADD, 50,
                                            "Test Register Add Coin 1");
  CHECK(result == account::ERROR_NO);

  result = account.registerCoinsTransaction(account::COIN_ADD, 100,
                                            "Test Register Add Coin 2");
  CHECK(result == account::ERROR_NO);

  result = account.registerCoinsTransaction(account::COIN_REMOVE, 250,
                                            "Test Register Remove Coin 3");
  CHECK(result == account::ERROR_NO);

  result = account.registerCoinsTransaction(account::COIN_REMOVE, 500,
                                            "Test Register Remove Coin 4");
  CHECK(result == account::ERROR_NO);

  result = account.registerCoinsTransaction(account::COIN_ADD, 1000,
                                            "Test Register Add Coin 5");
  CHECK(result == account::ERROR_NO);
}
