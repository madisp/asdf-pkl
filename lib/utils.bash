#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/apple/pkl"
TOOL_NAME="pkl"
TOOL_TEST="pkl --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if pkl is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if pkl has other means of determining installable versions.
	list_github_tags
}

get_os() {
	local os
	os="$(uname | tr '[:upper:]' '[:lower:]')"
	if [ "$os" = "darwin" ]; then
		echo "macos"
	elif [ "$os" = "linux" ]; then
		# check for Alpine Linux
		if [ -f /etc/alpine-release ]; then
			echo "alpine-linux"
		else
			echo "linux"
		fi
	else
		echo "$os"
	fi
}

get_arch() {
	local arch
	arch="$(uname -m)"
	if [ "$arch" = "x86_64" ]; then
		echo "amd64"
	elif [ "$arch" = "arm64" ]; then
		echo "aarch64"
	else
		echo "$arch"
	fi
}

download_release() {
	local version filename url os arch
	version="$1"
	filename="$2"
	os="$(get_os)"
	arch="$(get_arch)"

	url="$GH_REPO/releases/download/${version}/pkl-${os}-${arch}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
