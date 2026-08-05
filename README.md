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

El sitio se publica automáticamente mediante **GitHub Pages** desde la rama `main`.

## Pendiente

- Los enlaces de contacto de las secciones *Donación de heces* y *Profesionales sanitarios*
  apuntan a `#`; falta conectarlos al formulario o buzón de correo definitivo.

## Créditos

Hospital General Universitario Gregorio Marañón · Universidad Complutense de Madrid · IiSGM ·
Fondo Europeo de Desarrollo Regional (FEDER).
