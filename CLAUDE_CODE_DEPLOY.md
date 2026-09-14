# Penas LAM - ultimo paso de despliegue

El backend de Supabase YA existe y YA fue configurado. No crear otro proyecto y no modificar el contenido juridico de `ARTICULOS`.

## Netlify existente
- Site name: `penas-lam`
- Site ID: `94fc71d7-28be-4be5-be23-e2b7631c27d2`
- URL objetivo: `https://penas-lam.netlify.app`

## Supabase existente
- Project name: `penas-lam`
- Project ref: `ycjlozcqwwbrfgyibbnh`
- Region: `us-east-1`
- Schema y RLS ya aplicados.


## Regla del examen
- NO generar preguntas sobre si una pena es conmutable o inconmutable.
- La inconmutabilidad puede seguir visible en fichas, tabla y texto legal porque forma parte de la fuente.
- Para calificar penas en el examen, no usar la palabra "inconmutable" como criterio ni como distractor.

## Instruccion para Claude Code
Desde esta carpeta, despliega ESTOS archivos tal como estan al sitio Netlify existente. No alteres `ARTICULOS` ni ninguna pena, cifra, agravante, multa, comiso, suspension o cancelacion.

Comando sugerido si Netlify CLI esta autenticado:

```sh
npx netlify-cli deploy --prod --dir=. --site 94fc71d7-28be-4be5-be23-e2b7631c27d2
```

Si requiere autenticacion, iniciar sesion con Netlify y repetir el comando.

Al terminar, verificar:
1. `https://penas-lam.netlify.app` responde 200.
2. Cargan `manifest.webmanifest`, `sw.js` e `icon.svg`.
3. En Ajustes > Sincronizacion se muestra que Supabase ya esta configurado.
4. Crear/iniciar sesion y comprobar que una respuesta se sincroniza en `article_progress`.
5. No introducir dependencias externas ni backend adicional.
