---
description: Implements or converts HTTP code to wreq, the Python HTTP client with TLS fingerprinting (JA3/JA4), HTTP/2, and BoringSSL support.
---

Use the `wreq` HTTP client to implement the request specified by the user.

## Usage modes

### File mode
If the user references a file (e.g. `in file test.py`, `convert main.py`):
1. Read the entire file.
2. Detect all HTTP calls made with any client: `requests`, `httpx`, `aiohttp`, `urllib`, `http.client`, `pycurl`, `curl` commands embedded in strings or `subprocess`, or others.
3. Replace each call with its wreq equivalent, preserving method, URL, headers, body, cookies, proxies, and timeouts.
4. Add the wreq import at the top if it doesn't exist. Remove imports of replaced clients if they are no longer used.
5. Write the changes directly to the file.
6. Do not modify the permissions of the existing file.
7. Show a summary of how many calls were transformed and which client they came from.

### Direct mode
If the user pastes a cURL command or describes a request, generate the equivalent wreq code and save it to a new `.py` file. Grant execution permissions with `chmod +x <file>` only because it is a new file.

---

Follow these rules:

## Required installation

```
pip install wreq
```

## requirements.txt

Always, before writing any code:
1. Look for `requirements.txt` in the root directory of the project.
2. If it exists, verify that `wreq` is listed. If not, add it.
3. If it doesn't exist, create it with `wreq` as the only entry.

## Implementation rules

- Always use the async client (`Client`) unless the user explicitly requests a blocking one (available in `wreq.blocking`).
- Always specify an `emulation` to control the TLS/HTTP2 fingerprint. Default to `Emulation.Firefox149` unless the context indicates another browser or client.
- If the user provides a cURL command, extract: method, URL, headers, body, cookies, and proxies, and map them faithfully to wreq.
- Preserve the original header order (`orig_headers=True`) if the context requires it (e.g. bot detection bypass).
- For proxies, use the `proxies={"http": "...", "https": "..."}` parameter.

## Base structure

```python
import asyncio
from wreq import Client, Emulation


async def main():
    client = Client(emulation=Emulation.Firefox149)
    resp = await client.get("https://example.com")
    print(await resp.text())


if __name__ == "__main__":
    asyncio.run(main())
```

## Reference examples

See https://github.com/0x676e67/wreq-python/tree/main/examples for use cases such as:

- `blocking/` — synchronous client
- `proxy.py` — rotating proxies
- `orig_headers.py` — header order preservation
- `multipart.py`, `form.py`, `json.py` — body types
- `http1_websocket.py`, `http2_websocket.py` — WebSocket
- `stream.py` — streaming
- `emulation.py` — available fingerprints

Official docs: https://python.wreq.org/en/latest/
Technical deep wiki: https://deepwiki.com/0x676e67/wreq-python
