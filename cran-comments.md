## Release Summary
This significant EDIutils release, version 2.0.0, implements a fundamental 
update to the authentication method, as we have transitioned to the 
**NEW EDI Identity and Access Management (IAM) system**. This change introduces 
backwards incompatibility with previous package versions for a few functions. 
To continue using EDI services, users must now create an IAM account and 
generate API tokens for authentication. Detailed instructions for setting up 
IAM accounts and generating tokens are available in the relevant sections of the 
documentation.

These changes are necessary to ensure the long-term stability and 
maintainability of the package. We have incremented the **MAJOR** version number 
(following SemVer principles) to clearly indicate these incompatible API 
changes.


## Test environments
* aarch64-apple-darwin20, (local machine), R 4.5.2
* aarch64-apple-darwin20 (R-hub), R development (unstable) (2026-01-06 r89281)
* x86_64-w64-mingw32 (R-hub), R development (unstable) (2026-01-06 r89281 ucrt)
* x86_64-w64-mingw32 (R-hub), R version 4.5.2 (2025-10-31 ucrt)
* x86_64-w64-mingw32 (R-hub), R version 4.4.3 (2025-02-28 ucrt)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R development (unstable) (2026-01-06 r89281)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R version 4.5.2 (2025-10-31)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R version 4.5.2 Patched (2026-01-05 r89281)


## R CMD check results
0 ERROR | 0 WARNINGS | 0 NOTES

## Downstream dependencies
There are currently no downstream dependencies for this package.

Thank you!
