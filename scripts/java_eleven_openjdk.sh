#!/bin/bash

# This script downloads and installs the latest available Java 11 OpenJDK release for compatible Macs

# Determine OS version

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

IdentifyLatestJDKRelease(){
  
  # Determine the download URL for the latest release.
  
  Java_11_JDK_URL=$(/usr/bin/curl -s https://jdk.java.net/11/ | grep -ioE "https://download.java.net/java/GA/jdk11/.*?/GPL/openjdk-11.*_osx-x64_bin.tar.gz" | head -1)
  
  # Use the Version variable to determine if the script should install the latest release.
  
  if [[ "$Java_11_JDK_URL" != "" ]]; then
    fileURL="$Java_11_JDK_URL"
    sha256URL="${Java_11_JDK_URL}.sha256"
    /bin/echo "Installing Java 11 OpenJDK -" "$Java_11_JDK_URL"
    elif [[ "$Java_11_JDK_URL" = "" ]]; then
    /bin/echo "Unable to identify download URL for requested Java 11 OpenJDK. Exiting."
    exit 0
  fi
}

if [[ ${osvers} -lt 11 ]]; then
  echo "Java 11 OpenJDK is not available for Mac OS X 10.10 or earlier."
fi

if [[ ${osvers} -ge 11 ]]; then
  
  # Specify name of downloaded
  
  targz_path="/tmp/java_eleven_jdk.tar.gz"
  
  # Identify the URL of the latest Java 11 OpenJDK software binary
  # using the IdentifyLatestJDKRelease function.
  
  IdentifyLatestJDKRelease
  
  # Download the latest Java 11 OpenJDK software binary and sha256 signature
  
  /usr/bin/curl --retry 3 -o "${targz_path}" "$fileURL"
  /usr/bin/curl --retry 3 -o "${targz_path}".sha256 "$sha256URL"
  
  if [[ "$(shasum -a 256 "${targz_path}")" != "$(cat "${targz_path}".sha256)  ${targz_path}" ]]; then
    /bin/echo "SHA-256 checksum control error"
    exit 0
  fi
  
  cd /Library/Java/JavaVirtualMachines || exit
  
  sudo /usr/bin/tar -xvf "${targz_path}"
  
  # Clean-up
  
  # Remove the downloaded /tmp/java_eleven_jdk.tar.gz and sha256
  
  /bin/rm -f "$targz_path" "$targz_path".sha256
  
fi

exit 0
