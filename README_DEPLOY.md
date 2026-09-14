# Penas LAM - listo para Netlify + Supabase

## Publicar rápido en Netlify
1. Entra a Netlify y crea un sitio con **Deploy manually**.
2. Arrastra la carpeta completa `penas_lam_netlify` o el ZIP incluido.
3. Netlify publicará `index.html`.

## Activar sincronización entre dispositivos
1. Crea un proyecto en Supabase.
2. Abre SQL Editor y ejecuta `supabase.sql`.
3. En Authentication, habilita Email/Password. Para uso personal puedes decidir si requieres confirmación de correo.
4. Abre la app > Ajustes > Configurar / sincronizar.
5. Pega el **Project URL** y la **Publishable/anon key**. No uses service_role.
6. Crea usuario o inicia sesión.
7. Pulsa “Sincronizar ahora”. En otro equipo inicia sesión y pulsa “Traer de nube”.

## Offline
La app usa localStorage y service worker. Después de abrirla al menos una vez desde Netlify, puede cargar sin conexión y conservar el progreso local.

## Fuente jurídica
ARTICULOS 99–138 fue estructurado a partir del PDF adjunto al proyecto. La app está orientada a memorización de examen, no a interpretación jurídica.
