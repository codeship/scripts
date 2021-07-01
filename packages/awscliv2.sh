#!/bin/bash
# Install awscliv2 according to the official documentation, https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * AWSCLIV2_VERSION
# * VERIFY_ZIP
# * UNZIP_EXTRACT_DIR
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/awscliv2.sh | bash -s

AWSCLIV2_VERSION=${AWSCLIV2_VERSION:="latest"}
VERIFY_ZIP=${VERIFY_ZIP:="NO"}
UNZIP_EXTRACT_DIR=${UNZIP_EXTRACT_DIR:="$HOME/unzip"}


if [[ "$AWSCLIV2_VERSION" == "latest" ]]; then
    AWSCLIV2_ZIP_DOWNLOAD_FILE="awscli-exe-linux-x86_64.zip"
    AWSCLIV2_SIG_DOWNLOAD_FILE="awscli-exe-linux-x86_64.zip.sig"
else
    AWSCLIV2_ZIP_DOWNLOAD_FILE="awscli-exe-linux-x86_64-${AWSCLIV2_VERSION}.zip"
    AWSCLIV2_SIG_DOWNLOAD_FILE="awscli-exe-linux-x86_64-${AWSCLIV2_VERSION}.zip.sig"
fi

# fail the script on the first failing command.
set -e

AWSCLIV2_ZIP_DOWNLOAD_LOCATION="${HOME}/cache/${AWSCLIV2_ZIP_DOWNLOAD_FILE}"
AWSCLIV2_SIG_DOWNLOAD_LOCATION="${HOME}/cache/${AWSCLIV2_SIG_DOWNLOAD_FILE}"


rm -rf "${UNZIP_EXTRACT_DIR}/aws"

wget --continue  --output-document ${AWSCLIV2_ZIP_DOWNLOAD_LOCATION} "https://awscli.amazonaws.com/${AWSCLIV2_ZIP_DOWNLOAD_FILE}"

if [[ "$VERIFY_ZIP" != "NO" ]]; then
    gpg --import - <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBF2Cr7UBEADJZHcgusOJl7ENSyumXh85z0TRV0xJorM2B/JL0kHOyigQluUG
ZMLhENaG0bYatdrKP+3H91lvK050pXwnO/R7fB/FSTouki4ciIx5OuLlnJZIxSzx
PqGl0mkxImLNbGWoi6Lto0LYxqHN2iQtzlwTVmq9733zd3XfcXrZ3+LblHAgEt5G
TfNxEKJ8soPLyWmwDH6HWCnjZ/aIQRBTIQ05uVeEoYxSh6wOai7ss/KveoSNBbYz
gbdzoqI2Y8cgH2nbfgp3DSasaLZEdCSsIsK1u05CinE7k2qZ7KgKAUIcT/cR/grk
C6VwsnDU0OUCideXcQ8WeHutqvgZH1JgKDbznoIzeQHJD238GEu+eKhRHcz8/jeG
94zkcgJOz3KbZGYMiTh277Fvj9zzvZsbMBCedV1BTg3TqgvdX4bdkhf5cH+7NtWO
lrFj6UwAsGukBTAOxC0l/dnSmZhJ7Z1KmEWilro/gOrjtOxqRQutlIqG22TaqoPG
fYVN+en3Zwbt97kcgZDwqbuykNt64oZWc4XKCa3mprEGC3IbJTBFqglXmZ7l9ywG
EEUJYOlb2XrSuPWml39beWdKM8kzr1OjnlOm6+lpTRCBfo0wa9F8YZRhHPAkwKkX
XDeOGpWRj4ohOx0d2GWkyV5xyN14p2tQOCdOODmz80yUTgRpPVQUtOEhXQARAQAB
tCFBV1MgQ0xJIFRlYW0gPGF3cy1jbGlAYW1hem9uLmNvbT6JAlQEEwEIAD4WIQT7
Xbd/1cEYuAURraimMQrMRnJHXAUCXYKvtQIbAwUJB4TOAAULCQgHAgYVCgkICwIE
FgIDAQIeAQIXgAAKCRCmMQrMRnJHXJIXEAChLUIkg80uPUkGjE3jejvQSA1aWuAM
yzy6fdpdlRUz6M6nmsUhOExjVIvibEJpzK5mhuSZ4lb0vJ2ZUPgCv4zs2nBd7BGJ
MxKiWgBReGvTdqZ0SzyYH4PYCJSE732x/Fw9hfnh1dMTXNcrQXzwOmmFNNegG0Ox
au+VnpcR5Kz3smiTrIwZbRudo1ijhCYPQ7t5CMp9kjC6bObvy1hSIg2xNbMAN/Do
ikebAl36uA6Y/Uczjj3GxZW4ZWeFirMidKbtqvUz2y0UFszobjiBSqZZHCreC34B
hw9bFNpuWC/0SrXgohdsc6vK50pDGdV5kM2qo9tMQ/izsAwTh/d/GzZv8H4lV9eO
tEis+EpR497PaxKKh9tJf0N6Q1YLRHof5xePZtOIlS3gfvsH5hXA3HJ9yIxb8T0H
QYmVr3aIUes20i6meI3fuV36VFupwfrTKaL7VXnsrK2fq5cRvyJLNzXucg0WAjPF
RrAGLzY7nP1xeg1a0aeP+pdsqjqlPJom8OCWc1+6DWbg0jsC74WoesAqgBItODMB
rsal1y/q+bPzpsnWjzHV8+1/EtZmSc8ZUGSJOPkfC7hObnfkl18h+1QtKTjZme4d
H17gsBJr+opwJw/Zio2LMjQBOqlm3K1A4zFTh7wBC7He6KPQea1p2XAMgtvATtNe
YLZATHZKTJyiqA==
=vYOk
-----END PGP PUBLIC KEY BLOCK-----
EOF

    wget --continue --output-document "${AWSCLIV2_SIG_DOWNLOAD_LOCATION}" "https://awscli.amazonaws.com/${AWSCLIV2_SIG_DOWNLOAD_FILE}"

    gpg --verify "${AWSCLIV2_SIG_DOWNLOAD_LOCATION}" "${AWSCLIV2_ZIP_DOWNLOAD_LOCATION}"
fi

unzip "${AWSCLIV2_ZIP_DOWNLOAD_LOCATION}" -d "${UNZIP_EXTRACT_DIR}"

sudo "${UNZIP_EXTRACT_DIR}/aws/install" && /usr/local/bin/aws --version
