---
name: svg-preview-components
description: Use when building or modifying SVG-based preview components that need to embed React/HTML components (logos, buttons, design system elements) inside an SVG viewBox, or when converting raw Figma SVG exports into componentized React code.
---

# SVG Preview Components

Patterns for embedding HTML components inside SVG previews and making SVG elements adaptive to dynamic content.

## When to Use

- Embedding React/HTML components (BrandingAvatar, Spot, kiwi Button) inside an `<svg>`
- Converting Figma SVG exports to React components
- Making SVG text/buttons adapt to translated content
- Componentizing large SVG previews into maintainable pieces

## Core Patterns

### 1. HTML inside SVG via `foreignObject`

HTML elements (`<img>`, `<div>`) are invisible inside `<svg>`. Wrap them in `<foreignObject>`.

```tsx
// Position and size the foreignObject to match the original SVG element's bounding box
<foreignObject x="217" y="12" width="32" height="32">
  <BrandingAvatar logo={logo.url} logoLayout={logo.layout} />
</foreignObject>
```

**Sizing tip:** match the `foreignObject` dimensions to the original SVG element's bounding box. Use `css` prop on the inner component if it doesn't fit.

### 2. Noisy/Complex Illustrations via `Spot`

When the SVG contains an illustration with noise filters (`feTurbulence`, `fractalNoise`) and complex gradients (multiple `linearGradient`/`radialGradient`), replace the entire block with the `Spot` component from `@yousign/icons`. This avoids hundreds of lines of SVG filter/gradient definitions.

```tsx
import { Spot } from '@yousign/icons';

// Replace the noisy SVG badge + all its <defs> filters/gradients with:
<foreignObject x="203" y="78" width="50" height="50">
  <Spot name="bright_success" css={{ width: 50, height: 50 }} />
</foreignObject>
```

**When to use Spot:** presence of `feTurbulence`, `feComponentTransfer`, `feFuncA tableValues`, or 3+ gradient definitions for a single illustration. These are noise textures from Figma — `Spot` renders the same illustration from CDN.

**Cleanup:** remove the now-unused `<filter>` and `<linearGradient>`/`<radialGradient>` entries from `<defs>`.

### 3. Adaptive SVG Button via `getBBox()`

For buttons whose text changes (translations), measure the `<text>` with `getBBox()` and size the `<rect>` around it.

```tsx
const Button = () => {
  const textRef = React.useRef<SVGTextElement>(null);
  const [bbox, setBbox] = React.useState({ width: 50, height: 10 });

  React.useEffect(() => {
    if (textRef.current) {
      const b = textRef.current.getBBox();
      setBbox({ width: b.width, height: b.height });
    }
  }, [t]);

  const paddingX = 16;
  const paddingY = 10;
  const centerX = 229; // center of viewBox
  const centerY = 120;
  const rectW = bbox.width + paddingX * 1.5;
  const rectH = bbox.height + paddingY * 1.5;

  return (
    <>
      <rect
        x={centerX - rectW / 2}
        y={centerY - rectH / 2}
        width={rectW}
        height={rectH}
        rx={4}
        fill={colors.backgroundButton}
      />
      <text
        ref={textRef}
        fill={colors.textButton}
        textAnchor="middle"
        dominantBaseline="central"
        x={centerX}
        y={centerY}
        fontFamily="Neue Haas Unica W1G"
        fontSize="7.53"
        letterSpacing="0.08em"
        style={{ textTransform: 'uppercase' }}
      >
        {t('label.start')}
      </text>
    </>
  );
};
```

**With icon:** offset `textX` by `iconWidth + gap`, wrap icon paths in `<g transform="translate(...)">`.

### 4. Centered SVG Text

Replace hardcoded `<tspan x="154">` with `textAnchor="middle"` + `x={center}`.

```tsx
// Before (breaks on translation)
<text><tspan x="154.377" y="69.21">{t('...')}</tspan></text>

// After (always centered)
<text textAnchor="middle" x="229" y="69.21">{t('...')}</text>
```

### 5. Conditional Layout with `transform`

For elements that need to reposition (e.g., document centering when sidebar hides):

```tsx
const DocumentPlaceholder = ({ centered }: { centered?: boolean }) => {
  const translateX = centered ? -51.5 : 0;
  return (
    <g filter="url(#filter)" transform={`translate(${translateX}, 0)`}>
      {/* paths */}
    </g>
  );
};
```

## Figma SVG Cleanup Checklist

### JSX Attribute Conversion

| SVG | JSX |
|-----|-----|
| `fill-rule` | `fillRule` |
| `clip-rule` | `clipRule` |
| `stroke-width` | `strokeWidth` |
| `font-family` | `fontFamily` |
| `font-size` | `fontSize` |
| `letter-spacing` | `letterSpacing` |
| `stop-color` | `stopColor` |
| `stop-opacity` | `stopOpacity` |
| `flood-opacity` | `floodOpacity` |
| `flood-color` | `floodColor` |
| `color-interpolation-filters` | `colorInterpolationFilters` |

### Remove Unnecessary Attributes

- `xml:space="preserve"` (deprecated in SVG 2)
- `style="white-space: pre"` / `style={{ whiteSpace: 'pre' }}` (redundant for simple text)
- `letterSpacing="0px"` (default value)

### Componentization Strategy

Extract into named components by visual role:

| Component | Pattern |
|-----------|---------|
| Logo | `foreignObject` + `BrandingAvatar` |
| Illustration with noise | `foreignObject` + `Spot` |
| Button | `getBBox()` adaptive rect + text |
| Title/Subtitle | `textAnchor="middle"` centered text |
| Sidebar | Standalone `<>...</>` fragment |
| Document | `<g>` with optional `transform` for centering |

Keep `<defs>` (filters, gradients) in the main exported component. Remove unused defs when replacing SVG elements with HTML components.

## Common Mistakes

- Forgetting `foreignObject` dimensions — the inner HTML component clips if the box is too small
- Using `getBBox()` without `useEffect` dependency on `t` (translation function) — won't remeasure on language change
- Leaving orphaned `<defs>` filters/gradients after replacing SVG elements with components
- Not removing the Figma noise attributes during conversion
- Keeping noisy SVG (feTurbulence + gradients) when `Spot` exists for the same illustration
