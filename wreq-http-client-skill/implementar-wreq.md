---
description: Implementa o convierte código HTTP a wreq, el cliente HTTP de Python con soporte TLS fingerprinting (JA3/JA4), HTTP/2 y BoringSSL.
---

Usa el cliente HTTP `wreq` para implementar la solicitud indicada por el usuario.

## Modos de uso

### Modo archivo
Si el usuario indica un archivo (ej. `en archivo test.py`, `convierte main.py`):
1. Lee el archivo completo.
2. Detecta todas las llamadas HTTP hechas con cualquier cliente: `requests`, `httpx`, `aiohttp`, `urllib`, `http.client`, `pycurl`, comandos `curl` embebidos en strings o `subprocess`, u otros.
3. Reemplaza cada llamada por su equivalente en wreq, preservando método, URL, headers, body, cookies, proxies y timeouts.
4. Añade el import de wreq al inicio si no existe. Elimina imports de clientes reemplazados si ya no se usan.
5. Escribe los cambios directamente en el archivo.
6. No modifiques los permisos del archivo existente.
7. Muestra un resumen de cuántas llamadas fueron transformadas y de qué cliente venían.

### Modo directo
Si el usuario pega un CURL o describe una solicitud, genera el código wreq equivalente y guárdalo en un archivo `.py` nuevo. Dale permisos de ejecución con `chmod +x <archivo>` solo porque es un archivo nuevo.

---

Sigue estas reglas:

## Instalación requerida

```
pip install wreq
```

## requirements.txt

Siempre, antes de escribir cualquier código:
1. Busca `requirements.txt` en el directorio raíz del proyecto.
2. Si existe, verifica que `wreq` esté listado. Si no está, agrégalo.
3. Si no existe, créalo con `wreq` como única entrada.

## Reglas de implementación

- Usa siempre el cliente asíncrono (`Client`) salvo que el usuario pida explícitamente uno bloqueante (disponible en `wreq.blocking`).
- Especifica siempre un `emulation` para controlar el fingerprint TLS/HTTP2. Por defecto usa `Emulation.Firefox149` salvo que el contexto indique otro navegador o cliente.
- Si el usuario pasa un CURL, extrae: método, URL, headers, body, cookies y proxies, y mapéalos fielmente a wreq.
- Preserva el orden original de los headers (`orig_headers=True`) si el contexto lo requiere (ej. bypass de bot detection).
- Para proxies, usa el parámetro `proxies={"http": "...", "https": "..."}`.

## Estructura base

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

## Ejemplos de referencia

Consulta https://github.com/0x676e67/wreq-python/tree/main/examples para casos de uso como:

- `blocking/` — cliente síncrono
- `proxy.py` — proxies rotativos
- `orig_headers.py` — preservación de orden de headers
- `multipart.py`, `form.py`, `json.py` — tipos de body
- `http1_websocket.py`, `http2_websocket.py` — WebSocket
- `stream.py` — streaming
- `emulation.py` — fingerprints disponibles

Documentación oficial: https://python.wreq.org/en/latest/
Deep Wiki técnico: https://deepwiki.com/0x676e67/wreq-python
