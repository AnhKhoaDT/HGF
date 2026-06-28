import json
import requests
from ddgs import DDGS
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import time


def extract_metadata(soup):
    metadata = {}

    for meta in soup.find_all("meta"):
        key = (
            meta.get("name")
            or meta.get("property")
            or meta.get("http-equiv")
        )

        value = meta.get("content")

        if key and value:
            metadata[key] = value

    return metadata


def extract_images(soup, base_url):
    images = []

    for img in soup.find_all("img"):

        src = img.get("src")

        if not src:
            continue

        images.append(
            {
                "src": urljoin(base_url, src),
                "alt": img.get("alt"),
                "title": img.get("title"),
            }
        )

    return images


def extract_links(soup, base_url):
    links = []

    for a in soup.find_all("a"):

        href = a.get("href")

        if not href:
            continue

        links.append(
            {
                "text": a.get_text(" ", strip=True),
                "url": urljoin(base_url, href),
            }
        )

    return links


def extract_headings(soup):
    headings = []

    for tag in ["h1", "h2", "h3", "h4"]:

        for node in soup.find_all(tag):

            headings.append(
                {
                    "tag": tag,
                    "text": node.get_text(
                        " ",
                        strip=True
                    )
                }
            )

    return headings


def extract_json_ld(soup):

    schemas = []

    for script in soup.find_all(
        "script",
        type="application/ld+json"
    ):

        if script.string:

            schemas.append(
                script.string
            )

    return schemas


def scrape_url(url):

    print(f"Scraping: {url}")

    result = {
        "url": url,
        "title": "",
        "metadata": {},
        "headings": [],
        "images": [],
        "links": [],
        "schema": [],
        "clean_text": "",
        "raw_html": ""
    }

    headers = {
        "User-Agent": (
            "Mozilla/5.0"
        )
    }

    # ====================
    # HTML GỐC
    # ====================

    try:

        html_response = requests.get(
            url,
            headers=headers,
            timeout=20
        )

        html_response.raise_for_status()

        html = html_response.text

        result["raw_html"] = html

        soup = BeautifulSoup(
            html,
            "html.parser"
        )

        if soup.title:
            result["title"] = (
                soup.title.get_text(
                    strip=True
                )
            )

        result["metadata"] = (
            extract_metadata(
                soup
            )
        )

        result["headings"] = (
            extract_headings(
                soup
            )
        )

        result["images"] = (
            extract_images(
                soup,
                url
            )
        )

        result["links"] = (
            extract_links(
                soup,
                url
            )
        )

        result["schema"] = (
            extract_json_ld(
                soup
            )
        )

    except Exception as e:

        print(
            f"HTML Error: {e}"
        )

    # ====================
    # JINA READER
    # ====================

    try:

        jina_url = (
            f"https://r.jina.ai/{url}"
        )

        text_response = requests.get(
            jina_url,
            headers=headers,
            timeout=60
        )

        text_response.raise_for_status()

        result["clean_text"] = (
            text_response.text
        )

    except Exception as e:

        print(
            f"Jina Error: {e}"
        )

    return result


def search_and_scrape(
    query,
    max_results=5
):

    ddgs = DDGS()

    search_results = list(
        ddgs.text(
            query,
            max_results=max_results
        )
    )

    results = []

    for rank, item in enumerate(
        search_results,
        start=1
    ):

        url = item.get("href")

        if not url:
            continue

        try:

            page = scrape_url(
                url
            )

            page["search_rank"] = rank
            if item.get("title") == "":
                continue
            page["search_title"] = (
                item.get("title")
            )
            results.append(
                page
            )

            print(
                f"OK: {url}"
            )

            time.sleep(1)

        except Exception as e:

            print(e)

    return {
        "query": query,
        "results": results
    }


if __name__ == "__main__":

    query = (
        "review chi tiết "
        "tiệm cà phê túi mơ to đà lạt"
    )

    data = search_and_scrape(
        query,
        max_results=3
    )

    with open(
        "research_data.json",
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2
        )

    print(
        "\nSaved research_data.json"
    )