// tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class', // ← Le toggle dark/light fonctionne avec une classe CSS sur <html>
  theme: {
    extend: {
      colors: {
        // Surfaces
        surface: {
          DEFAULT: '#EFF7FE',
          dark: '#060E20',
          raised: {
            DEFAULT: '#FFFFFF',
            dark: '#0D1A30',
          },
          overlay: {
            DEFAULT: '#FAFCFF',
            dark: '#091526',
          },
        },
        // Texte
        primary: {
          DEFAULT: '#283035',
          dark: '#F0F8FF',
        },
        secondary: {
          DEFAULT: '#6B767C',
          dark: '#DBE4EA',
        },
        // CTA
        cta: {
          DEFAULT: '#595A6F',
          dark: '#A6A6E2',
        },
        // Catégories
        'category-ai': {
          bg: '#E0E0F9',
          text: '#2D2D7A',
          accent: '#9799FF',
        },
        'category-web': {
          bg: '#F7DCDE',
          text: '#7A2D35',
          accent: '#FDABD7',
        },
        'category-data': {
          bg: '#DFEAF2',
          text: '#1E4A6B',
          accent: '#2AF8AF',
        },
        'category-infra': {
          bg: '#FFF1E6',
          text: '#7A4820',
          accent: '#FFB476',
        },
      },
      fontFamily: {
        poppins: ['var(--font-poppins)'],
        'space-grotesk': ['var(--font-space-grotesk)'],
        'rubik-bubbles': ['var(--font-rubik-bubbles)'],
      },
    },
  },
  plugins: [],
}

export default config