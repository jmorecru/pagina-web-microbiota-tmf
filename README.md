# Microbiota, *Clostridioides difficile* y Trasplante de Microbiota Fecal (TMF)

Web informativa institucional del **Hospital General Universitario Gregorio Marañón** (Madrid)
sobre microbiota intestinal, infección por *Clostridioides difficile*, Trasplante de Microbiota
Fecal (TMF), donación de heces y la actividad del hospital en esta área.

Código de proyecto: **PI20/01381**

## Publicación

<https://jmorecru.github.io/pagina-web-microbiota-tmf/>

Se publica automáticamente mediante **GitHub Pages** desde la rama `main`: cada `push` actualiza
el sitio en un minuto aproximadamente.

> **No indexable de forma provisional.** Las siete páginas incluyen
> `<meta name="robots" content="noindex, nofollow">` para que los buscadores no las rastreen
> mientras el contenido no esté aprobado por el hospital. Para publicar de forma definitiva, hay
> que eliminar esa línea **en las siete**.

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

## Créditos

Hospital General Universitario Gregorio Marañón · Universidad Complutense de Madrid · IiSGM ·
Fondo Europeo de Desarrollo Regional (FEDER).
