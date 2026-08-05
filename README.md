# Microbiota, *Clostridioides difficile* y Trasplante de Microbiota Fecal (TMF)

Web informativa institucional del **Hospital General Universitario Gregorio Marañón** (Madrid)
sobre microbiota intestinal, infección por *Clostridioides difficile*, Trasplante de Microbiota
Fecal (TMF), donación de heces y la actividad del hospital en esta área.

Código de proyecto: **PI20/01381**

## Contenido

Sitio estático de una sola página (`index.html`) con CSS embebido, sin dependencias externas ni
proceso de compilación. Secciones:

| Sección | Ancla |
|---|---|
| Microbiota, microbioma y salud intestinal | `#microbiota` |
| Infección por *Clostridioides difficile* | `#cdiff` |
| Trasplante de Microbiota Fecal (TMF) | `#tmf` |
| Actividad del HGUGM | `#hgugm` |
| Donación de heces | `#donacion` |
| Información para profesionales sanitarios | `#profesionales` |

## Estructura

```
.
├── index.html          # Página completa (estilos embebidos)
└── images/             # Fotografías, infografías y logotipos (16 archivos)
```

## Desarrollo local

No requiere instalación. Basta abrir `index.html` en el navegador, o servirlo con:

```powershell
python -m http.server 8000
```

y visitar <http://localhost:8000>.

## Publicación

El sitio se publica automáticamente mediante **GitHub Pages** desde la rama `main`:
<https://jmorecru.github.io/pagina-web-microbiota-tmf/>

> **No indexable de forma provisional.** El `<head>` incluye
> `<meta name="robots" content="noindex, nofollow">` para que los buscadores no lo rastreen
> mientras el contenido no esté aprobado por el hospital. Para publicar de forma definitiva,
> basta eliminar esa línea.

## Pendiente

1. **Enlaces de contacto muertos.** Los de *Donación de heces* y *Profesionales sanitarios*
   apuntan a `#`; falta conectarlos al formulario o buzón de correo definitivo. Están marcados
   con un comentario `<!-- PENDIENTE -->` en `index.html`.
2. **Rehacer 6 infografías.** Las seis `images/infografia-*` están generadas con IA: llevan el
   sello visible «Made with AI» y contienen faltas de ortografía incrustadas en la imagen
   («Microorgansimos», «Inmundad», «Recouración», «Procedimeinto», «Sonde Nasogastrica»,
   «¿Qúe es el TMF?», entre otras). La de HGUGM además dibuja un edificio inventado y sitúa el
   hospital en el «Barrio de Salamanca» (está en el distrito de Retiro).
3. **Sustituir `images/hgugm-foto.png`.** Parece una captura de Google Earth; su uso público
   exige atribución y tiene restricciones. Conviene una fotografía propia del hospital.
4. **Aprobación institucional.** La web se presenta como institucional del HGUGM y usa sus logos
   y los de UCM, IiSGM y FEDER; requiere el visto bueno de esas entidades antes de difundirse.
5. **Optimizar imágenes.** Convertir las infografías a WebP reduciría el peso actual (~1,8 MB)
   en torno a un 60 %.

## Créditos

Hospital General Universitario Gregorio Marañón · Universidad Complutense de Madrid · IiSGM ·
Fondo Europeo de Desarrollo Regional (FEDER).
