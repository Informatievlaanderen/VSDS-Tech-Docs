import requests
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup

def is_dead_link(url):
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            return False
        else:
            return True
    except requests.RequestException:
        return True

def find_dead_links(base_url):
    visited = set()
    dead_links = set()

    def crawl(url):
        if url in visited:
            return
        print('Visiting:', url)
        visited.add(url)
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                soup = BeautifulSoup(response.content, 'html.parser')
                for link in soup.find_all('a', href=True):
                    href = link['href']
                    # Volledige URL construeren indien nodig
                    if not href.startswith('http'):
                        href = urljoin(url, href)
                    # Controleer of de URL binnen hetzelfde domein valt
                    if urlparse(href).netloc != urlparse(base_url).netloc:
                        continue
                    if href not in visited:
                        if is_dead_link(href):
                            dead_links.add(href)
                            print('Dead link found:', href)
                        else:
                            if "https://informatievlaanderen.github.io/VSDS-Tech-Docs/" in href:
                                crawl(href)
                    else:
                        print('Already visited:', href)

        except requests.RequestException:
            dead_links.add(url)
            print('Dead link due to error:', url)

    crawl(base_url)
    return dead_links

# Replace this URL with the one you want to check
base_url = "https://informatievlaanderen.github.io/VSDS-Tech-Docs/"
dead_links = find_dead_links(base_url)

for link in dead_links:
    print(f"Dead link found: {link}")
