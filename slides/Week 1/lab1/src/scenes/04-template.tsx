import {Layout, Rect, Txt, makeScene2D} from '@motion-canvas/2d';
import {beginSlide, createRef} from '@motion-canvas/core';
import {createSlideFrame, revealSlideHeader} from './helpers';
import {colors, fonts} from '../styles';

export default makeScene2D(function* (view) {
  const frame = createSlideFrame(
    view,
    'DIY Template',
    'Duplicate this scene and replace text/steps for new exercises',
  );

  const prompt = createRef<Txt>();
  const step1 = createRef<Txt>();
  const step2 = createRef<Txt>();
  const result = createRef<Txt>();

  frame.panel().add(
    <Layout direction={'column'} width={1600} gap={18}>
      <Rect fill={'#1a2547'} radius={16} stroke={colors.line} lineWidth={2} padding={22}>
        <Txt
          ref={prompt}
          text={'Prompt: Replace this with your next lab exercise'}
          fontFamily={fonts.primary}
          fill={colors.text}
          fontSize={42}
          opacity={0}
        />
      </Rect>
      <Rect fill={'#1a2a42'} radius={16} stroke={colors.line} lineWidth={2} padding={22}>
        <Txt ref={step1} text={'Step 1: Setup / convert to decimal'} fontFamily={fonts.mono} fill={colors.softText} fontSize={38} opacity={0} />
      </Rect>
      <Rect fill={'#1a2a42'} radius={16} stroke={colors.line} lineWidth={2} padding={22}>
        <Txt ref={step2} text={'Step 2: Repeated division or grouping'} fontFamily={fonts.mono} fill={colors.softText} fontSize={38} opacity={0} />
      </Rect>
      <Rect fill={'#1a2547'} radius={16} stroke={colors.line} lineWidth={2} padding={22}>
        <Txt ref={result} text={'Result: final number in target base'} fontFamily={fonts.primary} fill={colors.accentA} fontSize={40} opacity={0} />
      </Rect>
    </Layout>,
  );

  yield* revealSlideHeader(frame);
  yield* beginSlide('template-prompt');
  yield* prompt().opacity(1, 0.5);
  yield* beginSlide('template-step1');
  yield* step1().opacity(1, 0.4);
  yield* beginSlide('template-step2');
  yield* step2().opacity(1, 0.4);
  yield* beginSlide('template-result');
  yield* result().opacity(1, 0.45);
});
