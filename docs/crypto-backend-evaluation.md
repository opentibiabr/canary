# Crypto backend evaluation

## Summary

Canary now uses Mbed TLS for RSA login operations. OpenSSL was the previous RSA implementation and has been removed from the direct RSA backend.

There is no runtime or CMake RSA backend selector in the current branch. Mbed TLS is the only RSA backend built by the repository.

The goal of this work is to remove direct RSA coupling to OpenSSL without changing the login protocol. The migration depends on byte-for-byte tests for fixed-width raw RSA behavior.

## Motivation

Canary historically used OpenSSL directly in `RSAManager` for login RSA. A link audit showed that `libcrypto` was part of the final executable when OpenSSL-backed RSA was used, so the OpenSSL dependency had a real binary impact.

The RSA code has been moved behind a small backend boundary. OpenSSL headers were removed from the precompiled header, OpenSSL was removed from the manifest and CMake link path, and the active implementation now lives in `src/security/rsa_backend_mbedtls.cpp`.

Earlier audit work also showed that the direct OpenSSL usage was crypto/RSA, not TLS. This does not mean Canary should remove TLS support from dependencies such as curl or libmariadb; the scope here is only the RSA login backend.

Do not claim executable size reduction without a fresh link audit for the exact build preset being reviewed.

## Current behavior that must be preserved

The RSA login path has a narrow compatibility contract:

- Input blocks are exactly 128 bytes.
- The operation is raw RSA private exponentiation, equivalent to `m = c^d mod n`.
- No implicit padding must be added or removed by the backend.
- Output blocks remain exactly 128 bytes.
- Leading zero bytes in the decrypted block must be preserved.
- The login flow validates the first decrypted byte after RSA decrypt.
- `key.pem` loading remains supported.
- The built-in CipSoft `p/q` fallback remains supported.
- Mbed TLS is the only RSA backend in the current repository.

Breaking any of these rules can make login incompatible even when cryptographic APIs appear to succeed.

## Current backend

### Mbed TLS

Mbed TLS is the active and only RSA backend in the current branch. The implementation uses:

- `mbedtls_pk_parse_keyfile` for `loadPEM`.
- `mbedtls_rsa_private` for fixed-width raw RSA private operations without padding.
- `mbedtls_mpi_read_string`, `mbedtls_rsa_import`, `mbedtls_rsa_complete`, and `mbedtls_rsa_check_privkey` for the `setKey(p, q, base)` fallback.
- Atomic active-key replacement so failed PEM loads or invalid fallback keys do not disrupt an already working key.

Do not replace the raw RSA operation with `mbedtls_pk_decrypt`. That API can apply or remove padding and may change the 128-byte login block contract.

Mbed TLS must keep passing byte-for-byte tests that prove the raw 128-byte login behavior did not change.

## Benchmark and link audit

The current PR description and review discussion treat performance and linkage as validation work, not as a measured claim. Keep that distinction in future updates:

- Do not claim executable size reduction or link reduction without a fresh link audit for the exact preset.
- Use release-like builds for timing comparisons; debug, ASan, and test presets are useful for correctness but not for performance conclusions.
- Benchmark the RSA login operation with fixed 128-byte ciphertext samples and a loaded `key.pem`, then compare against the previous baseline only when both builds use equivalent compiler flags and dependency triplets.
- Prefer Canary's existing `Benchmark` helper or a focused standalone harness that repeatedly calls `RSAManager::decrypt` after one-time key loading. Do not include PEM parsing time unless the benchmark is explicitly about startup/key-loading cost.
- Record minimum, maximum, average, iteration count, platform, compiler, preset, and vcpkg triplet with the benchmark result.
- Repeat the link audit before making statements about `libcrypto`, `libssl`, `mbedtls`, `mbedx509`, or `mbedcrypto` in the final artifact.

## How to build

Run commands from the repository root.

### Current backend

```powershell
cmake --preset windows-release
cmake --build --preset windows-release
```

### Tests

```powershell
cmake --preset windows-release-enabled-tests
cmake --build --preset windows-release-enabled-tests
.\build\windows-release-enabled-tests\tests\unit\canary_ut.exe
.\build\windows-release-enabled-tests\tests\integration\canary_it.exe
```

For Linux, use the matching debug preset:

```bash
cmake --preset linux-debug
cmake --build --preset linux-debug
ctest --preset linux-debug
```

## Validation

Validation should focus on behavior, not only successful compilation:

- Build the normal release preset for the target platform.
- Build tests and run the RSA unit tests.
- Verify that `key.pem` loads successfully.
- Verify that fallback `setKey(p, q, base)` produces deterministic decrypt output.
- Keep byte-for-byte RSA test vectors for encrypted 128-byte samples.
- Check that decrypted output preserves leading zeros and remains 128 bytes.
- Keep integration coverage for `key.pem` loading through `RSAManager::start`.
- Keep integration test database reset behavior aligned with `schema.sql` when schema sentinel checks change.
- Run login smoke tests with the supported clients and protocol versions.
- Repeat link audit before making claims about `libcrypto`, `libssl`, or executable size.

## Limitations

The current branch does not provide a runtime or CMake backend selector. It also does not keep an OpenSSL backend implementation available for side-by-side local comparison.

The Mbed TLS backend currently targets Canary's existing raw RSA login contract. It is not a general RSA decrypt wrapper and should not be reused for padded RSA workflows without a separate API and tests.

## Future improvements

Potential follow-up work:

- Add more RSA vectors if new supported key sizes or protocol variants are introduced.
- Add more integration coverage if the login handshake is exercised beyond direct `RSAManager::start` and decrypt calls.
- Record link audit commands and expected linked libraries per preset.
- Evaluate Botan as a plan B, wolfSSL only after license review, LibTomCrypt as a more manual implementation option, and BCrypt/NCrypt only as an optional Windows-specific backend.
