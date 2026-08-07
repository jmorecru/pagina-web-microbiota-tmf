# Microbiota, *Clostridioides difficile* y Trasplante de Microbiota Fecal (TMF)

Web informativa institucional del **Hospital General Universitario Gregorio Marañón** (Madrid)
sobre microbiota intestinal, infección por *Clostridioides difficile*, Trasplante de Microbiota
Fecal (TMF), donación de heces y la actividad del hospital en esta área.

Código de proyecto: **PI20/01381**

## Publicación

<https://jmorecru.github.io/pagina-web-microbiota-tmf/>

Se publica mediante **GitHub Pages** desde la rama `main`: cada `push` actualiza el sitio en un
minuto aproximadamente. Las etiquetas `canonical`, `og:url` y `og:image` de las siete páginas
apuntan a esta dirección.

### Netlify: preparado, pero sin activar

El repositorio incluye todo lo necesario para desplegar también en Netlify, pero **no está en
uso**. Se dejó listo y luego se decidió quedarse en GitHub Pages. Los ficheros implicados no
tienen ningún efecto sobre GitHub Pages, así que se conservan por si se retoma:

- **`netlify.toml`** — configuración completa: directorio a publicar, cabeceras de seguridad
  (CSP estricta, sin JavaScript ni orígenes externos), política de caché y desactivación de la
  reescritura de URL, para que las direcciones sean idénticas en ambos entornos.
- **`desplegar-netlify.ps1`** — sube el sitio a la API de Netlify **sin conectar la cuenta de
  GitHub**, usando únicamente un token personal de Netlify. Se tomó esta vía a propósito: la
  cuenta de GitHub forma parte de una organización empresarial y este es un proyecto personal,
  así que no se autoriza ninguna aplicación de terceros sobre ella.

Si algún día se activa:

```powershell
$env:NETLIFY_AUTH_TOKEN = "el-token"   # User settings -> Applications -> Personal access tokens
.\desplegar-netlify.ps1 -CrearSitio -Nombre "microbiota-hgugm"
```

Y hay que **actualizar las URL absolutas** de las siete páginas (`canonical`, `og:url`,
`og:image` y `twitter:image`; cuatro por página) al dominio de Netlify, además de decidir cuál de
los dos entornos es el oficial para no tener dos copias compitiendo en los buscadores. Basta un
reemplazo de `https://jmorecru.github.io/pagina-web-microbiota-tmf/` por el dominio nuevo.

### No indexable de forma provisional

Las siete páginas incluyen `<meta name="robots" content="noindex, nofollow">` para que los
buscadores no las rastreen mientras el contenido no esté aprobado por el hospital.

Para publicar de forma definitiva hay que eliminar la etiqueta `<meta name="robots">` de los
**siete** ficheros HTML. Si en algún momento se usa Netlify, también la cabecera `X-Robots-Tag`
de `netlify.toml`.

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
4. **Aprobación institucional.** La web se presenta como institucional del HGUGM y usa su
   logotipo y los del Ministerio de Ciencia, Innovación y Universidades, el Instituto de Salud
   Carlos III, la Unión Europea, FEDER e IiSGM; requiere el visto bueno de esas entidades antes
   de difundirse y antes de retirar el `noindex`.
5. **Doble bandera de la Unión Europea.** La tira institucional ya incluye el emblema de la UE, y
   el logotipo de FEDER lo lleva también, así que aparecen dos veces en la misma fila. Suele ser
   un requisito de ambas fuentes de financiación, pero conviene confirmarlo con quien gestiona el
   proyecto.

## Créditos

Hospital General Universitario Gregorio Marañón · Instituto de Salud Carlos III · Ministerio de
Ciencia, Innovación y Universidades · Unión Europea · IiSGM · Fondo Europeo de Desarrollo
Regional (FEDER).

Los logotipos aparecen en la banda blanca bajo la cabecera, repartidos en dos filas: arriba el
del hospital, como entidad que publica, junto al código de proyecto; abajo los de financiación.
La tira institucional (`logo-ministerio-isciii.png`, 592×69) se muestra **a tamaño nativo**: su
texto es muy pequeño y reducirla para encajarla en una sola fila con el resto la dejaría
ilegible. En pantallas estrechas se reduce proporcionalmente, que es inevitable con una imagen
de proporción 8,6:1.
