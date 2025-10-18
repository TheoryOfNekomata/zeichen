import { Icon } from '~/components/Icon';
import type { Route } from './+types/my.notes';

export const loader = async () => {
	return {
		appName: process.env.APP_NAME ?? '',
		session: {
			publicId: 1,
			username: 'TheoryOfNekomata',
		},
	};
};

export const meta = ({ loaderData }: Route.MetaArgs) => {
	return [
		{
			title: `My Notes | ${loaderData.appName}`,
		},
		{
			name: 'description',
			content: 'My Notes!',
		},
	];
};

const MyNotesPage = ({ loaderData }: Route.ComponentProps) => {
	return (
		<div className="w-[1920px] h-[1080px] relative bg-lt-negative dark:bg-dk-negative text-lt-positive dark:text-dk-positive inline-flex flex-col justify-start items-center">
			<div className="w-[640px] h-[1080px] left-0 top-0 absolute bg-lt-soften dark:bg-dk-soften/30">
				<div className="w-[640px] h-12 left-0 top-[320px] absolute opacity-25 bg-lt-primary dark:bg-dk-primary" />
				<div className="w-2 h-12 left-0 top-[320px] absolute bg-lt-primary dark:bg-dk-primary" />
			</div>
			<div className="w-full flex-1 max-w-[1440px] inline-flex justify-start items-start">
				<div className="w-96 self-stretch inline-flex flex-col justify-between items-center">
					<div className="self-stretch flex flex-col justify-start items-center">
						<div className="self-stretch pb-16 flex flex-col justify-start items-start">
							<div className="self-stretch px-8 py-4 flex flex-col justify-start items-start">
								<div className="self-stretch justify-start text-lt-positive-200 dark:text-dk-positive-200 text-5xl font-light font-['Bevellier_Variable'] lowercase leading-[48px]">
									{loaderData.appName}
								</div>
								<div className="self-stretch justify-start text-lt-primary dark:text-dk-primary text-6xl font-extralight font-['Bevellier_Variable'] leading-[64px]">
									Main Notes
								</div>
							</div>
						</div>
						<div className="self-stretch pl-8 pr-4 pb-8 inline-flex justify-between items-start">
							<div className="size- flex justify-start items-center gap-4">
								<button
									type="button"
									className="h-12 pl-3 pr-4 bg-lt-primary dark:bg-dk-primary text-lt-negative dark:text-dk-negative rounded-sm flex justify-center items-center gap-3 overflow-hidden"
								>
									<Icon name="file-plus" />
									<span className="justify-start text-base font-bold font-['Encode_Sans'] uppercase leading-none">
										New
									</span>
								</button>
								<button
									type="button"
									className="text-lt-primary dark:text-dk-primary size-12 flex justify-center items-center overflow-hidden"
								>
									<Icon name="search" />
								</button>
							</div>
							<div className="text-lt-primary dark:text-dk-primary size-12 flex justify-center items-center">
								<Icon name="more-vertical" />
							</div>
						</div>
						<div className="self-stretch flex flex-col justify-start items-start">
							<div className="self-stretch h-8 px-8 opacity-50 flex flex-col justify-center items-start gap-2.5">
								<div className="justify-start text-lt-positive-200 dark:text-dk-positive-200 text-xs font-bold font-['Encode_Sans'] leading-none">
									2025-10-04
								</div>
							</div>
							<div className="self-stretch flex flex-col justify-start items-start">
								<div className="self-stretch h-12 pl-10 pr-8 flex flex-col justify-center items-start gap-2.5">
									<div className="justify-start text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] leading-normal">
										Tesseract design details
									</div>
								</div>
								<div className="self-stretch h-12 px-8 flex flex-col justify-center items-start gap-2.5">
									<div className="justify-start text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] leading-normal">
										Okashi programming language
									</div>
								</div>
								<div className="self-stretch h-12 px-8 flex flex-col justify-center items-start gap-2.5">
									<div className="justify-start text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] leading-normal">
										Music composition principles
									</div>
								</div>
							</div>
						</div>
					</div>
					<div className="self-stretch p-8 inline-flex justify-between items-center overflow-hidden">
						<div className="size- flex justify-start items-center gap-2">
							<img
								className="size-12 rounded-3xl"
								alt={loaderData.session.username}
								src="https://placehold.co/48x48"
							/>
							<div className="justify-center text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] leading-normal">
								{loaderData.session.username}
							</div>
						</div>
						<div className="text-lt-primary dark:text-dk-primary size-12 flex justify-center items-center overflow-hidden">
							<Icon name="settings" />
						</div>
					</div>
				</div>
				<div className="flex-1 self-stretch py-8 inline-flex flex-col justify-start items-start">
					<div className="self-stretch h-24 px-16 pb-8 flex flex-col justify-center items-start">
						<input
							className="w-full block justify-center text-lt-positive-200 dark:text-dk-positive-200 text-5xl font-light font-['Bevellier_Variable'] leading-[48px]"
							defaultValue="Tesseract design details"
						/>
						<div className="size- opacity-50 inline-flex justify-start items-center gap-2">
							<div className="text-center justify-center text-lt-positive-200 dark:text-dk-positive-200 text-xs font-normal font-['Encode_Sans'] leading-none">
								Saturday, 4 October 2025
							</div>
							<div className="size-1 bg-blend-overlay bg-lt-positive-200 dark:bg-dk-positive-200 rounded-full" />
							<div className="text-center justify-center text-lt-positive-200 dark:text-dk-positive-200 text-xs font-normal font-['Encode_Sans'] leading-none">
								13:32 (UTC+8)
							</div>
						</div>
					</div>
					<div className="self-stretch px-16 inline-flex justify-start items-start gap-2">
						<div className="h-8 inline-flex flex-col justify-center items-center">
							<div className="size-2 opacity-50 bg-blend-overlay bg-lt-positive-200 dark:bg-dk-positive-200 rounded-full" />
						</div>
						<div className="flex-1 py-1 flex justify-center items-center">
							<div className="flex-1 justify-center text-lt-positive-200 dark:text-dk-positive-200 text-base font-normal font-['Encode_Sans'] leading-normal">
								The Tesseract design principles are based on consistency and
								conciseness.
							</div>
						</div>
					</div>
					<div className="self-stretch pl-20 pr-16 inline-flex justify-start items-start gap-2">
						<div className="h-8 inline-flex flex-col justify-center items-center">
							<div className="size-2 opacity-50 bg-blend-overlay bg-lt-positive-200 dark:bg-dk-positive-200 rounded-full" />
						</div>
						<div className="flex-1 py-1 flex justify-center items-center">
							<div className="flex-1 justify-center">
								<span className="text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] underline leading-normal">
									Consistency
								</span>
								<span className="text-lt-positive-200 dark:text-dk-positive-200 text-base font-normal font-['Encode_Sans'] leading-normal">
									{' '}
									is being able to enforce standards and keep related aspects
									similar in perception.
								</span>
							</div>
						</div>
					</div>
					<div className="self-stretch pl-20 pr-16 inline-flex justify-start items-start gap-2">
						<div className="h-8 inline-flex flex-col justify-center items-center">
							<div className="size-2 opacity-50 bg-blend-overlay bg-lt-positive-200 dark:bg-dk-positive-200 rounded-full" />
						</div>
						<div className="flex-1 py-1 flex justify-center items-center">
							<div className="flex-1 justify-center">
								<span className="text-lt-primary dark:text-dk-primary text-base font-bold font-['Encode_Sans'] underline leading-normal">
									Conciseness
								</span>
								<span className="text-lt-positive-200 dark:text-dk-positive-200 text-base font-normal font-['Encode_Sans'] leading-normal">
									{' '}
									is having to stick to a short definition of concepts.
								</span>
							</div>
						</div>
					</div>
					<div className="self-stretch flex flex-col justify-start items-start">
						<div className="self-stretch h-8 pl-24 pr-16 inline-flex justify-start items-center gap-2">
							<div className="size-2 opacity-50 bg-blend-overlay bg-lt-positive-200 dark:bg-dk-positive-200 rounded-full" />
							<div className="text-center justify-center text-lt-positive-200 dark:text-dk-positive-200 text-base font-normal font-['Encode_Sans'] leading-normal">
								Sample video on conciseness
							</div>
						</div>
						<div className="self-stretch pl-28 pr-16 flex flex-col justify-center items-start">
							<div className="w-72 h-40 bg-neutral-600" />
						</div>
					</div>
				</div>
				<div className="w-96 self-stretch relative">
					<div className="w-96 left-0 top-[186px] absolute inline-flex justify-start items-center gap-4">
						<div className="w-96 h-12 left-0 top-0 absolute opacity-10 bg-lt-primary dark:bg-dk-primary" />
						<div className="w-1 h-12 bg-slate-400" />
						<div className="flex-1 inline-flex flex-col justify-start items-start gap-1">
							<div className="self-stretch inline-flex justify-start items-center gap-2">
								<img
									className="size-4 rounded-lg"
									alt="TheoryOfNekomata"
									src="https://placehold.co/16x16"
								/>
								<div className="justify-center text-lt-primary dark:text-dk-primary text-xs font-bold font-['Encode_Sans'] leading-none">
									TheoryOfNekomata
								</div>
								<div className="flex-1 justify-center text-lt-primary dark:text-dk-primary text-xs font-normal font-['Encode_Sans'] leading-none">
									2h ago
								</div>
							</div>
							<div className="self-stretch justify-center text-lt-primary dark:text-dk-primary text-xs font-normal font-['Encode_Sans'] leading-none">
								Add link to standards here.
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};

export default MyNotesPage;
