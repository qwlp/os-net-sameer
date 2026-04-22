import {Layout, Rect, Txt, makeScene2D} from '@motion-canvas/2d';
import {all, beginSlide, createRef, waitFor} from '@motion-canvas/core';
import {createSlideFrame, flashHighlight, revealSlideHeader} from './helpers';
import {colors, fonts} from '../styles';

const terms = [
  '1_8',
  '2_8',
  '3_8',
  '4_8',
  '5_8',
  '6_8',
  '7_8',
  '10_8',
  '11_8',
  '12_8',
  '13_8',
  '14_8',
  '15_8',
  '16_8',
  '17_8',
  '20_8',
  '21_8',
  '22_8',
  '23_8',
  '24_8',
];

export default makeScene2D(function* (view) {
  const frame = createSlideFrame(view, 'COUNTING (Exercise a)', 'Count from 1 to 20_10 in base 8');

  const card = createRef<Rect>();
  const lead = createRef<Txt>();
  const tokenRow = createRef<Layout>();
  const milestoneA = createRef<Txt>();
  const milestoneB = createRef<Txt>();

  frame.panel().add(
    <Layout direction={'column'} width={1600} gap={24} marginTop={8}>
      <Rect
        ref={card}
        fill={'#182246'}
        radius={18}
        stroke={colors.line}
        lineWidth={2}
        padding={24}
        layout
        direction={'column'}
        gap={18}
      >
        <Txt
          ref={lead}
          text={'Watch the rollover points: 7_8 -> 10_8 and 17_8 -> 20_8'}
          fontFamily={fonts.primary}
          fill={colors.softText}
          fontSize={36}
          opacity={0}
        />
        <Layout ref={tokenRow} layout wrap={'wrap'} gap={14} width={1500}>
          {terms.map((term, i) => (
            <Txt
              text={i === terms.length - 1 ? term : `${term},`}
              fontFamily={fonts.mono}
              fill={colors.text}
              fontSize={48}
              opacity={0}
            />
          ))}
        </Layout>
      </Rect>
      <Layout direction={'row'} gap={28}>
        <Rect fill={'#1a2a42'} radius={14} padding={18} stroke={colors.line} lineWidth={2}>
          <Txt
            ref={milestoneA}
            text={'Milestone: 7_8 -> 10_8'}
            fontFamily={fonts.primary}
            fill={colors.accentB}
            fontSize={34}
            opacity={0}
          />
        </Rect>
        <Rect fill={'#1a2a42'} radius={14} padding={18} stroke={colors.line} lineWidth={2}>
          <Txt
            ref={milestoneB}
            text={'Milestone: 17_8 -> 20_8'}
            fontFamily={fonts.primary}
            fill={colors.accentC}
            fontSize={34}
            opacity={0}
          />
        </Rect>
      </Layout>
    </Layout>,
  );

  yield* revealSlideHeader(frame);
  yield* beginSlide('counting-intro');
  yield* lead().opacity(1, 0.6);

  yield* beginSlide('counting-first-half');
  for (let i = 0; i <= 9; i++) {
    yield* (tokenRow().children()[i] as Txt).opacity(1, 0.17);
  }
  yield* milestoneA().opacity(1, 0.35);
  yield* flashHighlight(card(), colors.accentB);

  yield* beginSlide('counting-second-half');
  for (let i = 10; i < terms.length; i++) {
    yield* (tokenRow().children()[i] as Txt).opacity(1, 0.17);
  }
  yield* milestoneB().opacity(1, 0.35);
  yield* flashHighlight(card(), colors.accentC);
  yield* waitFor(0.2);

  yield* beginSlide('counting-end');
  yield* all(milestoneA().fill(colors.text, 0.35), milestoneB().fill(colors.text, 0.35));
});
