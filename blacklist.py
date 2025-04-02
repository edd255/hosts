import urllib.request
from pwn import log
import os
import re

HOSTS = {
    "StevenBlack": "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts",
    "Xtra": "https://badmojr.github.io/1Hosts/Xtra/hosts.txt",
}

LEECHERS = {"blog.fefe.de", "lobste.rs", "news.ycombinator.com"}


def remove_duplicates(in_file: str, out_file: str) -> None:
    seen = set()
    with open(out_file, "w") as out_fd, open(in_file, "r") as in_fd:
        for line in in_fd:
            if line not in seen:
                out_fd.write(line)
                seen.add(line)


def dl_cat(urls: dict[str, str], file: str) -> None:
    with open(file, "w") as outfile:
        for name, url in urls.items():
            try:
                with urllib.request.urlopen(url) as response:
                    content = response.read().decode("utf-8")
                    outfile.write(content)
                    log.success(f"Processed '{name}'.")
            except urllib.error.URLError as e:
                log.failure(f"Error downloading {url}: {e}")
            except UnicodeDecodeError as e:
                log.failure(f"Error decoding content from {url}: {e}")
    log.success(f"Content concatenated into {file}")


def cleanup_hosts(file: str):
    with open(file, "r") as fd:
        lines = fd.readlines()
    processed_lines = []
    for line in lines:
        line = re.match(r"^[^#]*", line).group(0) if line.strip() else ""
        line = line.replace("  ", "").replace("\n", "")
        if line.strip():
            processed_lines.append(f"{line}\n")
    with open(file, "w") as fd:
        fd.writelines(processed_lines)
    log.success(f"Processed 'hosts' file: {file}")


def add_leechers(urls: dict[str], file: str) -> None:
    with open(file, "a") as fd:
        for url in urls:
            fd.write(f"0.0.0.0 {url}\n")


def main() -> None:
    dl_cat(HOSTS, "tmp")
    cleanup_hosts("tmp")
    remove_duplicates("tmp", "hosts")
    os.remove("tmp")
    add_leechers(LEECHERS, "hosts")


if __name__ == "__main__":
    main()
