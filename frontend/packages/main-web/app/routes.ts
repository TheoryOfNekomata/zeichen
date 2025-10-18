import { index, type RouteConfig, route } from '@react-router/dev/routes';

export default [
	index('routes/index.ts'),
	route('/my/notes', 'routes/my.notes.tsx'),
] satisfies RouteConfig;
