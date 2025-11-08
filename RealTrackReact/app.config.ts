import type { ExpoConfig } from '@expo/config';

const API_URL = process.env.EXPO_PUBLIC_REALTRACK_API_URL ?? 'http://localhost:5233';

const config: ExpoConfig = {
  name: 'RealTrack Web',
  slug: 'realtrack-web',
  version: '1.0.0',
  orientation: 'portrait',
  platforms: ['web'],
  assetBundlePatterns: ['**/*'],
  web: {
    bundler: 'metro'
  },
  extra: {
    apiUrl: API_URL
  }
};

export default config;
