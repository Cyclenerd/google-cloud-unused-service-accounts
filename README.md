# Detect unused Service Accounts

[![Badge: Google Cloud](https://img.shields.io/badge/Google%20Cloud-%234285F4.svg?logo=google-cloud&logoColor=white)](#readme)
[![Badge: Linux](https://img.shields.io/badge/Linux-FCC624.svg?logo=linux&logoColor=black)](#readme)
[![Badge: macOS](https://img.shields.io/badge/macOS-000000.svg?logo=apple&logoColor=white)](#readme)
[![Badge: Windows](https://img.shields.io/badge/Windows-008080.svg?logo=windows95&logoColor=white)](#readme)
[![Badge: CI](https://github.com/Cyclenerd/google-cloud-unused-service-accounts/actions/workflows/ci.yml/badge.svg)](https://github.com/Cyclenerd/google-cloud-unused-service-accounts/actions/workflows/ci.yml)
[![Badge: GitHub](https://img.shields.io/github/license/cyclenerd/google-cloud-unused-service-accounts)](https://github.com/Cyclenerd/google-cloud-unused-service-accounts/blob/master/LICENSE)


Collection of Bash and Perl scripts that work together with the
Google Cloud Platform [Policy Analyzer](https://cloud.google.com/policy-intelligence/docs/policy-analyzer-overview)
to detect unused Service Accounts (SA) or Service Account Keys (SAK)
in large Google Cloud organizations with many projects.
Tested and used within Google Cloud organizations of [DAX](https://en.wikipedia.org/wiki/DAX) companies.

## Usage

1. **Create list with projects:**
    ```shell
    bash 1_projects.sh
    ```
    All projects to which the user has access are saved to `projects.csv`.
    The CSV list can be adjusted manually.
    These projects will be used in the next steps.
1. **Enable "Policy Analyzer" API:**
    ```shell
    bash 2_enable-api.sh
    ```
1. **Get SA and SAK authentications:**
    ```shell
    bash 3_get.sh
    ```
1. **Create overview for evaluation:**
    ```shell
    bash 4_query.sh
    ```
    CSV export `auth.csv` is created.
    You can import this file into your favorite spreadsheet program.

A few evaluation tips:

Service account keys could pose a security risk if compromised.
More than one user managed key (CSV column: `userManaged`) is not a good idea.

## Requirement

A Bash shell, Perl, SQLite and a few other tools that are included in many standard GNU/Linux distributions.
In addition, you need the Google Cloud CLI `gcloud` which is very easy to install.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/Cyclenerd/google-cloud-unused-service-accounts)


<details>
<summary><b>Linux (Debian/Ubuntu/Cloud Shell)</b></summary>

Install these packages with dependencies:

```shell
sudo apt install     \
  libjson-xs-perl    \
  libdbd-sqlite3-perl
```

Install Google Cloud CLI `gcloud` following these instructions: <https://cloud.google.com/sdk/docs/install#deb>

</details>

<details>
<summary><b>macOS (Brew)</b></summary>

Install these [Homebrew](https://brew.sh/) packages with dependencies:

```shell
brew install perl
brew install cpanminus pkg-config
brew install sqlite3
brew install --cask google-cloud-sdk
```

Install Perl modules with cpanminus:
```shell
cpanm --installdeps .
```

Install Google Cloud CLI `gcloud` following these instructions: <https://cloud.google.com/sdk/docs/install#deb>

</details>

<details>
<summary><b>Windows (Cygwin)</b></summary>

Install these [Cygwin](https://www.cygwin.com/) packages:

* perl
* perl-DBD-SQLite
* perl-JSON-XS
* sqlite3
* python3

Install Google Cloud CLI `gcloud` following these instructions: <https://cloud.google.com/sdk/docs/install>

</details>


## License

All files in this repository are under the [Apache License, Version 2.0](LICENSE) unless noted otherwise.