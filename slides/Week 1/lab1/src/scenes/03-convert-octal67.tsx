import {Layout, Rect, Txt, makeScene2D} from '@motion-canvas/2d';
import {all, beginSlide, createRef} from '@motion-canvas/core';
import {createSlideFrame, flashHighlight, revealSlideHeader} from './helpers';
import {colors, fonts} from '../styles';

export default makeScene2D(function* (view) {
  const frame = createSlideFrame(
    view,
    'CONVERTING INTEGERS (Exercise a)',
    'Octal(67) -> Decimal -> Base 6 and Base 7',
  );

  const toDec = createRef<Rect>();
  const toDecLine = createRef<Txt>();

  const base6 = createRef<Rect>();
  const base6Row1 = createRef<Txt>();
  const base6Row2 = createRef<Txt>();
  const base6Row3 = createRef<Txt>();
  const base6Result = createRef<Txt>();

  const base7 = createRef<Rect>();
  const base7Row1 = createRef<Txt>();
  const base7Row2 = createRef<Txt>();
  const base7Row3 = createRef<Txt>();
  const base7Result = createRef<Txt>();

  frame.panel().add(
    <Layout direction={'column'} gap={22} width={1600}>
      <Rect
        ref={toDec}
        fill={'#182246'}
        radius={18}
        stroke={colors.line}
        lineWidth={2}
        padding={24}
      >
        <Txt
          ref={toDecLine}
          text={'67_8 = 6 x 8^1 + 7 x 8^0 = 48 + 7 = 55_10'}
          fontFamily={fonts.mono}
          fill={colors.text}
          fontSize={46}
          opacity={0}
        />
      </Rect>

      <Layout direction={'row'} gap={24}>
        <Rect
          ref={base6}
          width={780}
          fill={'#1a2a42'}
          radius={16}
          stroke={colors.line}
          lineWidth={2}
          padding={22}
          layout
          direction={'column'}
          gap={12}
        >
          <Txt text={'To base 6 (repeated division)'} fontFamily={fonts.primary} fill={colors.accentB} fontSize={36} />
          <Txt ref={base6Row1} text={'55 / 6 = 9   remainder 1'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base6Row2} text={'9 / 6 = 1   remainder 3'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base6Row3} text={'1 / 6 = 0   remainder 1'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base6Result} text={'Read remainders upward: 131_6'} fontFamily={fonts.primary} fill={colors.softText} fontSize={34} opacity={0} />
        </Rect>

        <Rect
          ref={base7}
          width={780}
          fill={'#1a2a42'}
          radius={16}
          stroke={colors.line}
          lineWidth={2}
          padding={22}
          layout
          direction={'column'}
          gap={12}
        >
          <Txt text={'To base 7 (repeated division)'} fontFamily={fonts.primary} fill={colors.accentC} fontSize={36} />
          <Txt ref={base7Row1} text={'55 / 7 = 7   remainder 6'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base7Row2} text={'7 / 7 = 1   remainder 0'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base7Row3} text={'1 / 7 = 0   remainder 1'} fontFamily={fonts.mono} fill={colors.text} fontSize={38} opacity={0} />
          <Txt ref={base7Result} text={'Read remainders upward: 106_7'} fontFamily={fonts.primary} fill={colors.softText} fontSize={34} opacity={0} />
        </Rect>
      </Layout>
    </Layout>,
  );

  yield* revealSlideHeader(frame);

  yield* beginSlide('octal-to-decimal');
  yield* toDecLine().opacity(1, 0.7);
  yield* flashHighlight(toDec(), colors.accentA);

  yield* beginSlide('to-base6');
  yield* base6Row1().opacity(1, 0.35);
  yield* base6Row2().opacity(1, 0.35);
  yield* base6Row3().opacity(1, 0.35);
  yield* base6Result().opacity(1, 0.4);
  yield* flashHighlight(base6(), colors.accentB);

  yield* beginSlide('to-base7');
  yield* base7Row1().opacity(1, 0.35);
  yield* base7Row2().opacity(1, 0.35);
  yield* base7Row3().opacity(1, 0.35);
  yield* base7Result().opacity(1, 0.4);
  yield* flashHighlight(base7(), colors.accentC);

  yield* beginSlide('conversion-end');
  yield* all(base6Result().fill(colors.text, 0.35), base7Result().fill(colors.text, 0.35));
});
