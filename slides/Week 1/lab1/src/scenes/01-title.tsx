import {Layout, Rect, Txt, makeScene2D} from '@motion-canvas/2d';
import {all, beginSlide, createRef} from '@motion-canvas/core';
import {createSlideFrame, revealSlideHeader} from './helpers';
import {colors, fonts} from '../styles';

export default makeScene2D(function* (view) {
  const frame = createSlideFrame(
    view,
    'Lab 1: Number Systems (Animated)',
    'All exercises except floating-point base conversions',
  );

  const body = createRef<Layout>();
  const focusA = createRef<Rect>();
  const focusB = createRef<Rect>();
  const navHint = createRef<Txt>();

  frame.panel().add(
    <Layout ref={body} direction={'column'} gap={28} marginTop={12} width={1600}>
      <Rect
        ref={focusA}
        fill={'#101a30'}
        radius={18}
        stroke={colors.line}
        lineWidth={2}
        padding={24}
        opacity={0}
      >
        <Txt
          text={'Section 1: COUNTING (a, b, c)'}
          fontFamily={fonts.primary}
          fill={colors.text}
          fontSize={42}
        />
      </Rect>
      <Rect
        ref={focusB}
        fill={'#101a30'}
        radius={18}
        stroke={colors.line}
        lineWidth={2}
        padding={24}
        opacity={0}
      >
        <Txt
          text={'Section 2/3/4: integer conversions (all exercises)'}
          fontFamily={fonts.primary}
          fill={colors.text}
          fontSize={42}
        />
      </Rect>
      <Txt
        ref={navHint}
        text={'Use Left/Right arrow keys in presenter mode to navigate slides.'}
        fontFamily={fonts.primary}
        fill={colors.softText}
        fontSize={34}
        opacity={0}
      />
    </Layout>,
  );

  yield* revealSlideHeader(frame);
  yield* beginSlide('title-focus');
  yield* all(focusA().opacity(1, 0.6), focusB().opacity(1, 0.6));
  yield* navHint().opacity(1, 0.5);
  yield* beginSlide('title-end');
});
