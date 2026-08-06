# Microbiota, *Clostridioides difficile* y Trasplante de Microbiota Fecal (TMF)

Web informativa institucional del **Hospital General Universitario Gregorio Marañón** (Madrid)
sobre microbiota intestinal, infección por *Clostridioides difficile*, Trasplante de Microbiota
Fecal (TMF), donación de heces y la actividad del hospital en esta área.

Código de proyecto: **PI20/01381**

## Publicación

El sitio tiene dos entornos:

| Entorno | URL | Se actualiza |
|---|---|---|
| **Producción** (Netlify) | <https://microbiota-hgugm.netlify.app/> | Ejecutando `desplegar-netlify.ps1` |
| Pruebas (GitHub Pages) | <https://jmorecru.github.io/pagina-web-microbiota-tmf/> | Automáticamente en cada `push` |

Netlify es el entorno **definitivo**: las etiquetas `canonical`, `og:url` y `og:image` de las
siete páginas apuntan ahí. Eso significa que la copia de GitHub Pages declara a Netlify como
versión oficial, de modo que ambas pueden coexistir sin competir en los buscadores.

### Desplegar en Netlify

El despliegue **no está conectado a GitHub** a propósito: el repositorio pertenece a una cuenta
que forma parte de una organización empresarial, y este es un proyecto personal, así que no se
autoriza ninguna aplicación de terceros sobre esa cuenta. En su lugar se sube el sitio
directamente a la API de Netlify con `desplegar-netlify.ps1`.

Requiere un token personal de Netlify (*User settings → Applications → Personal access tokens*),
en una variable de entorno para que no quede escrito en ningún fichero:

```powershell
$env:NETLIFY_AUTH_TOKEN = "el-token"
```

```powershell
# Primera vez: crea el sitio y lo despliega
.\desplegar-netlify.ps1 -CrearSitio -Nombre "microbiota-hgugm"

# Veces siguientes
.\desplegar-netlify.ps1

# Ver los sitios de la cuenta
.\desplegar-netlify.ps1 -Listar
```

El identificador del sitio se guarda en `.netlify-site-id`, que está excluido del repositorio.

La configuración vive en `netlify.toml`, así que **no hay que tocar nada en el panel de Netlify**:
define la raíz como directorio a publicar, desactiva la reescritura de URL, y añade cabeceras de
seguridad (CSP estricta, sin JavaScript ni orígenes externos) y política de caché.

### No indexable de forma provisional

Las siete páginas incluyen `<meta name="robots" content="noindex, nofollow">` para que los
buscadores no las rastreen mientras el contenido no esté aprobado por el hospital.

Para publicar de forma definitiva hay que eliminar **tres cosas**:

1. La etiqueta `<meta name="robots">` de los **siete** ficheros HTML.
2. La cabecera `X-Robots-Tag` de `netlify.toml`.
3. Y revisar las URL canónicas (ver el punto 5 de *Pendiente*).

## Estructura

Sitio estático en HTML plano, sin proceso de compilación ni dependencias externas.

```
.
├── estilo.css                        # Hoja de estilos compartida por las 7 páginas
├── index.html                        # Portada: presentación y acceso a las 6 secciones
├── microbiota.html
├── clostridioides-difficile.html
├── trasplante-microbiota-fecal.html
├── actividad-hospital.html
├── donacion-de-heces.html
├── profesionales.html
└── images/                           # Fotografías y logotipos (10 archivos, ~1,1 MB)
```

### Al editar, ten en cuenta

Al ser HTML plano sin plantillas, **la cabecera, la banda de logotipos, el menú y el pie están
duplicados en las siete páginas**. Si modificas uno de esos bloques, hay que replicar el cambio
en todas. Lo mismo aplica a la etiqueta `noindex`.

En el menú, la página activa se marca con `aria-current="page"`, que además le da el fondo azul.
Al copiar el menú de una página a otra hay que mover esa marca al enlace correspondiente.

## Infografías

Las seis infografías están construidas en **HTML y SVG**, no son imágenes. Sustituyen a seis
JPEG generados con IA que llevaban el sello visible «Made with AI» y faltas de ortografía
incrustadas en el píxel. Al ser texto real son accesibles, escalables, indexables y se corrigen
editando una línea.

Los iconos provienen de un sprite de `<symbol>` SVG definido al principio del `<body>`. Cada
página incluye **solo los iconos que usa**, de modo que un mismo icono puede aparecer definido
en varias páginas: si se retoca un trazo, hay que buscarlo en todas.

Las imágenes sustituidas siguen recuperables desde el historial de Git (commit `339b82a`).

## Desarrollo local

No requiere instalación. Puedes abrir `index.html` en el navegador, aunque es preferible
servirlo para que las rutas se comporten igual que en producción:

```powershell
python -m http.server 8000
```

y visitar <http://localhost:8000>.

## Pendiente

1. **Enlaces de contacto muertos.** Los de *Donación de heces* y *Profesionales sanitarios*
   apuntan a `#`; falta conectarlos al formulario o buzón de correo definitivo. Están marcados
   con un comentario `<!-- PENDIENTE -->`.
2. **Confirmar la dirección del hospital.** La infografía de actividad indica solo
   «Madrid · Metro O'Donnell»; conviene completarla con la dirección exacta y la forma de acceso.
3. **Sustituir `images/hgugm-foto.png`.** Parece una captura de Google Earth; su uso público
   exige atribución y tiene restricciones. Conviene una fotografía propia del hospital.
4. **Aprobación institucional.** La web se presenta como institucional del HGUGM y usa sus
   logotipos y los de UCM, IiSGM y FEDER; requiere el visto bueno de esas entidades antes de
   difundirse y antes de retirar el `noindex`.
5. **Dominio propio (opcional).** Si en algún momento se apunta un dominio propio al sitio de
   Netlify, hay que actualizar las URL absolutas de las siete páginas: `canonical`, `og:url` y
   `og:image`, cuatro por página. Basta un reemplazo de
   `https://microbiota-hgugm.netlify.app/` por el nuevo dominio.

## Créditos

Hospital General Universitario Gregorio Marañón · Universidad Complutense de Madrid · IiSGM ·
Fondo Europeo de Desarrollo Regional (FEDER).
