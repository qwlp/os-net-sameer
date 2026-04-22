import {
  Layout,
  Line,
  Rect,
  Txt,
} from '@motion-canvas/2d';
import {
  all,
  createRef,
  createSignal,
  easeInOutCubic,
  waitFor,
} from '@motion-canvas/core';
import {colors, fonts, pacing} from '../styles';

type SlideTitleRefs = {
  title: () => Txt;
  subtitle: () => Txt;
};

export function createSlideFrame(
  view: Layout,
  titleText: string,
  subtitleText: string,
  showHeader: boolean = true,
) {
  const panel = createRef<Rect>();
  const title = createRef<Txt>();
  const subtitle = createRef<Txt>();
  const divider = createRef<Line>();

  view.add(
    <Rect
      width={'100%'}
      height={'100%'}
      fill={colors.bg}
      layout
      direction={'column'}
      justifyContent={'start'}
      alignItems={'center'}
      padding={64}
      gap={24}
    >
      <Rect
        ref={panel}
        width={1760}
        height={920}
        fill={colors.panel}
        radius={0}
        stroke={colors.line}
        lineWidth={0}
        layout
        direction={'column'}
        alignItems={'start'}
        padding={52}
        gap={20}
      >
        {showHeader ? (
          <>
            <Txt
              ref={title}
              text={titleText}
              fill={colors.text}
              fontFamily={fonts.primary}
              fontWeight={700}
              fontSize={62}
              opacity={0}
            />
            <Txt
              ref={subtitle}
              text={subtitleText}
              fill={colors.softText}
              fontFamily={fonts.primary}
              fontWeight={500}
              fontSize={36}
              opacity={0}
            />
            <Line
              ref={divider}
              lineWidth={4}
              stroke={colors.accent}
              end={0}
              points={[
                [-780, 0],
                [780, 0],
              ]}
            />
          </>
        ) : null}
      </Rect>
    </Rect>,
  );

  return {
    panel,
    title,
    subtitle,
    divider,
  } as SlideTitleRefs & {
    panel: () => Rect;
    divider: () => Line;
  };
}

export function* revealSlideHeader(refs: {
  title: () => Txt;
  subtitle: () => Txt;
  divider: () => Line;
}) {
  yield* all(
    refs.title().opacity(1, pacing.write),
    refs.subtitle().opacity(1, pacing.write + 0.2),
    refs.divider().end(1, pacing.write + 0.1),
  );
  yield* waitFor(pacing.pause);
}

export function* flashHighlight(box: Rect, color: string = colors.accent) {
  const glow = createSignal(0);
  box.shadowBlur(() => 0 * glow());
  box.shadowColor(color);
  yield* glow(1, 0.3, easeInOutCubic);
  yield* glow(0, 0.45, easeInOutCubic);
}
