import type * as React from 'react';

const ICONS = {
	'search': (etcProps: React.SVGProps<SVGElementTagNameMap['svg']>) => (
		<svg
			{...etcProps}
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth="2"
			strokeLinecap="round"
			strokeLinejoin="round"
			className="w-6 h-6"
		>
			<title>search</title>
			<circle
				cx="11"
				cy="11"
				r="8"
			/>
			<line
				x1="21"
				y1="21"
				x2="16.65"
				y2="16.65"
			/>
		</svg>
	),
	'file-plus': (etcProps: React.SVGProps<SVGElementTagNameMap['svg']>) => (
		<svg
			{...etcProps}
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth="2"
			strokeLinecap="round"
			strokeLinejoin="round"
			className="w-6 h-6"
		>
			<title>file-plus</title>
			<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
			<polyline points="14 2 14 8 20 8" />
			<line
				x1="12"
				y1="18"
				x2="12"
				y2="12"
			/>
			<line
				x1="9"
				y1="15"
				x2="15"
				y2="15"
			/>
		</svg>
	),
	'more-vertical': (etcProps: React.SVGProps<SVGElementTagNameMap['svg']>) => (
		<svg
			{...etcProps}
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth="2"
			strokeLinecap="round"
			strokeLinejoin="round"
			className="w-6 h-6"
		>
			<title>more-vertical</title>
			<circle
				cx="12"
				cy="12"
				r="1"
			/>
			<circle
				cx="12"
				cy="5"
				r="1"
			/>
			<circle
				cx="12"
				cy="19"
				r="1"
			/>
		</svg>
	),
	'settings': (etcProps: React.SVGProps<SVGElementTagNameMap['svg']>) => (
		<svg
			{...etcProps}
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth="2"
			strokeLinecap="round"
			strokeLinejoin="round"
			className="w-6 h-6"
		>
			<title>settings</title>
			<circle
				cx="12"
				cy="12"
				r="3"
			/>
			<path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
		</svg>
	),
} as const;

export type IconName = keyof typeof ICONS;

export interface IconProps extends React.SVGProps<SVGElementTagNameMap['svg']> {
	name: IconName;
}

export const Icon: React.FC<IconProps> = ({ name, ...etcProps }) => {
	const { [name]: IconComponent } = ICONS;
	return <IconComponent {...etcProps} />;
};
