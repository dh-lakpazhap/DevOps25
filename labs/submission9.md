# Lab 9 — Introduction to DevSecOps Tools

**Goal:** Explore fundamental DevSecOps practices by performing security scans on containers and web applications using industry-standard tools.  

## Task 1 — Web Application Scanning with OWASP ZAP

- **Number of Medium risk vulnerabilities:** 2
- **Security headers status:**
  - **Present:** Feature-Policy (deprecated, should be Permissions-Policy), Cache-Control
  - **Missing:** Content-Security-Policy, Cross-Origin-Embedder-Policy, Cross-Origin-Opener-Policy, X-Frame-Options, X-Content-Type-Options

![alt text](image-2.png)

Based on the ZAP scan results, the most common vulnerabilities are:

1. The scan found missing CSP, COEP, COOP headers, and deprecated Feature-Policy header.

2. Server allows requests from any origin (`Access-Control-Allow-Origin: *`), which can lead to data theft.

3. Use of unsafe functions like `bypassSecurityTrustHtml` that bypass built-in security.

4. Timestamps and file paths exposed, helping attackers understand application structure.



## Task 2 — Container Vulnerability Scanning with Trivy 

![alt text](image-3.png)

bkimminich/juice-shop (debian 13.3)
Total: 1 (HIGH: 1, CRITICAL: 0)

Node.js (node-pkg)
Total: 53 (HIGH: 44, CRITICAL: 9)

- **Package:** crypto-js
- **CVE ID:** CVE-2023-46233
- **Severity:** CRITICAL
- **Description:** crypto-js: PBKDF2 1,000 times weaker than specified in 1993

- **Package:** jsonwebtoken
- **CVE ID:** CVE-2015-9235
- **Severity:** CRITICAL
- **Description:** verification step bypass with an altered token

**Most common vulnerability types:**

- Prototype Pollution — in lodash, minimatch
- Sandbox Escape — in vm2
- Denial of Service (DoS) — in ws, multer, minimatch
- Arbitrary File Overwrite — in tar
- Authentication Bypass — in jsonwebtoken, express-jwt

**Container image scanning is crucial because:**

- Detects known vulnerabilities
- Prevents security breaches
- Identifies exposed secrets
- Protects supply chain
- Compliance

1. I would added to CI pipeline:
   ```yaml
   - name: Trivy scan
     uses: aquasecurity/trivy-action@master
     with:
       image-ref: 'myapp:latest'
       severity: 'CRITICAL,HIGH'
       exit-code: '1'  # Fail build on CRITICAL/HIGH