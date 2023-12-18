import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

def is_valid_url(url):
    parsed = urlparse(url)
    return bool(parsed.netloc) and bool(parsed.scheme)

def get_all_urls(url, domain, all_urls):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')

        for link in soup.find_all('a', href=True):
            href = link['href']
            if not href.startswith('http'):
                href = urljoin(url, href)
            if href not in all_urls and is_valid_url(href):
                all_urls.add(href)
                if domain in href:
                    get_all_urls(href, domain, all_urls)
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {str(e)}")

def crawl_website(start_url, domain):
    all_urls = set()
    get_all_urls(start_url, domain, all_urls)
    return all_urls

def is_url_valid(url):
        try:
            # Remove trailing slash if present for the initial check
            if url.endswith('/'):
                url = url[:-1]

            response = requests.head(url, allow_redirects=True, timeout=5)
            # If HEAD is not allowed, a GET request is tried
            if response.status_code != 200:
                response = requests.get(url, timeout=5)
            return response.status_code == 200
        except requests.RequestException as e:
            # If the URL with the trailing slash was not valid, check without it
            if url.endswith('/'):
                return is_url_valid(url[:-1])
            print(f"Error with URL {url}: {e}")
            return False

# Example Usage
start_url = 'https://informatievlaanderen.github.io/VSDS-Tech-Docs/'  # Replace with your starting URL
domain = 'https://informatievlaanderen.github.io/VSDS-Tech-Docs/'
all_extracted_urls = crawl_website(start_url, domain)

for url in all_extracted_urls:

    if is_url_valid(url):
        continue
    else:
        print("following url is a deadlink: ", url)