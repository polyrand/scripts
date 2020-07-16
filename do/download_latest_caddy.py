#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import re


r = requests.get("https://github.com/caddyserver/caddy/releases")

soup = BeautifulSoup(r.text)

ds = soup.find_all(href=re.compile(".*linux_amd64.*"))

[d.attrs["href"] for d in ds]

u = [d.attrs["href"] for d in ds]

latest = sorted([uu.split("/")[5] for uu in u])[-1]

latest_url = sorted([d.attrs["href"] for d in ds], key=lambda x: x.split("/")[5])[-1]

versions = [re.search("v\d\.\d\.\d", i, re.IGNORECASE).group() for i in u]
