import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

let viteConfig;
try {
	// https://vitejs.dev/config/
	viteConfig = defineConfig({
	  plugins: [react()],
	  build: {
		outDir: 'dist',
		assetsDir: 'assets',
		sourcemap: true,
	  },
	 
	});
} catch (error) {
  console.error(error);
}

export default viteConfig
