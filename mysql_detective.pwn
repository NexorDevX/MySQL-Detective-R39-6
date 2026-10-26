#include <a_samp>
#include "include/a_mysql.inc"

// MySQL Detective — standalone MySQL connection diagnostic for SA-MP/CRMP
// Compatible with the mysql_static.so / MySQL plugin R39-6 API.
// Do not publish a copy containing real database credentials.

#define TEST_MYSQL_HOST     "127.0.0.1"
#define TEST_MYSQL_USER     "YOUR_DB_USER"
#define TEST_MYSQL_DATABASE "YOUR_DB_NAME"
#define TEST_MYSQL_PASSWORD "YOUR_DB_PASSWORD"
#define TEST_MYSQL_PORT     (3306)

new g_MySQL;

main() {}

public OnGameModeInit()
{
    print("==================================================");
    print("[MYSQL DETECTIVE] Starting standalone connection test");
    print("[MYSQL DETECTIVE] Plugin API: MySQL R39-6");
    printf("[MYSQL DETECTIVE] Host: %s", TEST_MYSQL_HOST);
    printf("[MYSQL DETECTIVE] User: %s", TEST_MYSQL_USER);
    printf("[MYSQL DETECTIVE] Database: %s", TEST_MYSQL_DATABASE);
    printf("[MYSQL DETECTIVE] Port: %d", TEST_MYSQL_PORT);
    print("[MYSQL DETECTIVE] Password is intentionally not printed.");

    mysql_log(LOG_ERROR, LOG_TYPE_TEXT);

    print("[MYSQL DETECTIVE] Calling mysql_connect...");
    g_MySQL = mysql_connect(
        TEST_MYSQL_HOST,
        TEST_MYSQL_USER,
        TEST_MYSQL_DATABASE,
        TEST_MYSQL_PASSWORD,
        TEST_MYSQL_PORT,
        true,
        1
    );

    printf("[MYSQL DETECTIVE] Connection handle: %d", g_MySQL);

    if (g_MySQL == 0)
    {
        print("[MYSQL DETECTIVE][FAIL] mysql_connect returned handle 0.");
        print("[MYSQL DETECTIVE] Read the mysql_static.so log lines immediately above this message.");
        return 1;
    }

    new error = mysql_errno(g_MySQL);
    printf("[MYSQL DETECTIVE] mysql_errno immediately after connect: %d", error);

    if (error != 0)
    {
        printf("[MYSQL DETECTIVE][FAIL] Connection returned MySQL error %d.", error);
        print("[MYSQL DETECTIVE] See plugin log for the detailed server/client error.");
        return 1;
    }

    print("[MYSQL DETECTIVE][OK] Connection handle created; sending SELECT VERSION().");
    mysql_set_charset("cp1251", g_MySQL);
    mysql_tquery(g_MySQL,
        "SELECT VERSION() AS server_version, DATABASE() AS current_database, 1 AS test_value",
        "OnMySQLTestResult");
    return 1;
}

forward OnMySQLTestResult();
public OnMySQLTestResult()
{
    new error = mysql_errno(g_MySQL);
    printf("[MYSQL DETECTIVE] Query callback mysql_errno: %d", error);

    if (error != 0)
    {
        printf("[MYSQL DETECTIVE][FAIL] Connection existed, but test query failed (error %d).", error);
        print("[MYSQL DETECTIVE] Check the mysql_static.so log for the detailed reason.");
        return 1;
    }

    new version[64], database[64];
    cache_get_row(0, 0, version, g_MySQL, sizeof(version));
    cache_get_row(0, 1, database, g_MySQL, sizeof(database));

    printf("[MYSQL DETECTIVE][OK] Server version: %s", version);
    printf("[MYSQL DETECTIVE][OK] Selected database: %s", database);
    print("[MYSQL DETECTIVE][SUCCESS] TCP/MySQL connection and SELECT test passed.");
    print("[MYSQL DETECTIVE] This confirms connectivity only; it does not test the full gamemode schema.");
    return 1;
}

public OnGameModeExit()
{
    if (g_MySQL != 0)
    {
        mysql_close(g_MySQL);
        g_MySQL = 0;
    }
    return 1;
}
