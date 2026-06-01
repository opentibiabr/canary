target_sources(
    canary_it
    PRIVATE rsa_it.cpp
)

target_compile_definitions(
    canary_it
    PRIVATE RSA_TEST_KEY="${PROJECT_SOURCE_DIR}/tests/fixture/security/key.pem"
)
